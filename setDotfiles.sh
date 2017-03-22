if [  "$(uname)" == 'Darwin' ]; then
    if type git > /dev/null 2>&1; then
	# is brew installed as default?
	sudo brew install git tig
    fi
    OS='Mac'
elif [  "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    if   [  -e /etc/debian_version ] ||
         [  -e /etc/debian_release ] ||
	 [  -e /etc/SuSE-release   ]; then
        # Check Ubuntu, Debian or SuSE
	# for golang
	sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get install -y cmake zsh golang git tig automake \
	     exuberant-ctags python-pygments python3-pygments ncurses-dev
	if [  -e /etc/SuSE-release ]; then
	    sudo apt-get install -y go
	else
	    sudo apt-get install -y golang
	fi
    elif [  -e /etc/redhat-release ]; then
	# rhel, centos
	sudo yum install epel-release -y
	sudo yum update -y
	sudo yum upgrade -y
	sudo yum install -y zsh cmake git tig ctags-etags libevent gcc gcc-c++ \
	     python-pygments ncurses-devel ncurses wget automake libevent-devel
    fi
    OS='Linux'
elif [  "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
    OS='Cygwin'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

# google test settings
if [ ! -e $HOME/googletest ]; then
   git clone https://github.com/google/googletest $HOME/googletest
   mkdir googletest/googletest/build
   cd googletest/googletest/build
   cmake .. && make ..
   cd $HOME/dotfiles
fi


if [ ! -e tmux ];then
    git clone https://github.com/tmux/tmux
    cd tmux
    sh autogen.sh && ./configure && make
    cd $HOME/dotfiles
    sudo ln -s $HOME/dotfiles/tmux/tmux /usr/bin/tmux
    cp .tmux.conf $HOME/
fi

if [ ! -e global* ]; then
   wget http://tamacom.com/global/global-6.5.6.tar.gz #need to be latest
   tar -zxvf global-6.5.6.tar.gz
   cd global-6.5.6
   sudo ./configure && sudo make && sudo make install
   cd $HOME/dotfiles
fi

cp .emacs $HOME/
cp -r .emacs.d $HOME/
if [ ! -e git-prompt.sh ]; then
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
fi
sudo chsh -s /bin/zsh $USER
cp .zshrc $HOME/


if [ "$*" == "--xwindow" ]; then
    OUT=$(grep X11Forwarding /etc/ssh/sshd_config | grep -o yes)
    if [ "$OUT" != "yes" ]; then
	sudo sed -i -e 's/X11Forwarding no/X11Forwarding yes/g' /etc/ssh/sshd_config
    fi
fi
