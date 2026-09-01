# Graph Plotting Skill

An Agent Skill for Codex and Claude Code that produces publication-ready scientific figures with consistent typography, panel layout, legends, annotations, and PDF/PNG export.

## Requirements

- Codex or Claude Code
- Bash
- Python with Matplotlib and NumPy for using the plotting helper
- `HelveticaNeue.ttc` for the default Helvetica Neue profile

Nimbus Sans is bundled and can be selected when Helvetica Neue is unavailable or unsuitable for redistribution.

## Install

Clone the repository and run the installer:

```bash
git clone git@github.com:p3jitnath/graph-plotting-skill.git
cd graph-plotting-skill
./setup.sh
```

By default, `setup.sh`:

1. Looks for Helvetica Neue at `~/fonts/helvetica/HelveticaNeue.ttc`.
2. Installs the skill under `${CODEX_HOME:-$HOME/.codex}/skills/graph-plotting`.
3. Prompts before replacing an existing installation.

To install for Claude Code under `${CLAUDE_HOME:-$HOME/.claude}/skills/graph-plotting`, run:

```bash
./setup.sh --harness claude
```

Invoke the skill as `$graph-plotting` in Codex or `/graph-plotting` in Claude Code. Restart the selected harness if the installed skill does not appear in the current session.

## Custom font location

If the font root is somewhere other than `~/fonts`, set `GRAPH_PLOTTING_FONT_DIR`. The directory must contain `helvetica/HelveticaNeue.ttc`:

```bash
GRAPH_PLOTTING_FONT_DIR="$FONT_ROOT" ./setup.sh
```

Here, `FONT_ROOT` is a directory chosen by the user that contains the `helvetica` subdirectory.

Set the same environment variable when running plotting scripts so the helper can locate Helvetica Neue.

## Custom harness location

Set `CODEX_HOME` for Codex or `CLAUDE_HOME` for Claude Code before installation:

```bash
CODEX_HOME="$CUSTOM_CODEX_HOME" ./setup.sh
CLAUDE_HOME="$CUSTOM_CLAUDE_HOME" ./setup.sh --harness claude
```

These variables identify the selected harness's configuration directory.

## Usage

Open the selected harness in a project and invoke `$graph-plotting` in Codex or `/graph-plotting` in Claude Code. For example:

```text
Use $graph-plotting to revise this Matplotlib figure for publication.
/graph-plotting revise this Matplotlib figure for publication.
```

The plotting helper is installed at `scripts/mpl_style.py` inside the skill directory. It provides typography configuration, title and panel-label alignment, sample-size placement, legend handling, figure auditing, and PDF/PNG export.

## Update

Pull the latest version and rerun the installer:

```bash
git pull --ff-only
./setup.sh
# Or retain a Claude installation:
./setup.sh --harness claude
```

Confirm the overwrite prompt to replace the installed copy.
