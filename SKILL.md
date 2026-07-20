---
name: graph-plotting
description: Create, revise, and review publication-ready scientific graphs in Python/Matplotlib with Nature-style Helvetica Neue typography and bundled Nimbus Sans fallback, compact manuscript sizing, accessible colors, clean multi-panel layouts, and vector plus high-resolution raster exports. Use for manuscript figures, benchmark plots, diagnostic charts, plotting scripts, figure style cleanup, font embedding problems, Nature-style Helvetica figures, or requests to match the visual conventions of make_figures.py.
---

# Graph Plotting

Produce restrained, legible scientific figures that remain readable at final manuscript size.

## Workflow

1. Inspect the data schema, intended scientific claim, target venue constraints, and any existing plotting code before editing.
2. Choose the simplest plot type that exposes the comparison. Avoid decorative encodings and redundant visual elements.
3. Import `scripts/mpl_style.py` and use `publication_style()` as a context manager. Resolve the helper path relative to this skill directory rather than copying its implementation.
4. Set the physical figure size explicitly. Start with `(3.5, 3.0)` inches for one column or `(7.2, 3.05)` inches for two side-by-side panels, then adjust for the content.
5. Use semantic labels with units, shared scales where comparisons require them, and uncertainty or sample size when scientifically relevant.
6. Apply `finish_axis()` to ordinary Cartesian axes. Set every panel title with `set_panel_title()` and then call `add_panel_labels()` without a custom `y` value so labels and titles are vertically centred.
7. Run `audit_figure()` before export. Treat its findings as prompts for visual inspection, fixing unjustified titles, undersized text, wrong fonts, and cramped panels.
8. Use `save_figure()` to export PDF and 300-dpi PNG. Close the figure after saving.
9. Render and inspect the output. Check clipping, overlap, font consistency, color distinguishability, ordering, and readability at final size. Fix warnings rather than suppressing them.

## Typography

- Default to Helvetica Neue, loaded explicitly from `~/fonts/helvetica/HelveticaNeue.ttc`. Set `GRAPH_PLOTTING_FONT_DIR` when the font root is elsewhere. Do not redistribute the TTC files without confirming their licence.
- Use `publication_style(font_family="Nimbus Sans")` when a portable or open-font-only deliverable is required; Nimbus Sans is bundled with the skill.
- Pass any non-default family to the audit, for example `audit_figure(figure, expected_font="Nimbus Sans")`. With the default Helvetica Neue profile, `audit_figure(figure)` is sufficient.
- Use a clear hierarchy: ordinary figure text at 8 pt, panel titles at 9 pt, panel labels at 10 pt bold, and annotations/sample sizes at 7 pt. Panel titles must be slightly larger than axis and tick text without dominating the plotted area.
- For multiline titles, use compact line spacing, typically 1.1–1.2, and preserve a visible 2–4 pt gap between the final title line and the axes frame. Prefer `set_panel_title()`, whose defaults are 9 pt, 1.15 line spacing, and 3 pt padding.
- Use sentence case and concise labels. Put units in parentheses, for example `Mean daily rainfall (mm)`.
- Keep math typography compatible with sans-serif text through the bundled style configuration.
- Preserve editable/vector text in PDF. Do not rasterize the whole figure to solve a font issue.

## Visual conventions

- Use 0.7-pt axes, ticks, reference lines, and ordinary plot strokes unless data density needs a heavier mark.
- Remove top and right spines for ordinary statistical charts; retain structurally meaningful spines for maps, heatmaps, and specialized axes.
- Prefer direct labels when they stay uncluttered. Otherwise use `place_legend()`. Keep legends outside plotted marks or in deliberately reserved whitespace. Never cover bars, lines, important map features, or extrema.
- Use frameless legends only outside the data or in genuinely empty reserved space. When a legend must sit over a map or other data-rich field, call `place_legend(axis, over_data=True)` to add a semi-transparent white background.
- Use the shared palette in `mpl_style.py`; assign colors consistently by meaning across panels and figures.
- Pair color with position, marker, line style, or text whenever color alone would carry essential meaning.
- Place zero/reference lines behind data in neutral gray.
- Do not add a title inside a manuscript panel unless the title conveys necessary grouping information; put the scientific explanation in the caption.
- Avoid dense omnibus figures. As a default, keep ordinary plots at least 1.35 in wide and 1.2 in high at final size; split the figure or move secondary panels to supplementary material when this cannot be achieved.
- Judge typography relative to the physical panel size. Titles, legends, coordinate labels, and annotations must not occupy a disproportionate fraction of the plotting area.
- Keep related annotations visually grouped with the element they describe. Sample-size labels below categorical axes must sit close to their category labels, without touching them or appearing detached near the figure boundary.

## Plot-specific checks

- Bar charts: start quantitative axes at zero unless a clearly marked alternative is scientifically justified; use bars for discrete summaries, not continuous trends.
- Lines: show observations or uncertainty when available; distinguish overlapping series without relying only on color.
- Distributions: disclose normalization and binning; prefer ECDFs, intervals, or density-aware summaries when histograms obscure comparison.
- Maps: use a projection appropriate to the domain, label colorbar units, preserve geographic aspect, and avoid rainbow color maps. For comparable fields, reuse color limits. For anomaly/difference fields, use `shared_symmetric_limits()` across all panels being compared; vary limits only when the caption or figure states why.
- Coordinate labels: keep longitude, latitude, and ordinary tick labels outside the plotted data. Do not use negative tick padding to pull labels into a map; instead increase margins or adjust the gridliner label positions.
- Log axes: label them clearly and handle zero/nonpositive values explicitly.
- Categorical summaries: place sample sizes directly beneath their corresponding category labels. Use `add_sample_sizes()` or, with the x-axis transform, start around `y=-0.10` to `y=-0.14`; adjust visually and reserve only the necessary bottom margin.

Read `references/style-guide.md` when choosing dimensions, colors, output rules, or reviewing a finished figure.

## Bundled resources

- `scripts/mpl_style.py`: font registration, Matplotlib rc settings, compact panel titles, categorical sample sizes, safe legend placement, title-aligned panel labels, shared symmetric limits, compliance auditing, and deterministic PDF/PNG export.
- `assets/NimbusSans-*.otf`: portable copies of the regular, italic, bold, and bold italic files from `~/fonts/nimbus-sans`.
- `references/style-guide.md`: canonical values and a final review checklist derived from the reference plotting script.
