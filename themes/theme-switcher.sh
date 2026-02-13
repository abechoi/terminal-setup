#!/bin/bash
# ═══════════════════════════════════════════════════
#   🎨  T H E M E   S W I T C H E R
#   Switch terminal themes with style
# ═══════════════════════════════════════════════════

THEMES_DIR="${HOME}/.config/terminal-themes"
STARSHIP_CONFIG="${HOME}/.config/starship.toml"
CURRENT_THEME_FILE="${THEMES_DIR}/.current"

# ── Theme definitions ──
declare -A THEME_NAMES
THEME_NAMES[patriot]="🛡  Patriot"
THEME_NAMES[pastel]="🎀  Pastel Dreams"
THEME_NAMES[vaporwave]="🌴  Vaporwave"
THEME_NAMES[cyberpunk]="⚡  Cyberpunk 2077"
THEME_NAMES[neon]="💫  Neon Noir"
THEME_NAMES[deepspace]="🚀  Deep Space"

declare -A THEME_STARSHIP
THEME_STARSHIP[patriot]="starship-patriot.toml"
THEME_STARSHIP[pastel]="starship-pastel.toml"
THEME_STARSHIP[vaporwave]="starship-vaporwave.toml"
THEME_STARSHIP[cyberpunk]="starship-cyberpunk.toml"
THEME_STARSHIP[neon]="starship-neon.toml"
THEME_STARSHIP[deepspace]="starship-deepspace.toml"

declare -A THEME_ITERM_PROFILE
THEME_ITERM_PROFILE[patriot]="🛡 Patriot"
THEME_ITERM_PROFILE[pastel]="🎀 Pastel Dreams"
THEME_ITERM_PROFILE[vaporwave]="🌴 Vaporwave"
THEME_ITERM_PROFILE[cyberpunk]="⚡ Cyberpunk"
THEME_ITERM_PROFILE[neon]="💫 Neon Noir"
THEME_ITERM_PROFILE[deepspace]="🚀 Deep Space"

# ── Color helpers ──
c_reset="\033[0m"
c_bold="\033[1m"
c_dim="\033[2m"
c_pink="\033[38;5;211m"
c_cyan="\033[38;5;87m"
c_gold="\033[38;5;220m"
c_green="\033[38;5;84m"
c_purple="\033[38;5;141m"
c_red="\033[38;5;203m"
c_blue="\033[38;5;75m"
c_white="\033[38;5;255m"

# ── Fancy banner ──
show_banner() {
    echo ""
    echo -e "${c_purple}${c_bold}  ┌─────────────────────────────────────┐${c_reset}"
    echo -e "${c_purple}${c_bold}  │${c_gold}        🎨 THEME SWITCHER             ${c_purple}│${c_reset}"
    echo -e "${c_purple}${c_bold}  └─────────────────────────────────────┘${c_reset}"
    echo ""
}

# ── Get current theme ──
get_current() {
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        cat "$CURRENT_THEME_FILE"
    else
        echo "patriot"
    fi
}

# ── Switch iTerm2 profile via AppleScript ──
switch_iterm_profile() {
    local profile_name="$1"
    osascript -e "
        tell application \"iTerm2\"
            tell current session of current window
                set profile name to \"$profile_name\"
            end tell
        end tell
    " 2>/dev/null
}

# ── Apply theme ──
apply_theme() {
    local theme="$1"
    local starship_file="${THEMES_DIR}/${THEME_STARSHIP[$theme]}"
    local display_name="${THEME_NAMES[$theme]}"
    local iterm_profile="${THEME_ITERM_PROFILE[$theme]}"

    if [[ ! -f "$starship_file" ]]; then
        echo -e "${c_red}  ✘ Starship config not found: $starship_file${c_reset}"
        return 1
    fi

    # Swap starship config
    cp "$starship_file" "$STARSHIP_CONFIG"

    # Switch iTerm2 profile (if iTerm2 is running)
    if pgrep -q "iTerm2"; then
        switch_iterm_profile "$iterm_profile"
    fi

    # Save current theme
    echo "$theme" > "$CURRENT_THEME_FILE"

    echo ""
    echo -e "${c_green}${c_bold}  ✓ Theme activated: ${c_white}${display_name}${c_reset}"
    echo ""
    echo -e "${c_dim}  Starship prompt updated instantly.${c_reset}"
    if pgrep -q "iTerm2"; then
        echo -e "${c_dim}  iTerm2 colors switched.${c_reset}"
    else
        echo -e "${c_dim}  iTerm2 not running — colors will apply on next launch.${c_reset}"
    fi
    echo ""
}

