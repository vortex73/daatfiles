#zmodload zsh/zprof
# Lines configured by zsh-newuser-install
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
  exec tmux
fi
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
bindkey '^R' history-incremental-search-backward
alias neofetch="fastfetch"
alias sx="startx"
alias space="dust"
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
autoload -Uz vcs_info
autoload -U colors && colors
export PS1="%F{cyan}%n%f[\w] >>"
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
precmd() { vcs_info }
compinit
export VISUAL=nvim
export EDITOR="$VISUAL"
plugins=(git shh-agent)

n ()
{
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}
trap nnn_cd EXIT
unsetopt prompt_cr prompt_sp
zstyle ':vcs_info:git:*' formats ' on %F{82}%b%f'
setopt PROMPT_SUBST
export PATH=$PATH:/home/vorrtt3x/.cargo/bin
export PATH=$PATH:/home/vorrtt3x/cloned/ziglang
export PATH=$PATH:/home/vorrtt3x/.nimble/bin
export PATH=$PATH:/usr/lib/xscreensaver
export PATH=$PATH:/home/vorrtt3x/cloned/zls/zig-out/bin
export PATH=$PATH:/home/vorrtt3x/dev/ludicrosity/zig-out/bin
export NNN_BMS="d:$HOME/Documents;u:/home/vorrtt3x/Cam Uploads;D:$HOME/Downloads/"
alias tasks="nvim ~/.tasks.md"
alias la="eza -la --git-repos --icons"
alias ls="eza --icons"
alias lo="eza -l --git-repos --icons"
alias lt="eza --tree"
alias lc="eza --git-ignore --tree --icons"
PROMPT='%B%F{130}%n%f [%F{82}%~%f]${vcs_info_msg_0_} %F{50}% %f '
alias armsim="mono ~/Downloads/ARMSim.exe"
source /home/vorrtt3x/cloned/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#DistroBuild
export LFS=/mnt/salazar


alias ideas="bat ~/ideas.md"
#zprof

export PATH=$HOME/.local/bin:$PATH
