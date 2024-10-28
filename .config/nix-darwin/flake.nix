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
	  jq

	  # other
	  obsidian
	  # terminal emulator
	  wezterm
	  tmux

	  # company tools
	  wireguard-tools
	  awscli2

	  # Programming deps/LSPs/etc
	  ## for Rust
	  rustup # accidentally installed from the script, but should use the nix one instead...
	  # cargo etc, installed via rustup directly for now
	  # Actually, I think I have to enable these otherwise it will be weird
	  # TODO: Figure out if there's a way to install rust stable and nightly declaratively
	  # Also rustup target add x86_64-pc-windows-gnu
	  # clippy # collision, I think rustup brings it along already
	  # rust-analyzer
	  cargo-nextest # trying it out, useful for running tests quickly

	  # Nix LSP
	  nil

	  # node-related for LSP
	  vscode-langservers-extracted # for vscode-eslint-language-server
          nodePackages_latest.typescript-language-server # typescript-language-server
	  typescript # tsserver is actually here?
        ];
	
	# TODO: git config here

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
      ];

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

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;
      # Make old commands work, references:
      # https://discourse.nixos.org/t/how-to-resolve-nixpkgs-was-not-found-error-without-channels/47258
      # https://github.com/NixOS/nix/issues/2982
      nix.settings.nix-path = "nixpkgs=flake:nixpkgs";

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

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
