#!/bin/bash
#
# graph-plotting-skill setup
#
# Usage:
#   git clone <repo-url>
#   cd graph-plotting-skill
#   ./setup.sh
#
# What this does:
#   Copies the skill into ${CODEX_HOME:-~/.codex}/skills/graph-plotting/ so Codex
#   can discover and invoke it when you mention $graph-plotting.
#   Verifies that the default Helvetica Neue font collection is available from
#   ${GRAPH_PLOTTING_FONT_DIR:-~/fonts}/helvetica/HelveticaNeue.ttc.
#

set -e

SKILL_NAME="graph-plotting"
CODEX_ROOT="${CODEX_HOME:-$HOME/.codex}"
SKILL_DIR="$CODEX_ROOT/skills/$SKILL_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR"
FONT_ROOT="${GRAPH_PLOTTING_FONT_DIR:-$HOME/fonts}"
HELVETICA_NEUE_FILE="$FONT_ROOT/helvetica/HelveticaNeue.ttc"

echo "=== Graph Plotting Skill Setup ==="
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
    exit 1
fi

echo "Found Helvetica Neue at $HELVETICA_NEUE_FILE"
echo ""

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
echo "Installing skill files..."
for item in SKILL.md agents assets references scripts; do
    if [ -e "$SOURCE_DIR/$item" ]; then
        cp -r "$SOURCE_DIR/$item" "$SKILL_DIR/$item"
    fi
done

echo ""
echo "Installed to $SKILL_DIR"
echo ""
echo "The skill is ready for publication-quality scientific graph plotting."
echo ""
echo 'To use: open Codex in any project directory and mention $graph-plotting'
echo ""
echo "Helvetica Neue is the default typeface and will be loaded from:"
echo "  $HELVETICA_NEUE_FILE"
echo ""
echo "Bundled Nimbus Sans remains available as the portable fallback."
