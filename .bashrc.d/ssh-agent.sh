#!/bin/bash

# Check if we are running in a WSL environment
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    # WSL detected, set up SSH agent forwarding with npiperelay
    [ ! -d "$HOME/.ssh" ] && mkdir -p "$HOME/.ssh"
    [ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
    if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
        WINDOWS_LOCALAPPDATA="$(wslpath "$(cmd.exe /C "echo %LOCALAPPDATA%" 2> /dev/null | tr -d '\r')")"
        NPIPERELAY="$WINDOWS_LOCALAPPDATA/Microsoft/WinGet/Packages/albertony.npiperelay_Microsoft.Winget.Source_8wekyb3d8bbwe/npiperelay.exe"
        rm -f "$SSH_AUTH_SOCK"
        ( setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:"$NPIPERELAY -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
    fi
    export SSH_AUTH_SOCK
    unset WINDOWS_LOCALAPPDATA
    unset NPIPERELAY
fi