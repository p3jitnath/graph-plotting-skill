# Scientific figure style guide

Read the sections relevant to the figure, font, or encoding being changed. Explicit user, project, and venue requirements take precedence over house style defaults. Preserve unrelated design choices during a local correction. Paths in backticks are relative to the skill directory unless a project path is stated.

## Canonical specification

| Element | Value |
|---|---|
| Default typeface | Helvetica Neue from `~/fonts/helvetica/HelveticaNeue.ttc` |
| Portable profile | Bundled Nimbus Sans, selected explicitly |
| Body, axes, ticks, legend | 8 pt |
| Panel title | 9 pt; 1.1–1.2 line spacing; 2–4 pt frame gap |
| Annotation/sample size | 7 pt |
| Panel label | 10 pt, bold, lowercase |
| Axes and major ticks | 0.7 pt |
| Single-column starting size | 3.5 × 3.0 in |
| Two-panel starting size | 7.2 × 3.05 in |
| Raster output | PNG at 300 dpi |
| Vector output | PDF with TrueType text (`pdf.fonttype = 42`) |
| Categorical sample-size position | `y=-0.10` to `y=-0.14`; default `-0.12` |

The sizes are starting points, not substitutes for venue requirements. Size the canvas for its final printed width; do not create a large figure and depend on scaling it down.

Helvetica Neue is the default for Nature-style figures:

```python
with publication_style():
    # Build the complete figure inside this context.
    ...
    findings = audit_figure(figure)
```

The helper looks for `Helvetica.ttc` and `HelveticaNeue.ttc` under `$GRAPH_PLOTTING_FONT_DIR/helvetica`, `<project-root>/fonts/helvetica`, and `~/fonts/helvetica`, in that order. Because the Helvetica collections are not bundled, verify their availability and licence in every rendering environment. For portable output, select `publication_style(font_family="Nimbus Sans")` and pass the same family to `audit_figure()`.

Keep ordinary panels at least 1.35 in wide and 1.2 in high at final size. This is a practical density floor, not permission to fill every available slot. Prefer splitting a dense figure when the panels address separable claims.

## Semantic palette

| Meaning | Hex |
|---|---|
| Observation/reference | `#222222` |
| Baseline/before | `#4C78A8` |
| Corrected/after | `#E45756` |
| Neutral annotation/reference line | `#595959` |
| Additional series | `#54A24B`, `#B279A2`, `#F2CF5B` |

Reuse meanings across a paper. The palette is restrained and generally distinguishable, but no finite palette guarantees accessibility in every context. Verify important distinctions in greyscale and with a colour-vision-deficiency preview, and add a non-colour encoding where needed.

When black text overlays a dark categorical or continuous fill, move the fill two ordered shade steps towards white and verify the exported contrast. Use the same lightened shade for that semantic category throughout the figure. This rule does not authorise changing the data-to-colour mapping of a quantitative colour scale without updating its colour bar.

## Minimal pattern

```python
import os
import sys
from pathlib import Path

import matplotlib.pyplot as plt

SKILL_DIR = Path(
    os.environ.get(
        "GRAPH_PLOTTING_SKILL_DIR",
        Path.home() / ".codex" / "skills" / "graph-plotting",
    )
)
sys.path.insert(0, str(SKILL_DIR / "scripts"))
from mpl_style import (
    BASE_COLOUR,
    audit_figure,
    add_sample_sizes,
    finish_axis,
    place_legend,
    publication_style,
    save_figure,
)

with publication_style():
    figure, axis = plt.subplots(figsize=(3.5, 3.0), constrained_layout=True)
    axis.plot(x, y, color=BASE_COLOUR, label="Model")
    axis.set(xlabel="Lead time (h)", ylabel="RMSE (mm)")
    finish_axis(axis)
    place_legend(axis, loc="best")
    findings = audit_figure(figure)
    if findings:
        raise RuntimeError("Figure style audit failed:\n- " + "\n- ".join(findings))
    save_figure(figure, "figures/forecast_error")
    plt.close(figure)
```

Prefer a project-local import mechanism when integrating the helper permanently. The explicit `sys.path` form is useful for one-off scripts.

## Comparable maps and difference fields

Use identical limits for panels intended for direct comparison. Compute a single symmetric range for all difference fields rather than allowing each panel to autoscale:

```python
from mpl_style import shared_symmetric_limits

vmin, vmax = shared_symmetric_limits(*difference_fields)
for axis, difference in zip(axes, difference_fields):
    image = axis.pcolormesh(
        longitude,
        latitude,
        difference,
        cmap="RdBu_r",
        vmin=vmin,
        vmax=vmax,
    )
colorbar = figure.colorbar(image, ax=axes, label="Forecast error (m s$^{-1}$)")
```

For outlier-dominated data, `shared_symmetric_limits(*fields, percentile=98)` is acceptable only when the clipped range is disclosed. Use separate limits only when direct magnitude comparison is not intended and make the differing scales conspicuous.

