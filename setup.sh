#!/bin/bash
#
# graph-plotting-skill setup
#
# Usage: ./setup.sh [--harness codex|claude]
# Default harness: codex
#

set -euo pipefail

SKILL_NAME="graph-plotting"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR"
FONT_ROOT="${GRAPH_PLOTTING_FONT_DIR:-$HOME/fonts}"
HELVETICA_NEUE_FILE="$FONT_ROOT/helvetica/HelveticaNeue.ttc"
HARNESS="codex"

usage() {
    echo "Usage: $0 [--harness codex|claude]"
    echo
    echo "Install the $SKILL_NAME skill for Codex (default) or Claude Code."
    echo "  codex   ${CODEX_HOME:-$HOME/.codex}/skills/$SKILL_NAME"
    echo "  claude  ${CLAUDE_HOME:-$HOME/.claude}/skills/$SKILL_NAME"
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --harness)
            [ "$#" -ge 2 ] || { echo "Missing value for --harness" >&2; usage >&2; exit 2; }
            HARNESS="$2"
            shift 2
            ;;
        --harness=*) HARNESS="${1#*=}"; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
    esac
done

case "$HARNESS" in
    codex) HARNESS_NAME="Codex"; HARNESS_ROOT="${CODEX_HOME:-$HOME/.codex}"; INVOCATION="\$$SKILL_NAME" ;;
    claude) HARNESS_NAME="Claude Code"; HARNESS_ROOT="${CLAUDE_HOME:-$HOME/.claude}"; INVOCATION="/$SKILL_NAME" ;;
    *) echo "Unsupported harness: $HARNESS (expected codex or claude)" >&2; exit 2 ;;
esac

SKILL_DIR="$HARNESS_ROOT/skills/$SKILL_NAME"

echo "=== Graph Plotting Skill Installer ==="
echo "Harness: $HARNESS_NAME"
echo "Destination: $SKILL_DIR"
echo ""

if [ ! -f "$SOURCE_DIR/SKILL.md" ]; then
    echo "Could not find skill files at $SOURCE_DIR"
    exit 1
fi

# Check the default typeface before changing an existing installation
if [ ! -f "$HELVETICA_NEUE_FILE" ]; then
    echo "Could not find the default Helvetica Neue font collection at:"
    echo "  $HELVETICA_NEUE_FILE"
    echo ""
    echo "Place HelveticaNeue.ttc there, or set GRAPH_PLOTTING_FONT_DIR to"
    echo "the font root containing helvetica/HelveticaNeue.ttc."
    echo "Nimbus Sans remains bundled, but Helvetica Neue is the skill default."
fi

# Check if skill already exists
if [ -d "$SKILL_DIR" ] || [ -L "$SKILL_DIR" ]; then
    echo "Found existing skill at $SKILL_DIR"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
    rm -rf "$SKILL_DIR"
fi

# Create the skill directory
mkdir -p "$SKILL_DIR"

# Copy all files required by the skill
echo "Installing $SKILL_NAME for $HARNESS_NAME..."
for item in SKILL.md assets references scripts; do
    if [ -e "$SOURCE_DIR/$item" ]; then
        cp -r "$SOURCE_DIR/$item" "$SKILL_DIR/$item"
    fi
done

if [ "$HARNESS" = "codex" ] && [ -e "$SOURCE_DIR/agents" ]; then
    cp -r "$SOURCE_DIR/agents" "$SKILL_DIR/agents"
fi

echo ""
echo "Installation complete."
echo "Skill: $SKILL_NAME"
echo "Harness: $HARNESS_NAME"
echo "Location: $SKILL_DIR"
echo "Invoke: $INVOCATION"
echo ""
echo "Helvetica Neue is the default typeface and will be loaded from:"
echo "  $HELVETICA_NEUE_FILE"
echo ""
echo "Bundled Nimbus Sans remains available as the portable fallback."
