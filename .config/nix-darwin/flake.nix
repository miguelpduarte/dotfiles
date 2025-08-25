{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs,  ... }: {
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
	  # TODO: Make taskopen work in nnix-darwin :( using it via homebrew for now
	  # taskopen # useful for extended notes. Let's see how it plays with the Obsidian plugin
	  python312Packages.bugwarrior # trying it, would get tasks from e.g. JIRA, GitHub

	  # company tools
	  wireguard-tools
	  awscli2

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
	# "tunneltodev/tap"
      ];
      homebrew.brews = [
	"mingw-w64" # For rust cross compilation to windows...
	# "nsis" # Broken on darwin nixpkgs :(
	# "llvm" # Kept just in case, was used for trying experimental tauri cross compilation to windows (also nsis above)
	# "tunneltodev/tap/tunnelto" # ngrok-like, broken on nixpkgs at the moment
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
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Miguels-MacBook-Pro".pkgs;
  };
}
