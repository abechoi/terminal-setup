#!/bin/bash
set -e

# =============================================================================
# Terminal Setup
# Installs: iTerm2, Starship, eza, zsh-autosuggestions, zsh-syntax-highlighting,
#           zoxide, bat, fzf, and 6 custom themes with a theme switcher
# =============================================================================

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║     Terminal Setup                       ║"
echo "  ║     iTerm2 + Starship + Modern Tools     ║"
echo "  ║     + 6 Gorgeous Themes                  ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✓ Homebrew found"
fi

# ---- Terminal Emulator ----
echo ""
echo "🖥  Installing iTerm2..."
brew install --cask iterm2 2>/dev/null || echo "  (iTerm2 already installed)"

# ---- Nerd Font (required for icons) ----
echo ""
echo "🔤 Installing Nerd Font (JetBrains Mono)..."
brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || echo "  (Font already installed)"

# ---- Shell Tools ----
echo ""
echo "⚡ Installing CLI tools..."
brew install starship       2>/dev/null || echo "  starship already installed"
brew install eza            2>/dev/null || echo "  eza already installed"
brew install bat            2>/dev/null || echo "  bat already installed"
brew install fzf            2>/dev/null || echo "  fzf already installed"
brew install zoxide         2>/dev/null || echo "  zoxide already installed"
brew install zsh-autosuggestions      2>/dev/null || echo "  zsh-autosuggestions already installed"
brew install zsh-syntax-highlighting  2>/dev/null || echo "  zsh-syntax-highlighting already installed"

# ---- Themes Directory ----
echo ""
echo "🎨 Installing themes..."
THEMES_DIR="$HOME/.config/terminal-themes"
mkdir -p "$THEMES_DIR"

# Copy all starship configs
cp "$SCRIPT_DIR/starship.toml"                    "$THEMES_DIR/starship-patriot.toml"
cp "$SCRIPT_DIR/themes/starship-pastel.toml"      "$THEMES_DIR/starship-pastel.toml"
cp "$SCRIPT_DIR/themes/starship-vaporwave.toml"   "$THEMES_DIR/starship-vaporwave.toml"
cp "$SCRIPT_DIR/themes/starship-cyberpunk.toml"   "$THEMES_DIR/starship-cyberpunk.toml"
cp "$SCRIPT_DIR/themes/starship-neon.toml"        "$THEMES_DIR/starship-neon.toml"
cp "$SCRIPT_DIR/themes/starship-deepspace.toml"   "$THEMES_DIR/starship-deepspace.toml"
echo "  → Installed 6 Starship prompt themes"

# Set Patriot as default starship config
mkdir -p ~/.config
cp "$THEMES_DIR/starship-patriot.toml" ~/.config/starship.toml
echo "patriot" > "$THEMES_DIR/.current"
echo "  → Set Patriot as default Starship theme"

# ---- Theme Switcher ----
echo ""
echo "🔀 Installing theme switcher..."
cp "$SCRIPT_DIR/themes/theme-switcher.sh" "$THEMES_DIR/theme-switcher.sh"
chmod +x "$THEMES_DIR/theme-switcher.sh"

# Create symlink in /usr/local/bin (or homebrew bin)
BREW_BIN="$(brew --prefix)/bin"
if [[ -d "$BREW_BIN" ]]; then
    ln -sf "$THEMES_DIR/theme-switcher.sh" "$BREW_BIN/theme" 2>/dev/null || {
        # Fallback: add to ~/bin
        mkdir -p "$HOME/bin"
        ln -sf "$THEMES_DIR/theme-switcher.sh" "$HOME/bin/theme"
        echo "  → Installed 'theme' command to ~/bin"
    }
    echo "  → Installed 'theme' command"
else
    mkdir -p "$HOME/bin"
    ln -sf "$THEMES_DIR/theme-switcher.sh" "$HOME/bin/theme"
    echo "  → Installed 'theme' command to ~/bin"
fi

# ---- Backup existing .zshrc ----
echo ""
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d%H%M%S)
    echo "  → Backed up existing .zshrc"
fi

# ---- Install .zshrc ----
cp "$SCRIPT_DIR/zshrc" ~/.zshrc
echo "  → Installed .zshrc"

# ---- iTerm2 Profiles (all themes) ----
echo ""
echo "🎨 Installing iTerm2 color profiles..."
ITERM_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$ITERM_PROFILES_DIR"

# Install the Patriot profile
cp "$SCRIPT_DIR/iterm-profile.json" "$ITERM_PROFILES_DIR/patriot-profile.json"
echo "  → Installed Patriot iTerm2 profile"

# Install all 5 new theme profiles
cp "$SCRIPT_DIR/themes/iterm-profiles.json" "$ITERM_PROFILES_DIR/terminal-themes.json"
echo "  → Installed 5 additional theme profiles"

# ---- fzf keybindings ----
echo ""
echo "🔍 Setting up fzf keybindings..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true

echo ""
echo "══════════════════════════════════════════════"
echo ""
echo "  ✅ Setup complete!"
echo ""
echo "  🎨 6 Themes installed:"
echo "     1) 🛡  Patriot  (default)"
echo "     2) 🎀  Pastel Dreams"
echo "     3) 🌴  Vaporwave"
echo "     4) ⚡  Cyberpunk 2077"
echo "     5) 💫  Neon Noir"
echo "     6) 🚀  Deep Space"
echo ""
echo "  Switch themes anytime by typing:"
echo "     theme              (interactive picker)"
echo "     theme cyberpunk    (switch directly)"
echo "     theme list         (see all themes)"
echo ""
echo "  Next steps:"
echo "  1. Open iTerm2 (it's in your Applications folder)"
echo "  2. Go to iTerm2 → Settings → Profiles"
echo "  3. Select '🛡 Patriot' profile and set as Default"
echo "  4. Ensure font is 'JetBrainsMono Nerd Font'"
echo "  5. Restart iTerm2 or run: source ~/.zshrc"
echo ""
echo "  Your old .zshrc was backed up with a timestamp."
echo ""
echo "══════════════════════════════════════════════"
