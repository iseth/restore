#!/bin/sh
set -e

# need to install scripts
sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

warn () {
    echo "WARNING: $1" >&2
}


die () {
    echo "FATAL: $1" >&2
    exit 2
}


fail_if_empty () {
    empty=1
    while read line; do
        echo "$line"
        empty=0
    done
    test $empty -eq 0
}


_check_brew_package_installed () {
    brew list --versions $(basename "$1") | fail_if_empty > /dev/null
}


_update_brew() {
    if [ -f ".brew_updated" ]; then
        return  # bail out -- already done
    fi

    trap "{ rm -f .brew_updated; exit 255; }" EXIT
    touch .brew_updated

    echo "Updating brew to have the latest packages... hang in there..."
    brew update && \
        echo "homebrew packages updated" || \
        die "could not update brew"
}

git_me_some () {
    pkg="$1"
#@TODO
}

brew_me_some () {
    pkg="$1"
    _check_brew_package_installed "$pkg" || \
        (_update_brew && brew install "$pkg") || \
        die "$pkg could not be installed"

    echo "$pkg installed"
}


cask_me_some () {
    pkg="$1"
    brew cask list | grep -qxF "$pkg" || \
        brew cask install "$@" || \
        die "cask $pkg could not be installed"
    echo "$@ is already installed."
}

check_git_is_installed () {
    if ! which -s git; then
        echo "Install git with X-code"
    fi
}

check_brew_is_installed () {
    if ! which -s brew; then
        echo "We rely on the Brew installer for the Mac OS X platform."
        echo "Please install Brew by following instructions here:"
        echo "    http://brew.sh/#install"
        echo ""
        exit 2
    fi
}

install_brew_tools () {
    check_git_is_installed
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
}
install_brew_tools () {
    check_brew_is_installed

    # Used by brew
    brew_me_some ruby
    brew_me_some git

    # Tap some kegs
    echo ""
    echo "#######################################################"
    echo "# KEGS"
    echo "#######################################################"
    brew tap homebrew/versions
    brew tap homebrew/science
    brew tap caskroom/versions

    echo ""
    echo "#######################################################"
    echo "# INSTALLING BREW PACKAGES"
    echo "#######################################################"
    brew_me_some htop
    brew_me_some vim
    brew_me_some fish
    brew_me_some asciinema
    brew_me_some asdf
    brew_me_some bup
    brew_me_some cjdns
    brew_me_some colordiff
    brew_me_some cowsay
    brew_me_some cmus
    brew_me_some ctags
    brew_me_some direnv
    # brew_me_some fdupes
    brew_me_some ffind
    brew_me_some fish
    brew_me_some gcc
    # brew_me_some homebrew/versions/gcc46
    # brew_me_some gist
    brew_me_some gnupg
    brew_me_some gource
    brew_me_some graphviz
    brew_me_some httpie
    brew_me_some hub
    brew_me_some imagemagick
    brew_me_some jq
    # brew_me_some leiningen
    brew_me_some libevent
    brew_me_some lolcat
    # brew_me_some homebrew/versions/mongodb24
    brew_me_some monero
    brew_me_some moreutils
    # brew_me_some mysql
    # brew_me_some nginx
    brew_me_some node
    brew_me_some optipng
    # brew_me_some par2
    brew_me_some pdfgrep
    brew_me_some pngquant
    brew_me_some pv
    brew_me_some pyqt5
    # brew_me_some rabbitmq
    brew_me_some rbenv
    brew_me_some reattach-to-user-namespace
    brew_me_some redis
    brew_me_some restic
    brew_me_some selecta
    brew_me_some ssh-copy-id
    brew_me_some the_silver_searcher
    brew_me_some tig
    brew_me_some tmux
    brew_me_some tree
    brew_me_some unrar
    brew_me_some watch
    brew_me_some wget
    brew_me_some wireguard-tools
    brew_me_some zeromq

    brew_me_some macvim  # NOTE: requires a full Xcode
    # brew_me_some elasticsearch  # TODO: requires Java
}


install_casks () {
    echo ""
    echo "#######################################################"
    echo "# CASKS"
    echo "#######################################################"
    brew_me_some caskroom/cask/brew-cask
    
    cask_me_some atom

    # cask_me_some 1password  # NOTE: purchased via App Store
    cask_me_some adobe-photoshop-lightroom
    cask_me_some alfred
    cask_me_some appzapper
    cask_me_some arq
    cask_me_some calibre
    cask_me_some daisydisk
    # cask_me_some dash  # NOTE: purchased via App Store
    cask_me_some divvy
    cask_me_some dropbox
    cask_me_some firefox
    cask_me_some fluid
    cask_me_some flux
    # cask_me_some google-chrome  # NOTE: installed into /Applications manually, to overcome 1Password's sandboxed nature
    cask_me_some gitx
    cask_me_some google-chrome-canary
    cask_me_some heroku-toolbelt
    cask_me_some iterm2
    cask_me_some karabiner-elements
    cask_me_some licecap
    cask_me_some mailbox
    cask_me_some mailplane
    cask_me_some marked
    cask_me_some monero-wallet
    cask_me_some mongohub
    cask_me_some nvalt
    cask_me_some phantomjs
    cask_me_some postgres
    cask_me_some postico
    cask_me_some rescuetime
    cask_me_some robomongo
    cask_me_some setapp
    cask_me_some screenflow
    cask_me_some screenhero
    # cask_me_some sketch   # NOTE: purchased via App Store
    cask_me_some skype
    cask_me_some slack
    cask_me_some spotify
    cask_me_some superduper
    cask_me_some textexpander
    cask_me_some transmission
    cask_me_some vlc

    # cask_me_some wireshark
    # cask_me_some zooom  # zooom seems broken
}


install_fonts () {
    echo ""
    echo "#######################################################"
    echo "# FONTS"
    echo "#######################################################"

    brew tap caskroom/fonts

    # The fonts
    cask_me_some font-anonymous-pro
    cask_me_some font-hack
    cask_me_some font-inconsolata
    cask_me_some font-pt-mono
    cask_me_some font-roboto
    cask_me_some font-source-code-pro-for-powerline
    cask_me_some font-ubuntu-mono-powerline
}

install_repos () {
    git_me_some sherlock-project/sherlock
    andresriancho/w3af
    trustedsec/tap
}

npm install -g sqlectron-term

main () {
    install_git_tools
    install_brew_tools
    install_casks
    install_fonts
}

main
