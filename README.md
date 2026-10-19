# occ releases

`occ` is the command line and the node of [Office Cockpit](https://cockpit.kairelio.com): it signs you in,
manages your spaces, connections, sources and views, and runs `occ node`, which connects this machine to
the Office Cockpit plane so it can collect from GitHub with your local `gh` and start coding sessions.

This repository holds **release binaries only**. The source code is private.

## Install

Homebrew is the only supported way to install occ (macOS and Linux, Apple Silicon/arm64 and Intel/x86-64):

    brew install kairelio-hq/tap/occ

Upgrade with `brew upgrade occ`, remove with `brew uninstall occ`. See
[kairelio-hq/homebrew-tap](https://github.com/kairelio-hq/homebrew-tap).

Then:

    occ login https://cockpit.kairelio.com        # sign in from this machine
    occ register https://cockpit.kairelio.com     # make it a node; installs the "Office Cockpit Node" service

## Releases

Each [release](https://github.com/kairelio-hq/occ-releases/releases) `v<version>` has one archive per
platform, `occ-<version>-<target>.tar.gz` (`aarch64-apple-darwin`, `x86_64-apple-darwin`,
`aarch64-unknown-linux-musl`, `x86_64-unknown-linux-musl`; the Linux builds are static), and a
`SHA256SUMS` file. The macOS binaries are not signed or notarized; Homebrew installs them without
quarantine.

## License

Proprietary, free to use. See [LICENSE](LICENSE).