# ── Interactive selector with preview ──
show_menu() {
    local current=$(get_current)
    local themes=("patriot" "pastel" "vaporwave" "cyberpunk" "neon" "deepspace")
    local colors=("$c_blue" "$c_pink" "$c_purple" "$c_gold" "$c_red" "$c_cyan")
    local descriptions=(
        "Dark navy · gold accents · patriotic & professional"
        "Soft lavender · muted rose · gentle mint · cozy"
        "Deep purple · hot pink · cyan · ＡＥＳＴＨＥＴＩＣｓ"
        "Black chrome · neon yellow · electric green · Blade Runner"
        "True black · hot pink cursor · vivid everything · electric"
        "Void black · stellar gold · nebula purple · cosmic"
    )

    show_banner

    local current_name="${THEME_NAMES[$current]}"
    echo -e "  ${c_dim}Current theme:${c_reset} ${c_white}${c_bold}${current_name}${c_reset}"
    echo ""
    echo -e "  ${c_dim}─────────────────────────────────────${c_reset}"
    echo ""

    for i in "${!themes[@]}"; do
        local t="${themes[$i]}"
        local color="${colors[$i]}"
        local num=$((i + 1))
        local marker="  "
        if [[ "$t" == "$current" ]]; then
            marker="${c_green}▸ "
        fi
        echo -e "  ${marker}${color}${c_bold}${num}) ${THEME_NAMES[$t]}${c_reset}"
        echo -e "     ${c_dim}${descriptions[$i]}${c_reset}"
        echo ""
    done

    echo -e "  ${c_dim}─────────────────────────────────────${c_reset}"
    echo ""
    echo -ne "  ${c_white}Pick a theme ${c_dim}(1-6, or q to cancel)${c_white}: ${c_reset}"
    read -r choice

    case "$choice" in
        1) apply_theme "patriot" ;;
        2) apply_theme "pastel" ;;
        3) apply_theme "vaporwave" ;;
        4) apply_theme "cyberpunk" ;;
        5) apply_theme "neon" ;;
        6) apply_theme "deepspace" ;;
        q|Q) echo -e "\n  ${c_dim}Cancelled.${c_reset}\n" ;;
        *) echo -e "\n  ${c_red}Invalid choice.${c_reset}\n" ;;
    esac
}

# ── CLI interface ──
case "${1:-}" in
    "")
        show_menu
        ;;
    list)
        show_banner
        current=$(get_current)
        for t in patriot pastel vaporwave cyberpunk neon deepspace; do
            marker="  "
            [[ "$t" == "$current" ]] && marker="${c_green}▸ "
            echo -e "  ${marker}${c_white}${c_bold}${t}${c_reset}  ${c_dim}${THEME_NAMES[$t]}${c_reset}"
        done
        echo ""
        ;;
    current)
        current=$(get_current)
        echo -e "${THEME_NAMES[$current]}"
        ;;
    set)
        if [[ -z "${2:-}" ]]; then
            echo -e "${c_red}Usage: theme set <name>${c_reset}"
            echo -e "${c_dim}Available: patriot, pastel, vaporwave, cyberpunk, neon, deepspace${c_reset}"
            exit 1
        fi
        if [[ -z "${THEME_NAMES[${2}]+x}" ]]; then
            echo -e "${c_red}Unknown theme: $2${c_reset}"
            echo -e "${c_dim}Available: patriot, pastel, vaporwave, cyberpunk, neon, deepspace${c_reset}"
            exit 1
        fi
        apply_theme "$2"
        ;;
    help|--help|-h)
        show_banner
        echo -e "  ${c_white}${c_bold}Usage:${c_reset}"
        echo -e "    ${c_cyan}theme${c_reset}              Interactive theme picker"
        echo -e "    ${c_cyan}theme list${c_reset}          List all themes"
        echo -e "    ${c_cyan}theme current${c_reset}       Show current theme"
        echo -e "    ${c_cyan}theme set ${c_dim}<name>${c_reset}    Switch directly"
        echo ""
        echo -e "  ${c_white}${c_bold}Available themes:${c_reset}"
        echo -e "    ${c_blue}patriot${c_reset}  ${c_pink}pastel${c_reset}  ${c_purple}vaporwave${c_reset}  ${c_gold}cyberpunk${c_reset}  ${c_red}neon${c_reset}  ${c_cyan}deepspace${c_reset}"
        echo ""
        ;;
    *)
        # Allow bare theme names as shortcut: `theme cyberpunk`
        if [[ -n "${THEME_NAMES[${1}]+x}" ]]; then
            apply_theme "$1"
        else
            echo -e "${c_red}Unknown command: $1${c_reset}"
            echo -e "${c_dim}Run 'theme help' for usage.${c_reset}"
            exit 1
        fi
        ;;
esac
