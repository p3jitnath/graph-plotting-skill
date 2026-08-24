# Scientific figure style guide

## Canonical specification

| Element | Value |
|---|---|
| Default typeface | Helvetica Neue from `~/fonts/helvetica/HelveticaNeue.ttc` |
| Portable profile | Bundled Nimbus Sans; DejaVu Sans only as fallback |
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

## Titles and grouping

- Do not add figure titles, super-titles, axis titles, or panel titles unless the user explicitly requests them.
- Put the scientific claim and explanatory prose in the caption, and use axis labels, legends, panel labels, or shared row and column labels for necessary facet identity.
- Keep abbreviations consistent across axes, legends, maps, and captions.
- If the user explicitly requests panel titles, create them with `set_panel_title()` rather than `figure.text()`. Set all titles before calling `add_panel_labels()`; use 9 pt, 1.1–1.2 line spacing, and 2–4 pt of visible clearance above the axes frame.

## Categorical annotations

Use `add_sample_sizes(axis, counts, positions)` after setting categorical ticks. Its default `y=-0.12` places 7-pt labels close to their categories. Adjust within approximately `-0.10` to `-0.14`, then allocate only enough bottom margin to prevent clipping. Do not repeat the same sample-size row across adjacent panels unless each repetition is necessary for interpretation.

## Legends and coordinate labels

- Reserve whitespace for a legend before drawing it. Inspect the rendered result because automatic `loc="best"` placement is not a guarantee against overlap.
- Place a statistical legend outside the axes or in a truly empty portion of the axes with `place_legend(axis, ...)`.
- For a map legend that must cover the mapped field, use `place_legend(axis, over_data=True, ...)`. This creates a white background at 0.82 alpha; do not disable its frame.
- Never allow a legend to cover an extreme bar, line segment, station marker, target box, or geographically important feature.
- Keep latitude/longitude labels outside the map. Negative tick padding is prohibited because it makes labels obscure the field and can confuse labels with annotations.

## Review checklist

- Verify that the chosen chart answers the scientific question without implying unsupported precision or causality.
- Verify labels, units, categories, ordering, sample sizes, uncertainty, and reference values against the source data.
- Inspect the PDF at normal zoom and the PNG at its intended display size.
- Confirm the selected family is used for regular, bold, and italic text and no missing-glyph warnings occurred.
- Run `audit_figure()` and resolve or explicitly justify every finding.
- Check that labels, legends, annotations, panel letters, and tick labels do not collide or clip.
- Confirm legends do not overlap plotted artists; map legends inside the field must have a semi-transparent white background.
- Confirm longitude and latitude labels remain outside the mapped data and no major tick has negative padding.
- Confirm that no title is present unless the user explicitly requested it.
- For requested panel titles, confirm that each uses its axis title, remains subordinate to the panel label, and has visible clearance from the axes frame.
- Confirm sample-size annotations are clearly associated with their x-axis categories and are not separated by excessive whitespace.
- Inspect text-to-panel proportions at the figure’s intended publication size, not only in an enlarged preview.
- Check comparable panels use comparable scales, or visibly explain why they differ.
- Check ordinary panels meet the 1.35 × 1.2 in density floor at final size; split dense omnibus figures when necessary.
- Check line styles, markers, and colours remain distinguishable in greyscale and for common colour-vision deficiencies.
- Check all output files are reproducible from the plotting script and no interactive state is required.
