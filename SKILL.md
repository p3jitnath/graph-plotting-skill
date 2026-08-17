---
name: graph-plotting
description: Create, revise, and review publication-ready scientific graphs in Python/Matplotlib with Nature-style Helvetica Neue typography and bundled Nimbus Sans fallback, compact manuscript sizing, accessible colours, clean multi-panel layouts, and vector plus high-resolution raster exports. Use for manuscript figures, benchmark plots, diagnostic charts, plotting scripts, figure style cleanup, font embedding problems, Nature-style Helvetica figures, or requests to match the visual conventions of make_figures.py.
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
7. Run `audit_figure()` before export with the exact requested font family. Treat its findings as prompts for visual inspection, fixing unjustified titles, undersized text, wrong fonts, and cramped panels. Stop if any text resolves to a different family or falls below the minimum effective size after manuscript scaling.
8. Use `save_figure()` to export PDF and 300-dpi PNG. Close the figure after saving.
9. Render and inspect the output. Check clipping, overlap, font consistency, colour distinguishability, ordering, and readability at final size. Fix warnings rather than suppressing them.

## Typography

- Use British English spelling, punctuation, and usage in figure labels, legends, annotations, titles, captions, and accompanying prose unless the user or target venue explicitly requires another variety. Preserve official names, quoted text, code, variable names, and dataset or model identifiers.
- Default to Helvetica Neue. Prefer licensed project-local collections under `<project-root>/fonts/helvetica/`; use `GRAPH_PLOTTING_FONT_DIR` to point the helper at the project font root. The helper searches that environment setting, the current project's `fonts/helvetica/`, and then `~/fonts/helvetica/`, in that order. Do not redistribute the TTC files without confirming their licence.
- Use `publication_style(font_family="Nimbus Sans")` when a portable or open-font-only deliverable is required; Nimbus Sans is bundled with the skill.
- Pass any non-default family to the audit, for example `audit_figure(figure, expected_font="Nimbus Sans")`. With the default Helvetica Neue profile, `audit_figure(figure)` is sufficient.
- Never silently accept a fallback family. Run `audit_figure()` with the exact requested family and stop if any resolved font differs. Record font-parser metadata warnings separately from missing-family or fallback failures: parser warnings may be harmless, but fallback is not.
- Use a clear hierarchy: ordinary figure text at 8 pt, panel titles at 9 pt, panel labels at 10 pt bold, and annotations/sample sizes at 7 pt. Panel titles must be slightly larger than axis and tick text without dominating the plotted area.
- Treat 7 pt as the absolute minimum for every visible text element, including map ticks, place labels, annotations, legends, and direct labels. Never lower `audit_figure(..., min_font_size=...)` below 7 merely to fit a page.
- Audit effective typography at the final LaTeX inclusion size. A figure generated at 8 pt and subsequently scaled to 60% has an effective size of 4.8 pt and fails. Treat any visible text below 7 pt after scaling as a blocking failure. Regenerate at the intended printed dimensions or revise the layout before delivery; do not waive or merely report the failure.
- For multiline titles, use compact line spacing, typically 1.1–1.2, and preserve a visible 2–4 pt gap between the final title line and the axes frame. Prefer `set_panel_title()`, whose defaults are 9 pt, 1.15 line spacing, and 3 pt padding.
- Use sentence case and concise labels. Put units in parentheses, for example `Mean daily rainfall (mm)`.
- Keep math typography compatible with sans-serif text through the bundled style configuration.
- Preserve editable/vector text in PDF. Do not rasterize the whole figure to solve a font issue.

## Visual conventions

