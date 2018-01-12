while getopts cp: OPT
do
    case $OPT in
	"p" ) PROXY="TRUE" ; PROXY_VALUE="$OPTARG" ;;
    esac
done

if [ "$PROXY" = "TRUE" ]; then
    #this includes git install
    sudo python set_proxy.py PROXY_VALUE
fi

if [  "$(uname)" == 'Darwin' ]; then
    if type git > /dev/null 2>&1; then
	# is brew installed as default?
	sudo brew install git tig go
    fi
    OS='Mac'
elif [  "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    if   [  -e /etc/debian_version ] ||
         [  -e /etc/debian_release ] ||
	 [  -e /etc/SuSE-release   ]; then
        # Check Ubuntu, Debian or SuSE
	# for golang
	sudo apt-get update && sudo apt-get install -y apt-file && sudo apt-file update
	sudo apt-get install -y software-properties-common
	sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
	sudo apt-get update -y
	sudo apt-get install -y cmake zsh golang git tig automake libevent-dev \
	     exuberant-ctags python-pygments python3-pygments ncurses-dev \
	     llvm libclang-dev wget cgdb htop
	if [  -e /etc/SuSE-release ]; then
	    sudo apt-get install -y go
	else
	    sudo apt-get install -y golang
	fi
    elif [  -e /etc/redhat-release ]; then
	# rhel, centos
	sudo yum install -y centos-release-scl epel-release
	sudo yum-config-manager --enable rhel-server-rhscl-7-rpms -y # for rhel
	sudo yum update -y
	sudo yum install -y zsh cmake git tig ctags-etags libevent gcc gcc-c++ \
	     python-pygments ncurses-devel ncurses wget automake libevent-devel \
	     devtoolset-7 llvm llvm-devel clang clang-devel go
    fi
    OS='Linux'
elif [  "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
    OS='Cygwin'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

git config --global user.name ami-GS
git config --global user.email 1991.daiki@gmail.com

export GOPATH=$HOME/Go/
export PATH=$PATH:$GOPATH/bin
if [ ! -e $HOME/Go ]; then
    mkdir $HOME/Go/
    go get github.com/motemen/ghq
    git config --global ghq.root $HOME/Go/src
fi

if [ ! -e $GOPATH/src/github.com/Andersbakken/rtags ];then
    ghq get https://github.com/Andersbakken/rtags.git
    cd $HOME/Go/src/github.com/Andersbakken/rtags
    git submodule init
    git submodule update
    mkdir build && cd build
    cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && make -j4
    ./bin/rdm --daemon
    cd $HOME
fi

if [ ! -e $GOPATH/src/github.com/rizsotto/Bear ]; then
    ghq get https://github.com/rizsotto/Bear
    cd $HOME/Go/src/github.com/rizsotto/Bear
    mkdir build && cd build
    cmake .. && make -j 4 && sudo make install -j4
fi

go get https://github.com/rogpeppe/godef
go get -u https://github.com/nsf/gocode
go get https://github.com/golang/lint/golint
go get https://github.com/kisielk/errcheck
go get github.com/peco/peco/cmd/peco

# google test settings
if [ ! -e $HOME/googletest ]; then
   git clone https://github.com/google/googletest $HOME/googletest
   mkdir googletest/googletest/build
   cd googletest/googletest/build
   cmake .. && make ..
   cd $HOME/dotfiles
fi


if [ ! -e $GOPATH/src/github.com/tmux/tmux ];then
    ghq get https://github.com/tmux/tmux
    cd $GOPATH/src/github.com/tmux/tmux
    sh autogen.sh && ./configure && make
    cd $HOME/dotfiles
    sudo ln -s $GOPATH/src/github.com/tmux/tmux/tmux /usr/bin/tmux
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
