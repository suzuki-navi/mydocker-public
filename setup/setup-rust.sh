
bash $HOME/.mydocker/setup/download-rust.sh

export RUSTUP_HOME="$HOME/.mydocker/var/packages/rust"
export CARGO_HOME="$RUSTUP_HOME"

export PATH=$RUSTUP_HOME/bin:$PATH

