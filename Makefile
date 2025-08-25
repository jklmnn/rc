
all: neovim zsh tmux

NVIM := $(shell which nvim || echo $(HOME)/.local/bin/nvim)

$(NVIM):
	curl -fLo $@ --create-dirs \
		https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x $@

neovim-bin: $(NVIM)

$(HOME)/.local/share/nvim/site/pack/paqs/start:
	mkdir -p $@

$(HOME)/.local/share/nvim/site/pack/paqs/start/paq-nvim/README.md:
	git clone --depth=1 https://github.com/savq/paq-nvim.git $(HOME)/.local/share/nvim/site/pack/paqs/start/paq-nvim

nvim: $(HOME)/.local/share/nvim/site/pack/paqs/start/paq-nvim/README.md neovim-bin
	mkdir -p $(HOME)/.config/nvim
	cp init.lua $(HOME)/.config/nvim/init.lua

neovim: nvim
	nvim --headless --cmd "let g:install_mode=1" +PaqSync +qall

$(HOME)/%/plug.vim:
	curl -fLo $@ --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$(HOME)/.zshrc.local: zshrc.local
	cp zshrc.local $(HOME)/.zshrc.local

$(HOME)/.zshrc:
	wget -O $(HOME)/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

$(HOME)/.zsh:
	mkdir -p $@

$(HOME)/.zsh/zsh-autosuggestions/README.md: $(HOME)/.zsh
	rm -rf ~/.zsh/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

$(HOME)/.zsh/zsh-syntax-highlighting/README.md: $(HOME)/.zsh
	rm -rf ~/.zsh/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

$(HOME)/.zsh/zlong_alert/README.md: $(HOME)/.zsh
	rm -rf ~/.zsh/zlong_alert
	git clone https://github.com/kevinywlui/zlong_alert.zsh ~/.zsh/zlong_alert

zsh-autosuggestions: $(HOME)/.zsh/zsh-autosuggestions/README.md

zsh-syntax-highlighting: $(HOME)/.zsh/zsh-syntax-highlighting/README.md

zlong_alert: $(HOME)/.zsh/zlong_alert/README.md

zsh: $(HOME)/.zshrc $(HOME)/.zshrc.local

zsh-all: zsh zsh-autosuggestions zsh-syntax-highlighting zlong_alert

$(HOME)/.tmux.conf: tmux.conf
	cp tmux.conf $(HOME)/.tmux.conf

$(HOME)/.tmuxconkyrc: tmuxconkyrc
	cp tmuxconkyrc $(HOME)/.tmuxconkyrc

tmux: $(HOME)/.tmux.conf $(HOME)/.tmuxconkyrc

nix: $(HOME)/.nix-profile/etc/profile.d/nix.sh
	curl https://nixos.org/nix/install | sh

ALR := $(or $(shell which alr),$(HOME)/.local/bin/alr)

ALS := $(shell which ada_language_server || echo $(HOME)/.local/bin/ada_language_server)

$(ALR):
	curl -fLo $@ --create-dirs \
	    https://github.com/alire-project/alire/releases/download/v1.2.2/alr-1.2.2-x86_64.AppImage
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

.PHONY: all neovim zsh zsh-all zsh-autosuggestions zsh-syntax-highlighting zlong_alert tmux nix alire-bin ada_language_server-bin alire-update gdb
