#!/bin/bash

sudo apt install -y imagemagick tree curl wget git unzip apt-file mc \
  exuberant-ctags ack-grep silversearcher-ag golang
sudo apt install -y zsh zsh-syntax-highlighting ttf-ancient-fonts \
  fonts-powerline fonts-font-awesome
sudo apt install -y vim
sudo apt install -y python3-pip exuberant-ctags ack-grep silversearcher-ag
sudo pip3 install pynvim flake8 pylint isort yamllint ansible-lint jedi \
  autopep8 yapf docformatter proselint saws autorandr

cd /home/vagrant

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# oh-my-zsh bullet-train theme
cd ~/.oh-my-zsh/themes/
curl -O https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
cd

# oh-my-zsh powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# change chsh so it won't asks for password
sudo sed -i 's/auth       required   pam_shells.so/auth       sufficient   pam_shells.so/g' /etc/pam.d/chsh
chsh -s $(which zsh)

# clone repo
cd /home/vagrant
echo ".dotfiles" >> $HOME/.gitignore
mkdir -p ~/.config-backup
git clone --bare https://github.com/bcochofel/dotfiles.git $HOME/.dotfiles
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.config-backup/{}
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME status

# update ttf fonts cache
fc-cache -f -v

exit 0
