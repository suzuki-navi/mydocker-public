
export PYENV_SHELL=zsh
source "$HOME/.pyenv/completions/pyenv.zsh"
command pyenv rehash 2>/dev/null
pyenv() {
    local command
    command="${1:-}"
    if [ "$#" -gt 0 ]; then
        shift
    fi

    case "$command" in
        rehash|shell)
            eval "$(pyenv "sh-$command" "$@")";;
        *)
            command pyenv "$command" "$@";;
    esac
}

if [ -e $HOME/.mydocker/private/.zshrc ]; then
    source $HOME/.mydocker/private/.zshrc
fi

