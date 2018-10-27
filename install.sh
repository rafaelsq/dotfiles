echo "yarn https://yarnpkg.com/pt-BR/docs/install"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

echo "deps"
sudo apt update && sudo apt install git bison gcc make zsh silversearcher-ag autojump yarn

echo "oh-my-zsh, https://github.com/robbyrussell/oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "plug - https://github.com/junegunn/vim-plug"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "parcel"
yarn global add parcel
