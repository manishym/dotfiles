# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  gitignore
  zsh-autosuggestions
  zsh-syntax-highlighting
  autojump
  gitfast
  zsh-defer
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# zsh-defer setup
source $ZSH_CUSTOM/plugins/zsh-defer/zsh-defer.plugin.zsh

# Deferred plugin loading
zsh-defer source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zsh-defer source $HOME/.zsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
zsh-defer source $HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
zsh-defer source $HOME/.zsh/plugins/zsh-git-prompt/zshrc.sh

# PATH exports
export GOPATH=$HOME/go
export PATH="$HOME/.pub-cache/bin:$HOME/bin:$GOPATH/bin:/usr/local/go/bin:/opt/homebrew/bin:$PATH"

# Aliases
alias vim=nvim
alias vimdiff='nvim -d'
alias nvimdiff='nvim -d'
alias gitnopush="git remote set-url --push origin no_push"
alias grem="~/bin/add_remote"
alias ocd='oc delete --all cm,job,pvc -n storage-perf'
alias cct="codecrafters test"
alias ccs="codecrafters submit"
alias ex="exercism"

# Autojump init (if available)
[[ -f /opt/homebrew/etc/profile.d/autojump.sh ]] && . /opt/homebrew/etc/profile.d/autojump.sh

# Dart CLI completion
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && . "$HOME/.dart-cli-completion/zsh-config.zsh"

# GVM
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# History timestamp format
HIST_STAMPS="yyyy-mm-dd"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
