#if [ -z "$TMUX" ] # When zsh is started attach to current tmux session or create a new one
#then
#	tmux attach -t TMUX || tmux new -s TMUX
#fi

export EDITOR="nvim"
alias vim="nvim"
alias ssh="TERM=xterm ssh"

export ZSH="$HOME/.oh-my-zsh"

SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true # Show prefix before first line in prompt
ZSH_THEME="spaceship" # Set theme

plugins=(
  git # https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git
  history-substring-search # ZSH port of Fish history search. Begin typing command, use up arrow to select previous use
  zsh-autosuggestions # Suggests commands based on your history
  zsh-completions # More completions
  zsh-syntax-highlighting # Fish shell like syntax highlighting for Zsh
  colored-man-pages # Self-explanatory
  kubetail
  kubectl
  docker
docker-compose
  )
autoload -U compinit && compinit # reload completions for zsh-completions

source $ZSH/oh-my-zsh.sh # required
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh # required

# Colorize autosuggest
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

# Spaceship-prompt customization
SPACESHIP_PROMPT_ORDER=(
time            # Time stampts section
user            # Username section
dir             # Current directory section
host            # Hostname section
git             # Git section (git_branch + git_status)
# hg            # Mercurial section (hg_branch  + hg_status)
# package       # Package version
node          # Node.js section
ruby          # Ruby section
# elixir        # Elixir section
# xcode         # Xcode section
# swift         # Swift section
golang        # Go section
# php           # PHP section
rust          # Rust section
haskell       # Haskell Stack section
# julia         # Julia section
docker        # Docker section
aws           # Amazon Web Services section
# venv          # virtualenv section
# conda         # conda virtualenv section
# pyenv         # Pyenv section
dotnet        # .NET section
# ember         # Ember.js section
kubecontext   # Kubectl context section
exec_time       # Execution time
line_sep        # Line break
battery         # Battery level and status
vi_mode         # Vi-mode indicator
jobs            # Background jobs indicator
# exit_code     # Exit code section
char            # Prompt character
)

SPACESHIP_DIR_PREFIX="%{$fg[blue]%}┌─[%b "
SPACESHIP_DIR_SUFFIX="%{$fg[blue]%} ] "
SPACESHIP_CHAR_SYMBOL="%{$fg[blue]%}└─▪%b "

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

eval "$(rbenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U add-zsh-hook
load-nvmrc() {
	local node_version="$(nvm version)"
	local  nvmrc_path="$(nvm_find_nvmrc)"
	if [ -n "$nvmrc_path" ]; then
		local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
		
		if [ "$nvmrc_node_version" = "N/A" ]; then
			nvm install
		elif [ "$nvmrc_node_version" != "$node_version" ]; then
			nvm use
		fi
	elif [ "$node_version" != "$(nvm version default)" ]; then
		echo "Reverting to nvm default version"
		nvm use default
	fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

if [ $commands[kubectl] ]; then
	source <(kubectl completion zsh)
fi

alias be="bundle exec"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
EXPORT_FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


alias scrotclip='scrot -s ~/foo.png && xclip -selection clipboard -t image/png ~/foo.png && rm ~/foo.png'
alias ls='exa'

export MSBuildSDKsPath=/usr/share/dotnet/sdk/$(dotnet --version)/Sdks
