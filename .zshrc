# zmodload zsh/zprof
# Lines configured by zsh-newuser-install
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
#   exec tmux
# fi
HISTFILE=~/.histfile
HISTSIZE=10000
HISTFILESIZE=10000
SAVEHIST=10000
bindkey -v
export KEYTIMEOUT=1
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char
bindkey -v '^K' up-line-or-history
# bindkey '^R' history-incremental-search-backward
alias neofetch="fastfetch"
alias sx="startx"
alias space="dust"
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
autoload -Uz vcs_info
# autoload -U colors && colors
# export PS1="%F{cyan}%n%f[\w] >>"
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
precmd() { vcs_info }
compinit -C
export VISUAL=nvim
export EDITOR="$VISUAL"
if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi

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

# bindkey '^R' fzf-history-search

fzf-history-search() {
    BUFFER=$(history | fzf --tac | sed 's/ *[0-9]* *//')
    CURSOR=${#BUFFER}
    zle reset-prompt
}
zle -N fzf-history-search

rgf() {
  local file
  file=$(rg --color=always --line-number "$1" | fzf --ansi --preview 'bat --style=numbers --color=always {1}' --delimiter ':' --preview-window=up:70%:wrap)
  echo "$file" | cut -d':' -f1 | xargs -r $EDITOR
}

fzf-kill() {
  ps -ef | sed 1d | fzf --preview "echo {}" --header="Select process to kill" | awk '{print $2}' | xargs kill -9
}
alias fkill='fzf-kill'

bindkey '^T' autosuggest-or-fzf-history
autosuggest-or-fzf-history() {
  BUFFER=$(history | fzf --tac | sed 's/ *[0-9]* *//')
  CURSOR=${#BUFFER}
  zle reset-prompt
}
zle -N autosuggest-or-fzf-history

trap nnn_cd EXIT
setopt autocd
unsetopt prompt_cr prompt_sp
zstyle ':vcs_info:git:*' formats ' on %F{#87a987}%b%f'
setopt PROMPT_SUBST
export PATH=$PATH:/home/vorrtt3x/.cargo/bin
export PATH=$PATH:/home/vorrtt3x/cloned/ziglang
export PATH=$PATH:/home/vorrtt3x/.nimble/bin
export PATH=$PATH:/usr/lib/xscreensaver
export PATH=$PATH:/home/vorrtt3x/cloned/zls/zig-out/bin
export PATH=$PATH:/home/vorrtt3x/Downloads/ns-allinone-3.42/ns-3.42/build/include
export PATH=$PATH:/home/vorrtt3x/dev/ludicrosity/zig-out/bin
export PATH=$PATH:/home/vorrtt3x/cloned/asciinema/target/release
export PATH=$HOME/.local/bin:$PATH
export NNN_BMS="d:$HOME/Documents;u:/home/vorrtt3x/Cam Uploads;D:$HOME/Downloads/"
alias cast=" xrandr --output HDMI-1 --mode 1920x1080 --scale 1x1 --output eDP-1 --mode 2240x1400 --scale 0.857x0.771 --same-as HDMI-1"
alias icat="kitty +kitten icat --align=left"
alias tasks="nvim ~/.tasks.md"
alias grep="rg"
alias la="eza -la --git-repos --icons --hyperlink"
alias ls="eza --icons --hyperlink"
alias lo="eza -l --git-repos --icons"
alias lt="eza --tree"
alias lc="eza --git-ignore --tree --icons"
alias gco='git checkout $(git branch | fzf)'
alias vf='nvim $(find . -type f | fzf)'
alias pf='fzf --preview "bat --style=numbers --color=always --line-range=:500 {}"'
alias fd='cd $(find . -type d | fzf)'
# PROMPT=' %F{#8ba4b0}%~%f${vcs_info_msg_0_} %F{50}% ℵ%f '
PROMPT=' %F{#8ba4b0}$(if [[ $PWD == $HOME ]]; then echo "varchx"; else echo "${PWD/#$HOME/~}"; fi)%f${vcs_info_msg_0_} %F{50}% ℵ%f '
setopt interactivecomments

# PROMPT="%F{70}%M%f"
source /home/vorrtt3x/cloned/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_STYLES[comment]='fg=white'
alias s="kitten ssh"
alias broadcast="kitty +kitten broadcast -t state:active"
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
alias history="history 1"

source /usr/share/fzf/key-bindings.zsh
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# zprof