## Typography

- Use British English spelling, punctuation, and usage in figure labels, legends, annotations, titles, captions, and accompanying prose unless the user or target venue explicitly requires another variety. Preserve official names, quoted text, code, variable names, and dataset or model identifiers.
- Default to Helvetica Neue. Prefer licensed project-local collections under `<project-root>/fonts/helvetica/`; use `GRAPH_PLOTTING_FONT_DIR` to point the helper at the project font root. The helper searches that environment setting, the current project's `fonts/helvetica/`, and then `~/fonts/helvetica/`, in that order. Do not redistribute the TTC files without confirming their licence.
- Use `publication_style(font_family="Nimbus Sans")` when a portable or open-font-only deliverable is required; Nimbus Sans is bundled with the skill.
- Pass any non-default family to the audit, for example `audit_figure(figure, expected_font="Nimbus Sans")`. With the default Helvetica Neue profile, `audit_figure(figure)` is sufficient.
- Check resolved families with `audit_figure()`. Fix a mismatch before claiming compliance. If the default Helvetica Neue is unavailable and no exact family was requested, select bundled Nimbus Sans explicitly and report it; keep the style and audit family arguments consistent. If the user requires an unavailable exact family, report that specific dependency and complete independent work without claiming a matching export. Separate font-parser metadata warnings from actual missing-family failures.
- Use a clear hierarchy: ordinary figure text at 8 pt, panel labels at 10 pt bold, and annotations/sample sizes at 7 pt. If the user explicitly requests panel titles, use 9 pt so they remain subordinate to panel labels.
- Treat 7 pt as the absolute minimum for every visible text element, including map ticks, place labels, annotations, legends, and direct labels. Never lower `audit_figure(..., min_font_size=...)` below 7 merely to fit a page.
- Audit effective typography at the final LaTeX inclusion size. A figure generated at 8 pt and subsequently scaled to 60% has an effective size of 4.8 pt and fails. Treat any visible text below 7 pt after scaling as a blocking failure. Regenerate at the intended printed dimensions or revise the layout before delivery; do not waive or merely report the failure.
- If the user explicitly requests multiline panel titles, use compact line spacing, typically 1.1–1.2, and preserve a visible 2–4 pt gap between the final title line and the axes frame. Prefer `set_panel_title()`, whose defaults are 9 pt, 1.15 line spacing, and 3 pt padding.
- Use sentence case and concise labels. Put units in parentheses, for example `Mean daily rainfall (mm)`.
- Keep math typography compatible with sans-serif text through the bundled style configuration.
- Preserve editable/vector text in PDF. Do not rasterize the whole figure to solve a font issue.

Set any requested panel titles before `add_panel_labels()` so label alignment uses the final title geometry.

## Visual conventions

