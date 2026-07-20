# Graph Plotting Skill

A Codex skill for producing publication-ready scientific figures with consistent typography, panel layout, legends, annotations, and PDF/PNG export.

## Requirements

- Codex
- Bash
- Python with Matplotlib and NumPy for using the plotting helper
- `HelveticaNeue.ttc` for the default Helvetica Neue profile

Nimbus Sans is bundled and can be selected when Helvetica Neue is unavailable or unsuitable for redistribution.

## Install

Clone the repository and run the installer:

```bash
git clone git@github.com:p3jitnath/graph-plotting-skill.git
cd graph-plotting-skill
./setup
```

By default, `setup`:

1. Looks for Helvetica Neue at `~/fonts/helvetica/HelveticaNeue.ttc`.
2. Installs the skill under `${CODEX_HOME:-$HOME/.codex}/skills/graph-plotting`.
3. Prompts before replacing an existing installation.

Restart Codex if the installed skill does not appear in the current session.

## Custom font location

If the font root is somewhere other than `~/fonts`, set `GRAPH_PLOTTING_FONT_DIR`. The directory must contain `helvetica/HelveticaNeue.ttc`:

```bash
GRAPH_PLOTTING_FONT_DIR="$FONT_ROOT" ./setup
```

Here, `FONT_ROOT` is a directory chosen by the user that contains the `helvetica` subdirectory.

Set the same environment variable when running plotting scripts so the helper can locate Helvetica Neue.

## Custom Codex location

Set `CODEX_HOME` before installation:

```bash
CODEX_HOME="$CUSTOM_CODEX_HOME" ./setup
```

Here, `CUSTOM_CODEX_HOME` is the desired Codex configuration directory.

## Use

Open Codex in a project and ask it to use `$graph-plotting`, for example:

```text
Use $graph-plotting to revise this Matplotlib figure for publication.
```

The plotting helper is installed at `scripts/mpl_style.py` inside the skill directory. It provides typography configuration, title and panel-label alignment, sample-size placement, legend handling, figure auditing, and PDF/PNG export.

## Update

Pull the latest version and rerun the installer:

```bash
git pull --ff-only
./setup
```

Confirm the overwrite prompt to replace the installed copy.
