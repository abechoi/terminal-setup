# =============================================================================
# ZSH Configuration
# =============================================================================

# ---- Homebrew (Apple Silicon) ----
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null

# ---- History ----
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS    # Don't store duplicate commands
setopt HIST_FIND_NO_DUPS       # Don't show dupes when searching
setopt HIST_REDUCE_BLANKS      # Remove extra blanks
setopt SHARE_HISTORY           # Share history between sessions
setopt APPEND_HISTORY          # Append, don't overwrite
setopt INC_APPEND_HISTORY      # Write immediately, not on exit

# ---- Navigation ----
setopt AUTO_CD                 # Type directory name to cd into it
setopt AUTO_PUSHD              # Push dirs onto the stack automatically
setopt PUSHD_IGNORE_DUPS       # No duplicates in dir stack
setopt PUSHD_SILENT            # Don't print dir stack after pushd/popd

# ---- Completion ----
autoload -Uz compinit
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # Case-insensitive
zstyle ':completion:*' menu select                            # Arrow key selection
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"       # Colored completions
zstyle ':completion:*' group-name ''                          # Group by type
zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

# ---- Key Bindings ----
bindkey -e                     # Emacs mode (for ctrl shortcuts)
bindkey '^[[A' history-search-backward    # Up arrow searches history
bindkey '^[[B' history-search-forward     # Down arrow searches history
bindkey '^[[1;5C' forward-word            # Ctrl+Right moves word forward
bindkey '^[[1;5D' backward-word           # Ctrl+Left moves word backward
bindkey '^[[H' beginning-of-line          # Home key
bindkey '^[[F' end-of-line                # End key
bindkey '^[[3~' delete-char               # Delete key

# ---- Plugins ----
# Autosuggestions (ghost text from history)
if [ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6B7280'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi

# Syntax highlighting (valid commands = green, invalid = red)
if [ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# fzf keybindings (Ctrl+R for fuzzy history, Ctrl+T for file search)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="
  --color=bg+:#1B4D89,bg:#0B2545,spinner:#D69E2E,hl:#B31942
  --color=fg:#E2E8F0,header:#B31942,info:#3182CE,pointer:#D69E2E
  --color=marker:#D69E2E,fg+:#FFFFFF,prompt:#3182CE,hl+:#B31942
  --height=40% --layout=reverse --border=rounded
"

# Zoxide (smart cd replacement)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# ---- eza (modern ls) ----
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza --icons --group-directories-first -la --git --header'
    alias lt='eza --icons --group-directories-first --tree --level=3'
    alias la='eza --icons --group-directories-first -a'
    alias l='eza --icons --group-directories-first -l --git'
else
    alias ls='ls --color=auto'
    alias ll='ls -la'
    alias la='ls -a'
fi

# ---- bat (better cat) ----
if command -v bat &> /dev/null; then
    alias cat='bat --style=auto'
    export BAT_THEME="TwoDark"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# ---- Aliases ----
# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gpl='git pull'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Safety
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Quick access
alias dev='cd ~/Desktop'
alias wb='cd ~/Desktop/gov-contracting-dashboard'
alias ports='lsof -i -P -n | grep LISTEN'
alias ip='curl -s ifconfig.me'
alias weather='curl -s "wttr.in/?format=3"'
alias psg='ps aux | grep -v grep | grep'

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv venv && source venv/bin/activate'
alias activate='source venv/bin/activate'

# Docker
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'

# Project shortcuts
alias wb-back='cd ~/Desktop/gov-contracting-dashboard/backend && source venv/bin/activate && python -m uvicorn app.main:app --reload --port 8000'
alias wb-front='cd ~/Desktop/gov-contracting-dashboard/frontend && npm start'
alias wb-docker='cd ~/Desktop/gov-contracting-dashboard && docker-compose up -d --build'

# ---- Functions ----
# Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Quick find file by name
ff() { find . -type f -name "*$1*" 2>/dev/null; }

# Quick find in files (grep)
fif() { grep -rn --color=auto "$1" "${2:-.}"; }

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick HTTP server
serve() { python3 -m http.server "${1:-8080}"; }

# ---- Starship Prompt (load last) ----
eval "$(starship init zsh)"
