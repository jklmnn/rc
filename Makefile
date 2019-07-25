
all: vim zsh

vim: vim-default

vim-default: $(HOME)/.vimrc vundle

vim-extended: vim-default vimrc-extended
	sed -i "/\"Plugin EXTEND/r vimrc-extended" $(HOME)/.vimrc
	sed -i "s/\"Plugin EXTEND//g" $(HOME)/.vimrc
	vim +PluginInstall +qall

vundle: $(HOME)/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

$(HOME)/.vim/bundle/Vundle.vim:
	git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

$(HOME)/.vimrc: vimrc-default
	cp vimrc-default $(HOME)/.vimrc

$(HOME)/.zshrc.local: zshrc.local
	cp zshrc.local $(HOME)/.zshrc.local

$(HOME)/.zshrc.pre: zshrc.pre
	cp zshrc.pre $(HOME)/.zshrc.pre

$(HOME)/.zshrc:
	wget -O $(HOME)/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

zsh: $(HOME)/.zshrc $(HOME)/.zshrc.local $(HOME)/.zshrc.pre
