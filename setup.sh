#!/bin/bash

# ------------------
# Go to home
# ------------------
cd ~

# ------------------
# APPS
# ------------------
sudo apt update
sudo apt upgrade -y
sudo apt install build-essential -y
sudo apt autoremove -y
sudo apt install git -y
sudo apt install curl -y
sudo apt install xclip -y
sudo apt install flameshot
sudo snap install code --classic
sudo snap install discord
sudo snap install postman
sudo snap install dbeaver-ce
sudo snap install spotify

# ------------------
# FortiCliente (for vpns)
# ------------------
if ! [ -x "$(command -v openfortigui)" ]; then
  wget https://apt.iteas.at/iteas/pool/main/o/openfortigui/openfortigui_0.9.0-3_amd64_focal.deb
  sudo dpkg -i openfortigui_0.9.0-3_amd64_focal.deb
  sudo apt-get -f install -y
  rm openfortigui_0.9.0-3_amd64_focal.deb*
fi

# ------------------
# Chrome
# ------------------
if ! [ -x "$(command -v google-chrome)" ]; then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb*
fi

# ------------------
# docker
# ------------------
if ! [ -x "$(command -v docker)" ]; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  sudo usermod -aG docker $USER
  exec su -l $USER
fi

# ------------------
# docker-compose
# ------------------
if ! [ -x "$(command -v docker-compose)" ]; then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.27.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# ------------------
# Postgres (from docker)
# ------------------
if ! docker ps -a | grep 'database'; then
  docker run --name database -e POSTGRES_PASSWORD=root -p 5432:5432 -d postgres
fi

# ------------------
# SSH
# ------------------
ssh-keygen -q -t rsa -N '' <<< ""$'\n'"n" 2>&1 >/dev/null
xclip -sel clip < ~/.ssh/id_rsa.pub

# ------------------
# NVM (Node Version Manager)
# ------------------
if ! [ -x "$(command -v node)" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
  . $NVM_DIR/nvm.sh
  nvm install --lts
  nvm alias default node
  source ~/.bashrc
fi

# ------------------
# Yarn
# ------------------
if ! [ -x "$(command -v yarn)" ]; then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update
  sudo apt install --no-install-recommends yarn
fi

# ------------------
# Peek (GIF Creator)
# ------------------
if ! [ -x "$(command -v peek)" ]; then
  sudo add-apt-repository ppa:peek-developers/stable -y
  sudo apt update
  sudo apt install peek -y
fi

# ------------------
# Terminal ZSH
# ------------------
if ! [ -x "$(command -v zsh)" ]; then
  sudo apt-get install zsh -y
  yes Y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt --depth=1
ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme

# Change default terminal emulator to ZSH
sudo chsh -s /bin/zsh

echo "
# Defaults
export PATH=\$HOME/bin:/usr/local/bin:$(yarn global bin):\$PATH
export ZSH=/home/$(whoami)/.oh-my-zsh
export DEFAULT_USER=\"$(whoami)\"
export EDITOR=\"code --reuse-window\"
export TERM=\"xterm-256color\"
export NVM_DIR=\"\$HOME/.nvm\"
[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This loads nvm
[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion

# Fast edit config files aliases
alias ez=\"\$EDITOR ~/.zshrc\"
alias eb=\"\$EDITOR ~/.bashrc\"
alias eg=\"\$EDITOR ~/.gitconfig\"

# Spaceship
SPACESHIP_PROMPT_ADD_NEWLINE=\"false\"

# ZSH theme & plugins
ZSH_THEME=\"spaceship\"

plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)
source \$ZSH/oh-my-zsh.sh
" > $HOME/.zshrc

echo ""
echo "
@@@@@@@@@@@@(////////////////////////////////////@@@@@@@@@@@
@@@@@@(((((((((((((////////////////////////////////////@@@@@
@@@((((((((((((((((((////////////////////////////////////#@@
@@(((((((((((((((((((,   ///////////   ////////////////////@
@(((((((((((((((((((   /((///////////.   ///////////////////
((((((((((((((((((/   (((((////%%%/////   //////////////////
(((((((((((((((((   ,(((((((((@@@@//////   .////////////////
((((((((((((((((   (((((((((((@@@(////////   ///////////////
((((((((((((((.   (((((((((((@@@#((((//////   */////////////
((((((((((((((   /((((((((((#@@@(((((((////*   /////////////
(((((((((((((((    (((((((((@@@((((((((((/   ///////////////
(((((((((((((((((   (((((((@@@@(((((((((/   ////////////////
((((((((((((((((((   ,(((((@@@(((((((((   .((((/////////////
(((((((((((((((((((/   (((((((((((((((   (((((((((//////////
(((((((((((((((((((((   /(((((((((((.   ((((((((((((////////
((((((((((((((((((((((((((((((((((((((((((((((((((((((//////
(((((((((((((((((((((((@@@@@@@@@@@@@@@((((((((((((((/(((/(//
(((((((((((((((((((((((@@@@@@@@@@@@@@@((((((((((((((((((((//
(((((((((((((((((((((((@@@@@@@@@@@@@@@((((((((((((((((((((((
(((((((((((((((((((((((@@@@@@@@@@@@@@@((((((((((((((((((((((
@(((((((((((((((((((((((((%@@@@@@@((((((((((((((((((((((((((
@@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((@
@@@#(((((((((((((((((((((((((((((((((((((((((((((((((((((@@@
@@@@@@(((((((((((((((((((((((((((((((((((((((((((((((((@@@@@
"

echo "Your ssh key has been copied to clipboard!"
echo "Paste it into your git accounts:"
echo "Github: https://github.com/settings/ssh/new"
echo "Gitlab: https://gitlab.com/profile/keys"
echo "Bitbucket: https://bitbucket.org/account/settings/ssh-keys/"
echo ""
echo "Enter your local machine user password to finish this setup correctly"

exec su -l $USER
