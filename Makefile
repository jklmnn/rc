
all: neovim zsh tmux modules

vimrc: $(HOME)/.vim/autoload/plug.vim
	cp init.vim $(HOME)/.vimrc

vim: vimrc
	vim +PlugUpdate +qall

vim-extended: vim
	sed -i "/\"Plug extend/r init.extend" $(HOME)/.vimrc
	sed -i "s/\"Plug extend//g" $(HOME)/.vimrc
	vim +PlugUpdate +UpdateRemotePlugins +qall

NVIM := $(shell which nvim || echo $(HOME)/.local/bin/nvim)

$(NVIM):
	curl -fLo $@ --create-dirs \
		https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x $@

neovim-bin: $(NVIM)

nvim: $(HOME)/.local/share/nvim/site/autoload/plug.vim neovim-bin
	mkdir -p $(HOME)/.config/nvim
	cp init.vim $(HOME)/.config/nvim/init.vim

neovim: nvim
	nvim +PlugUpdate +qall

neovim-extended: neovim
	sed -i "/\"Plug extend/r init.extend" $(HOME)/.config/nvim/init.vim
	sed -i "s/\"Plug extend//g" $(HOME)/.config/nvim/init.vim
	nvim +PlugUpdate +UpdateRemotePlugins +qall

$(HOME)/%/plug.vim:
	curl -fLo $@ --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$(HOME)/.zshrc.local: zshrc.local
	cp zshrc.local $(HOME)/.zshrc.local

$(HOME)/.zshrc:
	wget -O $(HOME)/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

$(HOME)/.zsh:
	mkdir -p $@

$(HOME)/.zsh/zsh-autosuggestions: $(HOME)/.zsh
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

$(HOME)/.zsh/zsh-syntax-highlighting: $(HOME)/.zsh
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

$(HOME)/.zsh/zlong_alert: $(HOME)/.zsh
	git clone https://github.com/kevinywlui/zlong_alert.zsh ~/.zsh/zlong_alert

zsh-autosuggestions: $(HOME)/.zsh/zsh-autosuggestions

zsh-syntax-highlighting: $(HOME)/.zsh/zsh-syntax-highlighting

zlong_alert: $(HOME)/.zsh/zlong_alert

zsh: $(HOME)/.zshrc $(HOME)/.zshrc.local

zsh-all: zsh zsh-autosuggestions zsh-syntax-highlighting zlong_alert

$(HOME)/.tmux.conf: tmux.conf
	cp tmux.conf $(HOME)/.tmux.conf

$(HOME)/.tmuxconkyrc: tmuxconkyrc
	cp tmuxconkyrc $(HOME)/.tmuxconkyrc

tmux: $(HOME)/.tmux.conf $(HOME)/.tmuxconkyrc

nix: $(HOME)/.nix-profile/etc/profile.d/nix.sh
	curl https://nixos.org/nix/install | sh

modules:
	rsync -rupE modules/* $(HOME)/.modules

ALR := $(or $(shell which alr),$(HOME)/.local/bin/alr)

ALS := $(shell which ada_language_server || echo $(HOME)/.local/bin/ada_language_server)

$(ALR):
	curl -fLo $@ --create-dirs \
	    https://github.com/alire-project/alire/releases/download/v1.2.0/alr-1.2.0-x86_64.AppImage
	chmod u+x $@

$(HOME)/.config/alire-indexes/als/index/index.toml:
	mkdir -p $(HOME)/.config/alire/indexes/als
	git clone  https://github.com/reznikmm/als-alire-index.git $(HOME)/.config/alire-indexes/als

$(HOME)/.config/alire/indexes/als/index.toml: $(HOME)/.config/alire-indexes/als/index/index.toml
	alr index --add file://$(HOME)/.config/alire-indexes/als --name als

BUILD_DIR := $(shell mktemp -d)
$(ALS): $(HOME)/.config/alire-indexes/als/index/index.toml alire-update
	cd $(BUILD_DIR) && \
	    alr get ada_language_server -b && \
	    cp -v ada_language_server*/.obj/server/ada_language_server $@
	chmod u+x $@

alire-bin: $(ALR)

alire-update: alire-bin
	alr index --update-all

ada_language_server-bin: $(ALS)

$(HOME)/.gdbinit: gdbinit
	cp $< $@

gdb: $(HOME)/.gdbinit

.PHONY: all vim vim-extended neovim neovim-extended zsh zsh-all zsh-autosuggestions zsh-syntax-highlighting zlong_alert tmux nix modules alire-bin ada_language_server-bin alire-update gdb