- Use 0.7-pt axes, ticks, reference lines, and ordinary plot strokes unless data density needs a heavier mark.
- Remove top and right spines for ordinary statistical charts; retain structurally meaningful spines for maps, heatmaps, and specialized axes.
- Prefer direct labels when they stay uncluttered. Otherwise use `place_legend()`. Keep legends outside plotted marks or in deliberately reserved whitespace. Never cover bars, lines, important map features, or extrema.
- Use frameless legends only outside the data or in genuinely empty reserved space. When a legend must sit over a map or other data-rich field, call `place_legend(axis, over_data=True)` to add a semi-transparent white background.
- Use the shared palette in `scripts/mpl_style.py`; assign colours consistently by meaning across panels and figures.
- Pair colour with position, marker, line style, or text whenever colour alone would carry essential meaning.
- For phase transitions such as training to inference, encode the distinction redundantly with marker shape, colour, and line continuity. Do not connect phases unless the segment represents a meaningful continuous trajectory.
- Infer categorical meaning from the project context, data, manuscript, and requested design rather than assigning a fixed palette or marker scheme. Encodings such as connected red circles for training and an isolated blue triangle for inference are project-specific examples, not defaults.
- Use visual emphasis only when it corresponds to a stated comparison or statistically supported result. Do not highlight a variable, model, or regime merely because it was explored; remove unexplained colour emphasis.
- Place zero/reference lines behind data in neutral gray.
- Do not add or retain a figure title, super-title, axis title, or panel title unless the user explicitly requests titles. Put necessary context in axis labels, legends, panel labels, and the caption. If removing an existing title would make the model, regime, or quantity ambiguous, repair those elements rather than retaining the title without permission.
- Avoid dense omnibus figures. As a default, keep ordinary plots at least 1.35 in wide and 1.2 in high at final size; split the figure or move secondary panels to supplementary material when this cannot be achieved.
- Judge typography relative to the physical panel size. Legends, coordinate labels, annotations, and any explicitly requested titles must not occupy a disproportionate fraction of the plotting area.
- Keep related annotations visually grouped with the element they describe. Sample-size labels below categorical axes must sit close to their category labels, without touching them or appearing detached near the figure boundary.
- Inspect every text element against all immediate neighbours, not only the data: panel labels against titles, axis units, and extreme tick labels; annotations against lines and patch boundaries; place names against geographic markers; and timeline labels against event lines, arrows, and coloured intervals.
- Place each panel label over the panel it identifies rather than at a fixed figure-relative coordinate. Moving it must preserve both its semantic association with that panel and visible clearance from ticks, units, parentheses, titles, and the plot frame. Verify a complete, correctly ordered label sequence across multi-panel figures.
- Fail any text element that visually touches another glyph, line, marker, or patch boundary even when bounding boxes do not technically overlap. Reserve visible whitespace around it.
- Place labels outside their associated marker or patch when an internal label reduces readability. Preserve an unambiguous spatial association through proximity and alignment.
- Audit vertical and horizontal whitespace explicitly among the axes, colour bars, legends, footer annotations, and any explicitly requested titles. Keep requested titles and explanatory footer text subordinate to the plotted data.
- Preserve visible separation among adjacent figure elements. Colour bars, legends, panels, axis labels, annotations, and shared labels must not appear attached or crowded; allocate explicit padding and inspect the gaps at final manuscript size.
- When black text is placed over a dark fill, lighten that fill by two palette shade steps before export and then verify the rendered contrast. Apply the adjustment consistently to the same category across panels; do not rely on an outline or enlarged text to rescue an unreadable dark background.
- Set a scientifically justified reporting threshold before labelling small pie slices or narrow graphical elements. Leave values below it to the legend or an accompanying table. Use leader lines only when their associations remain unambiguous at publication size.
- For directly comparable pies, bars, maps, or panels, preserve component order, start angle, colour meaning, axis limits, and orientation unless the scientific comparison requires a documented difference.
- Give quantities with different populations or aggregations visibly different labels. Do not present a rank mean, all-rank summary, cumulative time, and selected-rank profile as though they were equivalent quantities.
- Match the manuscript's exact variable notation, capitalisation, units, mathematical form, and difference direction in every visible label.
- Choose legend rows, columns, and entry order for the available final-size width and requested grouping. Establish whether a legend applies to one panel or the whole figure and place it accordingly. The legend and caption must describe identical categories. Verify that the legend obscures no points, whiskers, curves, coastlines, or interpretive annotations in the export and, when manuscript integration is in scope, the compiled page.

## Plot-specific checks

- Bar charts: start quantitative axes at zero unless a clearly marked alternative is scientifically justified; use bars for discrete summaries, not continuous trends.
- Lines: show observations or uncertainty when available; distinguish overlapping series without relying only on colour.
- Interval plots: show every central estimate with a visible, correctly aligned marker unless the figure is intentionally interval-only and the caption says so. Check marker z-order, size, face and edge colours, and clipping in both vector and raster exports at final manuscript size; an interval line through the centre is not a visible point estimate.
- Distributions: disclose normalisation and binning; prefer ECDFs, intervals, or density-aware summaries when histograms obscure comparison.
- Maps: use a projection appropriate to the domain, label colour-bar units, preserve geographic aspect, and avoid rainbow colour maps. For comparable fields, reuse colour limits. For anomaly/difference fields, use `shared_symmetric_limits()` across all panels being compared; vary limits only when the caption or figure states why.
- Geospatial panels: inspect unexpected white regions and determine whether they represent missing data, masks, land or ocean boundaries, or plotting artefacts. Fix artefacts, but retain and explain scientifically meaningful missingness.
- Coordinate labels: keep longitude, latitude, and ordinary tick labels outside the plotted data. Do not use negative tick padding to pull labels into a map; instead increase margins or adjust the gridliner label positions.
- Log axes: label them clearly and handle zero/nonpositive values explicitly.
- Categorical summaries: place sample sizes directly beneath their corresponding category labels. Use `add_sample_sizes()` or, with the x-axis transform, start around `y=-0.10` to `y=-0.14`; adjust visually and reserve only the necessary bottom margin.

## Categorical annotations

Use `add_sample_sizes(axis, counts, positions)` after setting categorical ticks. Its default `y=-0.12` places 7-pt labels close to their categories. Adjust within approximately `-0.10` to `-0.14`, then allocate only enough bottom margin to prevent clipping. Do not repeat the same sample-size row across adjacent panels unless each repetition is necessary for interpretation.

## Export review

Inspect PDF and PNG at the intended final size, including regular, bold, italic, and mathematical glyphs. Check missing glyphs, clipping, whitespace, legend placement, and scientifically faithful marks. Resolve actual audit failures and justify intentional exceptions rather than treating every warning as fatal. Export reproducibly from the script. Use [manuscript integration](manuscript-integration.md) only when a document inclusion is part of the request.
