PATH=$PATH:~/local/bin:~/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# set PROMPT, RPROMPT
autoload -U colors
colors
setopt prompt_subst
case ${UID} in
0)
        #PROMPT="[%n@%m]$ "
        #RPROMPT="%~"
        #PROMPT2="%_%% "
        #SPROMPT="%r is correct? [n,y,a,e]: "
        PROMPT="%B%{${fg[red]}%}%n@%m %/#%{${reset_color}%}%b "
        PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
        SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        ;;
*)
        #PROMPT="%{${fg[cyan]}%}[%n@%m %~]%{${reset_color}%}$ "
        # PROMPT="%{${fg[cyan]}%}[%n@%m]%{${reset_color}%}$ "
        PROMPT="%{%(?.${fg[cyan]}.${fg[red]})%}[%n@%m]%{${reset_color}%}$ "
        RPROMPT="%{${fg[cyan]}%}%~%{${reset_color}%}"
        PROMPT2="%{${fg[cyan]}%}%_%%%{${reset_color}%} "
        SPROMPT="%{${fg[cyan]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
        ;;
esac

# cd
setopt auto_cd
function chpwd(){ls -F --color=tty}
#by cd -[tab]
setopt auto_pushd

# autocorrect
setopt correct
setopt list_packed
setopt noautoremoveslash
setopt noautoremoveslash

# keybind emacs
bindkey -e

#string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

# completion
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit

autoload zed

setopt complete_aliases # aliased ls needs if file/dir completions work

hosts=( ${(@)${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && < ~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*} )

# .ssh/configに指定したホストをsshなどの補完候補に
zstyle ':completion:*:hosts' hosts $hosts
## scpのリモートファイルを補完しない。パスワード聞かれるので。
#zstyle ':completion:*:complete:scp:*:files' command command -


if [ -f ${DOTFILES}/alias ]
then
    source ${DOTFILES}/alias
fi

alias where="command -v"
alias j="jobs -l"

# terminal
unset LSCOLORS
case "${TERM}" in
dumb*|emacs*)
  PROMPT="[%n@%m %~]$ "
  PROMPT2="%_%% "
  SPROMPT="%r is correct? [n,y,a,e]: "
  ;;

xterm)
  export TERM=xterm-color
  ;;
kterm)
  export TERM=kterm-color
  # set BackSpace control character
  stty erase
  ;;
cons25)
  unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad
#  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
  zstyle ':completion:*' list-colors \
      'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
esac

case "${TERM}" in
kterm*|xterm*)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
  }
  export LSCOLORS=exfxcxdxbxegedabagacad
  #export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
  ;;
esac

setopt NO_BEEP
setopt RC_EXPAND_PARAM


## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
