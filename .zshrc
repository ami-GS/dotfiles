#auto complete
autoload -Uz compinit
compinit
zstyle ':completion:*:default' menu select=2

zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

zstyle ':completion:*' group-name ''

zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

#spell check
setopt correct
setopt auto_menu
setopt list_packed
setopt list_types
setopt magic_equal_subst
setopt nolistbeep

#history
setopt hist_ignore_space
setopt hist_no_store
setopt hist_ignore_dups

#prompt
setopt prompt_subst
autoload colors
colors

#Emacs like key bind
bindkey -e

#history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SACEHIST=1000

#prompt
if [ ! -e $HOME/dotfiles/git-prompt.sh ]; then
    echo "Please Download git-prompt.sh "
else
    source $HOME/dotfiles/git-prompt.sh
fi

PROMPT_OPT=""
if [ "$INDOCKER" = y ]; then
    PROMPT_OPT="%F{5}docker%f"
fi
GIT_PS1_SHOWDIRTYSTATE=true
PS1=$PROMPT_OPT'%F{6}$(__git_ps1) %f%F{3}>> %f'
PROMPT=$PS1
RPROMPT='%F{white}%35<..<%~/%f'

#color
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export CLICOLOR=tru
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#conduct 'ls' after 'cd'
function cd(){
    builtin cd $@ && ls;
}

#git
export EDITOR='emacs -nw'

#lang
export locale=en_US.UTF-8

#Go
export PATH=$PATH:/usr/local/go/bin
if [ ! -e $HOME/Go ]; then
    mkdir $HOME/Go
fi
export GOPATH=$HOME/Go
export PATH=$PATH:$GOPATH/bin

# for gtags use, not only default langages.
export GTAGSCONF=/usr/local/share/gtags/gtags.conf
export GTAGSLABEL=pygments

#alias
alias emacs='emacsclient -nw -a ""'
alias ekill='emacsclient -e "(kill-emacs)"'
alias python="python2.7" #"python" has rich package but "python2.7" is version 2.7.10
alias active2="source /Users/daiki/pyENV2/bin/activate"
alias active3="source /Users/daiki/pyENV3/bin/activate"
#C++ test
alias cpptest="c++ -I $HOME/googletest/googletest/include $HOME/googletest/googletest/build/libgtest.a $HOME/googletest/googletest/build/libgtest_main.a"

bindkey '^]' peco-src
function peco-src() {
    local src=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$src" ]; then
	BUFFER="cd $src"
	zle accept-line
    fi
    zle -R -c
}
zle -N peco-src

case `uname` in
  Darwin)
      export DYLD_LIBRARY_PATH=$HOME/llvm/build/lib:$DYLD_LIBRARY_PATH
      alias clang-omp='/usr/local/opt/llvm/bin/clang -fopenmp -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib'
      alias clang-omp++='/usr/local/opt/llvm/bin/clang++ -fopenmp -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib'
      alias ls='ls -G'
      HOMEBREW_GITHUB_API_TOKEN=""
  ;;
  Linux)
  # commands for Linux
      alias ls='ls --color=auto'
  ;;
esac
