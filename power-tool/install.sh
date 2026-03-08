#!/bin/bash
# Install the power command on a fresh Mac
set -e

G='\033[0;32m' Y='\033[1;33m' B='\033[1m' X='\033[0m'
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo -e "${B}Installing power command...${X}"
echo ""

# Create ~/bin if needed
mkdir -p "$HOME/bin"

# Copy power script
cp "$SCRIPT_DIR/power" "$HOME/bin/power"
chmod +x "$HOME/bin/power"
echo -e "  ${G}✓${X} Copied power to ~/bin/power"

# Add ~/bin to PATH if not already there
if ! echo "$PATH" | grep -q "$HOME/bin"; then
    SHELL_RC="$HOME/.zshrc"
    [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.bashrc"

    if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$SHELL_RC"
        echo -e "  ${G}✓${X} Added ~/bin to PATH in $(basename $SHELL_RC)"
    else
        echo -e "  ${G}✓${X} ~/bin already in $(basename $SHELL_RC)"
    fi
    export PATH="$HOME/bin:$PATH"
else
    echo -e "  ${G}✓${X} ~/bin already on PATH"
fi

echo ""
echo -e "  ${G}Done.${X} Run ${B}power help${X} to get started."
echo ""
