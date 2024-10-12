{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.bat
          pkgs.btop
          pkgs.cmake
          pkgs.cmatrix
          pkgs.fd
          pkgs.ffmpeg
          pkgs.fzf
          pkgs.eza
          pkgs.gcc
          pkgs.git
          pkgs.gnumake
          pkgs.lazygit
          pkgs.lua
          pkgs.nodejs
          pkgs.neovim
          pkgs.python3
          pkgs.ripgrep
          pkgs.starship
          pkgs.stow
          pkgs.tmux
          pkgs.vim
          pkgs.wget
          pkgs.yazi
          pkgs.zoxide
          pkgs.zsh-autosuggestions
          pkgs.zsh-history-substring-search
          pkgs.zsh-syntax-highlighting
          pkgs.zsh-vi-mode
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacBook-Pro
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MacBook-Pro".pkgs;
  };
}
