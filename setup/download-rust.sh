
set -Ceu

rust_version=1.35.0

export RUSTUP_HOME="$HOME/.mydocker/var/packages/rust"
export CARGO_HOME="$RUSTUP_HOME"
if [ ! -e $RUSTUP_HOME/bin/rstup ]; then (
    curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y --default-toolchain none
); fi
if ! "${RUSTUP_HOME}/bin/rustup" toolchain list | grep "$rust_version-" >/dev/null; then
    "${RUSTUP_HOME}/bin/rustup" toolchain install "$rust_version"
fi

