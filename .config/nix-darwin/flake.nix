{
  description = "My Darwin system flake";

  inputs = {
    # Using releases to try and be more stable, overriding only if necessary.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # Used sparingly for newer versions of packages.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable }:
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

	  # other
	  obsidian
	  # terminal emulator
	  wezterm
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
	  typescript # tsserver is actually here?
	  svelte-language-server
	  emmet-language-server
        ];

      programs.direnv.enable = true;

      environment.variables = {
	EDITOR = "nvim";
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
	"tableplus"
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
      };
      system.keyboard = {
	enableKeyMapping = true;
        remapCapsLockToControl = true;
      };
      security.pam.services.sudo_local.touchIdAuth = true;

      # nix.package = pkgs.nix;
      # Make old commands work, references:
      # https://discourse.nixos.org/t/how-to-resolve-nixpkgs-was-not-found-error-without-channels/47258
      # https://github.com/NixOS/nix/issues/2982
      nix.settings.nix-path = "nixpkgs=flake:nixpkgs";

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

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
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Miguels-MacBook-Pro
    darwinConfigurations."Miguels-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
      specialArgs = { inherit nixpkgs-unstable; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Miguels-MacBook-Pro".pkgs;
  };
}
