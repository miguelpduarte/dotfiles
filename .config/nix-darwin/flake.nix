# TODO: Maybe move this to nixos-configs repo? Single source of truth for all "infra" then :)
{
  description = "My Darwin system flake";

  inputs = {
    # Using releases to try and be more stable, overriding only if necessary.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # Used sparingly for newer versions of packages.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, nix-rosetta-builder }:
  let
    configuration = { pkgs, nixpkgs-unstable, lib,  ... }:
      let
	pkgs-unstable = nixpkgs-unstable.legacyPackages.${pkgs.system};
      in
    {
      nixpkgs.config.allowUnfree = true; # Sadly eventually had to
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        with pkgs; [
	  # essentials
	  git # apple provided is older
	  # personal productivity
	  neovim
	  ripgrep
	  fd
	  fzf
	  jq
	  gh # required by octo.nvim
	  shellcheck
	  # For dotfile management, finally went with an automated tool, even though it's not 100% because it kinda depends on the host as well...
	  # But at least it's easy...
	  stow

	  # window management? Taking a latest-er version for "config-version = 2"
	  pkgs-unstable.aerospace

	  # other
	  obsidian
	  # Trying this out for presentations instead of Remark, so far so good
	  pkgs-unstable.presenterm
	  ## terminal
	  # unstable wezterm reduced crashes and seems otherwise fine - so leaving it in unstable for now.
	  pkgs-unstable.wezterm
	  tmux
	  # organization
	  taskwarrior3
	  tasksh # might not need it, but trying it
	  # TODO: Make taskopen work in nix-darwin :( using it via homebrew for now
	  # taskopen # useful for extended notes. Let's see how it plays with the Obsidian plugin

	  # python312Packages.bugwarrior # trying it, would get tasks from e.g. JIRA, GitHub

	  # 1.8.0 is OOOOLLLLDD and breaks with python >3.12. See:
	  # See:
	  # - https://github.com/GothenburgBitFactory/bugwarrior/issues/1050#issuecomment-2130661470
	  # - https://github.com/GothenburgBitFactory/bugwarrior/issues/1030#issuecomment-2086146053
	  # ref for fix:
	  # https://git.ingolf-wagner.de/palo/nixos-config/commit/07d807c4db3a6240ae15761c4ff7e9f2f024c06d?files=nixos/components#diff-3a3879a63e88b4537fbe5b4699d6bc38ce4cf0a7
	  # (but had to adapt. overrideAttrs for example doesn't really work for what we want here)
	  (with pkgs-unstable.python311Packages; bugwarrior.overridePythonAttrs (old: {
	    # Waiting for 2.0 release: https://github.com/GothenburgBitFactory/bugwarrior/issues/1030
	    version = "develop";
	    format = "pyproject";
	    src = pkgs.fetchFromGitHub {
	      owner = "GothenburgBitFactory";
	      repo = "bugwarrior";
	      rev = "d166c3fe63bd541f72436d1d266bfdd43b76b87a";
	      sha256 = "sha256-xpodsk4iAcZUgFsi1s1C9w3xshQtn2Vao4ZqowVst78=";
	    };
	    propagatedBuildInputs = old.propagatedBuildInputs ++ [
	      pydantic
	      tomli
	      # We need a more recent version of the jira python package because of the search endpoint being deprecated:
	      # https://github.com/pycontribs/jira/pull/2326
	      # (stable nixpkgs has 3.9.4, we need >3.10.0 ; unstable has 3.10.5 (latest))
	      pkgs-unstable.python311Packages.jira

	      # ini2toml is not in nixpkgs apparently
	      # TODO: try and bundle it, tbh just for the learning experience.
	      # buildPythonPackage {
		# pname = "ini2toml";
		# version = "0.15";
		# src = fetchPypi {
		  # inherit pname version;
		  # hash = lib.fakeHash;
		# };
	      # }
	    ];
	  }))

	  # company tools
	  wireguard-tools
	  awscli2
	  # tunnelto # Throws `Control error: WebSocketError(Io(Custom { kind: UnexpectedEof, error: "tls handshake eof" })).`

	  # Programming deps/LSPs/etc
	  ## for Rust
	  rustup # accidentally installed from the script, but should use the nix one instead...
	  # cargo etc, installed via rustup directly for now
	  cargo-nextest # trying it out, useful for running tests quickly

	  # Lua LSP
	  lua-language-server
	  # Nix LSP
	  nil
	  # Terraform LSP
	  terraform-ls
	  # jsonnet LSP from grafana
	  jsonnet-language-server

	  # node-related for LSP
	  # for vscode-eslint-language-server, vscode-json-language-server
	  vscode-langservers-extracted
          nodePackages_latest.typescript-language-server # typescript-language-server
	  # typescript # tsserver is actually here? # Nope, this simply provides a global TS which is useful but also misleading.
	  tailwindcss-language-server
	  svelte-language-server
	  emmet-language-server
        ];

      programs.direnv.enable = true;

      fonts.packages = with pkgs; [
	nerd-fonts.hack
	nerd-fonts.comic-shanns-mono
	nerd-fonts.commit-mono
	# Extra characters via this font, just to display more characters. No longer needed to fix crashing, thankfully!
	noto-fonts-cjk-sans
      ];

      environment.variables = {
	EDITOR = "nvim";
	PRESENTERM_CONFIG_FILE="~/.config/presenterm/config.yaml";
      };

      # Homebrew needs to be installed directly, sadly
      homebrew.enable = true;
      homebrew.casks = [
        {
	  name = "middleclick";
	  args = { no_quarantine = true; };
	}
	"rectangle"
	"alt-tab"
	# TODO: Try out spotifyd instead
	"spotify"
	"tableplus" # Seems to also manage updates by itself, not sure how this works also because of licenses and stuff.
	"raycast"
	"slack" # previously directly downloaded from website, check for conflicts
	"parallels"
	"fly" # Because we need to have r/w for the binary since it needs to match the version in our concourse instance
      ];
      homebrew.taps = [
	"tunneltodev/tap"
      ];
      homebrew.brews = [
	"mingw-w64" # For rust cross compilation to windows...
	"tunneltodev/tap/tunnelto" # ngrok-like, broken on nixpkgs at the moment
	# taskopen is currently not working on nixpkgs for nix-darwin, despite being available in homebrew.
	{
	  name = "taskopen";
	  # For some silly reason, it lists "task" as a dependency, but it's actually a separate binary, so we skip that since we install "task" via nix
	  args = [ "ignore-dependencies" ];
	}
	# Needed for `presenterm` PDF exporting - sadly also broken on nixpkgs at the moment, and this is easier than python deps...
	"weasyprint"
      ];
      # Uninstall formulae not in this conf. This is the source of truth.
      # TODO: Consider using 'zap' instead.
      homebrew.onActivation.cleanup = "uninstall";

      system.defaults = {
	dock = {
	  autohide = true;
	  show-recents = false;
	  mru-spaces = false;
	  orientation = "bottom";
	};
        finder.AppleShowAllExtensions = true;
	# https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.WindowManager.AppWindowGroupingBehavior
	# I think this fixes switching windows with 3-finger Mission Control - all windows are no longer focused when switching.
	# false means "One at a time"
	WindowManager.AppWindowGroupingBehavior = false;

	# Aka: "Displays have separate Spaces"
	# Not recommended by Aerospace: https://nikitabobko.github.io/AeroSpace/guide#emulation-of-virtual-workspaces
	spaces.spans-displays = true;

	# Trying to make Control Center/Menu Bar less terrible (also idk why but this kept getting reset when set in UI)
	# Hide Bluetooth, Now Playing & WiFi in menubar - they're in control center...
	controlcenter.Bluetooth = false;
	controlcenter.NowPlaying = false;
	# TODO: WiFi... not yet in nix-darwin opts...

	NSGlobalDomain.NSWindowShouldDragOnGesture = true;
	# "Make it fast"
	NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
      };
      system.keyboard = {
	enableKeyMapping = true;
        remapCapsLockToControl = true;
	nonUS.remapTilde = true;
      };
      security.pam.services.sudo_local.touchIdAuth = true;
      # Make touchId sudo work inside tmux, surviving "re-logins" :)
      # https://github.com/nix-darwin/nix-darwin/issues/985
      # Note: Might cause some issues with SSH? (https://github.com/nix-darwin/nix-darwin/pull/1344#issuecomment-2738164190)
      security.pam.services.sudo_local.reattach = true;

      # nix.package = pkgs.nix;
      # Make old commands work, references:
      # https://discourse.nixos.org/t/how-to-resolve-nixpkgs-was-not-found-error-without-channels/47258
      # https://github.com/NixOS/nix/issues/2982
      nix.settings.nix-path = "nixpkgs=flake:nixpkgs";
      nix.gc = {

	automatic = true;
	# interval = { Weekday = 0; Hour = 0; Minute = 0; };
	# options = "--delete-older-than 30d"; # TODO: Decide
      };
      nix.optimise = {
	automatic = true;
	# interval = { Weekday = 0; Hour = 0; Minute = 0; };
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      nix.settings.trusted-users = [
	"root"
	"migueld"
	# Supposedly needed for linux-builder: https://nixcademy.com/posts/macos-linux-builder/#%EF%B8%8F-the-nix-darwin-option
	# (seems harmless anyway, just adds the @admin group and "@admin means all users in the wheel group")
	"@admin"
      ];
      # NOTE: Only does same arch ootb, moved to `nix-rosetta-builder` below Apparently just does same arch... so only really linux ARM :/ (still good for RPis or whatever but doesn't help me with the current deployments...)
      nix.linux-builder = {
	enable = false;
	ephemeral = true; # Enable just for the first couple of runs, then disable after it's working (as per blogpost recommendations). We want to cache the nix store stuff and I don't care about the runner getting full (especially if it can `gc` itself anyway (?))
	# INFO: No longer needed since we now get the `nix-rosetta-builder`. Just leaving the default stuff above for ref so we can uncomment/re-enable if needed for another fresh setup later.
	# config.virtualisation = {
	#   # Defaults are supposedly 1 core, 3GB RAM and 20GB disk. Let's beef it up!
	#   # See also: https://nixcademy.com/posts/macos-linux-builder/#%EF%B8%8F-improving-the-linux-builder-setup
	#   cores = 6;
	#   darwin-builder = {
	#     diskSize = 40 * 1024;
	#     memorySize = 8 * 1024;
	#   };
	# };
      };
      # https://github.com/cpick/nix-rosetta-builder seems to be better. Just requires the above for bootstrapping initially
      nix-rosetta-builder = {
	enable = true;
	diskSize = "40GiB";
	memory = "8GiB";
	onDemand = true;
	onDemandLingerMinutes = 60;
      };

      # As per the error instructions, specifying the primary user
      # TODO: Move the relevant configurations to the user scope so that this is no longer an issue.
      system.primaryUser = "migueld";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
	  # THIS IS IMPORTANT -> don't forget about it!
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
    config-modules = [
      nix-rosetta-builder.darwinModules.default
      configuration
    ];
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Miguels-MacBook-Pro
    darwinConfigurations."Miguels-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = config-modules;
      specialArgs = { inherit nixpkgs-unstable; };
    };

    # New mbp has a different hostname and nix-darwin gets confused lol
    darwinConfigurations."MBP-migueld" = nix-darwin.lib.darwinSystem {
      modules = config-modules;
      specialArgs = { inherit nixpkgs-unstable; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MBP-migueld".pkgs;
  };
}
