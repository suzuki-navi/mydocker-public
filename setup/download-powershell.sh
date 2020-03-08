
set -Ceu

if [ ! -e $HOME/.mydocker/var/packages/powershell ]; then (
    mkdir -p $HOME/.mydocker/var/packages/powershell
    cd $HOME/.mydocker/var/packages/powershell

    wget https://github.com/PowerShell/PowerShell/releases/download/v7.0.0/powershell-7.0.0-linux-x64.tar.gz
    tar xvzf powershell-7.0.0-linux-x64.tar.gz
); fi

if [ ! -e $HOME/bin2/powershell ]; then
    ln -s $HOME/.mydocker/var/packages/powershell/pwsh $HOME/bin2/pwsh
fi