- Use 0.7-pt axes, ticks, reference lines, and ordinary plot strokes unless data density needs a heavier mark.
- Remove top and right spines for ordinary statistical charts; retain structurally meaningful spines for maps, heatmaps, and specialized axes.
- Prefer direct labels when they stay uncluttered. Otherwise use `place_legend()`. Keep legends outside plotted marks or in deliberately reserved whitespace. Never cover bars, lines, important map features, or extrema.
- Use frameless legends only outside the data or in genuinely empty reserved space. When a legend must sit over a map or other data-rich field, call `place_legend(axis, over_data=True)` to add a semi-transparent white background.
- Use the shared palette in `mpl_style.py`; assign colours consistently by meaning across panels and figures.
- Pair colour with position, marker, line style, or text whenever colour alone would carry essential meaning.
- For phase transitions such as training to inference, encode the distinction redundantly with marker shape, colour, and line continuity. Do not connect phases unless the segment represents a meaningful continuous trajectory.
- Infer categorical meaning from the project context, data, manuscript, and requested design rather than assigning a fixed palette or marker scheme. Encodings such as connected red circles for training and an isolated blue triangle for inference are project-specific examples, not defaults.
- Use visual emphasis only when it corresponds to a stated comparison or statistically supported result. Do not highlight a variable, model, or regime merely because it was explored; remove unexplained colour emphasis.
- Place zero/reference lines behind data in neutral gray.
- Default to no internal plot title for manuscript figures when the caption provides the context. Add a panel title only when it conveys necessary grouping information that the caption and panel label cannot provide.
- Avoid dense omnibus figures. As a default, keep ordinary plots at least 1.35 in wide and 1.2 in high at final size; split the figure or move secondary panels to supplementary material when this cannot be achieved.
- Judge typography relative to the physical panel size. Titles, legends, coordinate labels, and annotations must not occupy a disproportionate fraction of the plotting area.
- Keep related annotations visually grouped with the element they describe. Sample-size labels below categorical axes must sit close to their category labels, without touching them or appearing detached near the figure boundary.
- Inspect every text element against all immediate neighbours, not only the data: panel labels against titles, axis units, and extreme tick labels; annotations against lines and patch boundaries; place names against geographic markers; and timeline labels against event lines, arrows, and coloured intervals.
- Fail any text element that visually touches another glyph, line, marker, or patch boundary even when bounding boxes do not technically overlap. Reserve visible whitespace around it.
- Place labels outside their associated marker or patch when an internal label reduces readability. Preserve an unambiguous spatial association through proximity and alignment.

## Plot-specific checks

- Bar charts: start quantitative axes at zero unless a clearly marked alternative is scientifically justified; use bars for discrete summaries, not continuous trends.
- Lines: show observations or uncertainty when available; distinguish overlapping series without relying only on colour.
- Distributions: disclose normalisation and binning; prefer ECDFs, intervals, or density-aware summaries when histograms obscure comparison.
- Maps: use a projection appropriate to the domain, label colour-bar units, preserve geographic aspect, and avoid rainbow colour maps. For comparable fields, reuse colour limits. For anomaly/difference fields, use `shared_symmetric_limits()` across all panels being compared; vary limits only when the caption or figure states why.
- Geospatial panels: inspect unexpected white regions and determine whether they represent missing data, masks, land or ocean boundaries, or plotting artifacts. Fix artifacts, but retain and explain scientifically meaningful missingness.
- Coordinate labels: keep longitude, latitude, and ordinary tick labels outside the plotted data. Do not use negative tick padding to pull labels into a map; instead increase margins or adjust the gridliner label positions.
- Log axes: label them clearly and handle zero/nonpositive values explicitly.
- Categorical summaries: place sample sizes directly beneath their corresponding category labels. Use `add_sample_sizes()` or, with the x-axis transform, start around `y=-0.10` to `y=-0.14`; adjust visually and reserve only the necessary bottom margin.

## Manuscript-integration audit

Distinguish changes to the source figure from changes to its LaTeX inclusion. When a reviewer asks for a larger figure, first inspect `\includegraphics` scaling and available page width. Do not regenerate or distort the source artwork when full-width inclusion solves the problem.

After compilation, verify:

- The actual page and final printed dimensions.
- The effective font size after LaTeX scaling.
- Whether the caption and following interpretive paragraph remain with the figure.
- Whether enlargement creates a float-only page or disrupts reading order.

Inspect the rendered manuscript page, not only the standalone PDF or PNG. Treat unreadable effective typography, clipping, crowding, or misleading placement in the compiled paper as blocking failures even when the source figure passes its standalone audit.

Before delivery, run an encoding-consistency gate: marker shape, colour, line continuity, legend text, and manuscript caption must describe the same categories and phase relationships. Verify that a distinct phase such as inference remains visually disconnected when it is not part of the training trajectory.

When any encoding changes, update and verify the plotting script, PDF and PNG exports, paper-local figure copy, legend, and manuscript caption as one coordinated change. Do not deliver a partial update or leave stale exports and prose.

When the user requests two figures, produce two independent PDF/PNG pairs unless the user explicitly requests one multi-panel canvas. After integrating replacement figures, remove obsolete combined outputs and their stale LaTeX references so the repository contains only the intended figure set.

When a figure combines domain context with forecast or verification panels, split it into separate figures if the map reduces the size or comparability of the scientific panels.

Read `references/style-guide.md` when choosing dimensions, colours, output rules, or reviewing a finished figure.

## Bundled resources

- `scripts/mpl_style.py`: font registration, Matplotlib rc settings, compact panel titles, categorical sample sizes, safe legend placement, title-aligned panel labels, shared symmetric limits, compliance auditing, and deterministic PDF/PNG export.
- `assets/NimbusSans-*.otf`: portable copies of the regular, italic, bold, and bold italic files from `~/fonts/nimbus-sans`.
- `references/style-guide.md`: canonical values and a final review checklist derived from the reference plotting script.
