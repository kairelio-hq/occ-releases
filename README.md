# occ releases

`occ` is the command line and the node of [Office Cockpit](https://cockpit.kairelio.com): it signs you in,
manages your spaces, connections, sources and views, and runs `occ node`, which connects this machine to
the Office Cockpit plane so it can collect from GitHub with your local `gh` and start coding sessions.

This repository hosts the release binaries and installer. The OCC source code is private.

## Install

OCC supports macOS and Linux on arm64 and x86-64.

### Install without sudo

```sh
curl -fsSL https://raw.githubusercontent.com/kairelio-hq/occ-releases/main/install.sh | sh
```

The installer checks the release archive against its SHA-256 checksum and puts `occ` in
`$HOME/.local/bin`. If that directory is new to your shell, add it to your shell startup file:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Run the same install command to upgrade. The installer records the installation source in
`.occ-install` next to the binary. Remove the installation with
`rm "$HOME/.local/bin/occ" "$HOME/.local/bin/.occ-install"`.
Set `OCC_VERSION` to pin a version or `OCC_INSTALL_DIR` to choose a different absolute,
writable directory. Pass those variables to the `sh` side of the pipe. For example:

```sh
curl -fsSL https://raw.githubusercontent.com/kairelio-hq/occ-releases/main/install.sh |
  OCC_VERSION=0.9.5 OCC_INSTALL_DIR="$HOME/bin" sh
```

### Install with Homebrew

```sh
brew install kairelio-hq/tap/occ
```

Upgrade with `brew upgrade occ`, remove with `brew uninstall occ`. See
[kairelio-hq/homebrew-tap](https://github.com/kairelio-hq/homebrew-tap).

Then:

    occ login https://cockpit.kairelio.com        # sign in from this machine
    occ register https://cockpit.kairelio.com     # make it a node; installs the "Office Cockpit Node" service

For environments without a user service manager, register with `occ register --no-service <plane-url>`
and start the node with `occ node`. Restart a running node after upgrading its binary.

## Releases

Each [release](https://github.com/kairelio-hq/occ-releases/releases) `v<version>` has one archive per
platform, `occ-<version>-<target>.tar.gz` (`aarch64-apple-darwin`, `x86_64-apple-darwin`,
`aarch64-unknown-linux-musl`, `x86_64-unknown-linux-musl`; the Linux builds are static), and a
`SHA256SUMS` file. The macOS binaries are not signed or notarized; Homebrew installs them without
quarantine.

## License

Proprietary, free to use. See [LICENSE](LICENSE).
