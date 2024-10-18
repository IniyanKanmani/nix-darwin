# nix-darwin

## Update lock file to latest packages versions

```bash
nix flake update
```

## Rebuild flake.nix

Rebuilding flake should rebuild home.nix too.

```bash
darwin-rebuild switch --flake ./#MacBook-Pro
```

## Rebuild home.nix

```bash
home-manager switch --flake ./#apple
```

## Cleanup old packages

```bash
nix-collect-garbage
```
