#!/bin/sh

# Read the installer completely before changing any files when piped into sh.
main() {
    set -eu

    repo=https://github.com/kairelio-hq/occ-releases
    case "$(uname -s)" in
        Darwin) platform=apple-darwin ;;
        Linux) platform=unknown-linux-musl ;;
        *) fail "occ supports macOS and Linux" ;;
    esac
    case "$(uname -m)" in
        arm64|aarch64) arch=aarch64 ;;
        x86_64|amd64) arch=x86_64 ;;
        *) fail "occ supports arm64 and x86-64" ;;
    esac

    if [ -n "${OCC_VERSION:-}" ]; then
        version=${OCC_VERSION#v}
    else
        latest=$(fetch -o /dev/null -w '%{url_effective}' "$repo/releases/latest") ||
            fail "could not resolve the latest release"
        case "$latest" in
            "$repo/releases/tag/v"*) version=${latest#"$repo/releases/tag/v"} ;;
            *) fail "GitHub did not return a release tag" ;;
        esac
    fi
    case "$version" in
        *[!0-9.]*) fail "expected an OCC version like 0.9.5" ;;
    esac
    printf '%s\n' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' ||
        fail "expected an OCC version like 0.9.5"

    dest=${OCC_INSTALL_DIR:-${HOME:?HOME is not set}/.local/bin}
    case "$dest" in
        /*) ;;
        *) fail "OCC_INSTALL_DIR must be an absolute path" ;;
    esac
    archive=occ-$version-$arch-$platform.tar.gz
    release=$repo/releases/download/v$version

    umask 077
    tmp=$(mktemp -d "${TMPDIR:-/tmp}/occ-install.XXXXXX")
    staged=
    trap 'if [ -n "$staged" ]; then rm -f "$staged"; fi; rm -rf "$tmp"' EXIT
    trap 'exit 1' HUP INT TERM

    fetch -o "$tmp/$archive" "$release/$archive" || fail "could not download $archive"
    fetch -o "$tmp/SHA256SUMS" "$release/SHA256SUMS" || fail "could not download SHA256SUMS"
    expected=$(awk -v archive="$archive" '
        $2 == archive { count++; hash = $1 }
        END { if (count != 1 || length(hash) != 64 || hash !~ /^[0-9a-f]+$/) exit 1; print hash }
    ' "$tmp/SHA256SUMS") || fail "invalid or missing checksum for $archive"
    if command -v sha256sum >/dev/null 2>&1; then
        checksum=$(sha256sum < "$tmp/$archive")
    elif command -v shasum >/dev/null 2>&1; then
        checksum=$(shasum -a 256 < "$tmp/$archive")
    else
        fail "installing occ requires sha256sum or shasum"
    fi
    [ "${checksum%% *}" = "$expected" ] || fail "checksum mismatch for $archive"

    mkdir -p "$dest"
    [ ! -d "$dest/occ" ] || fail "$dest/occ is a directory"
    staged=$(mktemp "$dest/.occ.XXXXXX")
    tar -xOzf "$tmp/$archive" occ > "$staged" || fail "could not extract occ"
    [ -s "$staged" ] || fail "release contains an empty binary"
    chmod 0755 "$staged"
    mv -f "$staged" "$dest/occ"
    staged=
    printf 'Installed occ %s to %s/occ\n' "$version" "$dest"
    case ":$PATH:" in
        *":$dest:"*) ;;
        *) printf 'Add %s to PATH to run occ by name.\n' "$dest" ;;
    esac
}

fail() {
    printf 'occ install: %s\n' "$1" >&2
    exit 1
}

fetch() {
    curl -q --fail --silent --show-error --location --proto '=https' --proto-redir '=https' --connect-timeout 15 --retry 2 "$@"
}

main
