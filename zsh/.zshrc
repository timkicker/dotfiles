###############################################################################
# ~/.zshrc (public-friendly version)
#
# Focus: structure, readable English comments, aligned configuration. No logic
# changes; only duplicate exports removed (they were exact repeats). If you
# reintroduce generated sections, keep them within clearly marked blocks.
###############################################################################

### Prompt & theme (keep at top) ################################################
# Powerlevel10k should load early. Anything requiring interactive input must
# appear above this block. Instant prompt speeds up shell startup.
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### History ####################################################################
# Large shared history with duplicate suppression.
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

### Plugins ####################################################################
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-z/zsh-z.plugin.zsh

### Key bindings ################################################################
bindkey '^[[A' history-search-backward   # Up arrow: search backward with prefix
bindkey '^[[B' history-search-forward    # Down arrow: search forward with prefix

### PATH / environment ##########################################################
export PATH="$HOME/.local/bin:$PATH"

### Helper functions ############################################################
# Jump to a directory selected inside ranger. After closing, change to the
# chosen directory (if any). Temporary file cleans up automatically.
r() {
  local tmp="$(mktemp -t ranger-cwd.XXXXXX)"
  ranger --choosedir="$tmp" "$@"
  local dir="$(cat "$tmp")"
  [ -d "$dir" ] && cd "$dir"
  rm -f -- "$tmp"
}

### Julia (managed by juliaup) ##################################################
# >>> juliaup initialize >>>
# !! Contents within this block are managed by juliaup !!
path=("$HOME/.juliaup/bin" $path)
export PATH
# <<< juliaup initialize <<<

### Aliases #####################################################################
alias neofetch=fastfetch
alias vim=nvim
alias vi=nvim
alias icat="kitten icat"

### Completion ##################################################################
autoload -U compinit; compinit
zstyle ':completion:*' menu select

### Editor defaults #############################################################
export EDITOR=nvim
export VISUAL=nvim

### Custom tooling paths / commands #############################################
export CHEATDIR="$HOME/Documents/Cheatsheets"
export EDITOR_CMD="nvim"
export TERMINAL_CMD="kitty"

###############################################################################
# End of file
###############################################################################
export DEVKITPRO=/opt/devkitpro
export DEVKITPPC=$DEVKITPRO/devkitPPC
export PATH=$DEVKITPRO/tools/bin:$DEVKITPPC/bin:$PATH
