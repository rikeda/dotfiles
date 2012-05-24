# Git function
function _set_git_branch() {
  local git_branch st color
  git_branch="${$(git symbolic-ref HEAD 2> /dev/null)#refs/heads/}"
  if [ $? != '0' ]; then
    return
  fi
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=%F{green}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=%F{yellow}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=%F{blue}
  else
    # color=%F{red}
    color=%F{cyan}
  fi
  echo " - [%{$color%}${git_branch}%f]"
}

function _set_left_prompt(){
  PROMPT=$'[%n@%m] - [%F{magenta}%~%f%1(v| %F{green}%1v%f|)]`_set_git_branch`\n$ '
}

function _set_prompt() {
  _set_left_prompt
  # 左側(2行目以降)
  PROMPT2="%B%{${fg[blue]}%}%_$%{${reset_color}%}%b "
  # 右側
  #RPROMPT=""
  # コマンドミス時
  SPROMPT="%{$fg_bold[red]%}correct%{$reset_color%}: %R -> %r ? "
}

################################################################

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

autoload -Uz compinit
compinit
bindkey -e

# ls colors
autoload colors; colors
#export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#export LS_COLORS='di=34:ln=34:so=34:pi=34:ex=34:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# di:ディレクトリ
# 30:黒, 31:赤, 32:緑, 33:茶, 34:青, 35:マゼンタ,36:シアン, 37:白, 39:デフォルト
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export EDITOR='vim'
export LANG='ja_JP.UTF-8'
export CC=gcc-4.2

# option
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct
setopt list_packed
setopt auto_menu
## prompt
setopt prompt_subst
setopt prompt_percent
setopt transient_rprompt

#
## history settings
#
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
## history
setopt share_history
setopt EXTENDED_HISTORY
function history-all { history -E 1 }
## history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# prompt setting
typeset -ga chpwd_functions
chpwd_functions+=_set_left_prompt
_set_prompt

# Alias Settings
alias v='vim'
alias g="git"
alias gb="git branch"
alias history="history -ni"

# ls options
case "${OSTYPE}" in
  freebsd*|darwin*)
    alias ls='ls -G'
    ;;
  linux*)
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    ;;
esac

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias tf='tail -f'
alias psa='ps aux'
alias reload='source ~/.zshrc'
alias be="bundle exec"
alias bo="bundle open"

if [ -e ~/.zshrc.include ]; then
  source ~/.zshrc.include
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
