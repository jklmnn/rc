
all: vim zsh

vim: vim-default

vim-default: $(HOME)/.vimrc vundle

vim-extended: vim-default
	sed -i "/\"Plugin EXTEND/r vimrc-extended" $(HOME)/.vimrc

vundle: $(HOME)/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

$(HOME)/.vim/bundle/Vundle.vim:
	git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

$(HOME)/.vimrc: vimrc
	cp vimrc-default $(HOME)/.vimrc

zsh: zshrc
	cp zshrc $(HOME)/.zshrc
