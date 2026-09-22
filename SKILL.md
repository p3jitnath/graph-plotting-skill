---
name: graph-plotting
description: Create, revise, and review scientific Matplotlib plots and mathematical schematics with publication typography, faithful encodings, editable source, and reproducible exports.
---

# Graph Plotting

Produce scientific figures that remain accurate and legible at their final publication size. Preserve the established Nature-style house defaults when drawing ideas from external examples; use those examples to inform chart structure and comparison design.

## Scope and defaults

Follow the user's requested figure, scope, formats, and established visual profile over this skill's house defaults. Identify the visual's scientific job: construction, comparison, distribution, case, or system context. Preserve data, topology, labels, equations, scales, order, and category meanings during styling work. An inspection-only request returns findings; it does not replace assets. Infer routine layout choices from current context and complete authorised edits without pausing for ordinary design decisions.

Resolve audience, dimensions, caption spacing, notation, and permitted redesign from the current request and document. “Publication quality” calls for a clearer explanation and final-size legibility. If the original explanation is preferred, refine it. When alternatives are requested, retain the original as a reference and keep variants separately named and comparable until one is selected.

Use British English unless the user, project, or venue specifies otherwise. Preserve literal identifiers and official names. Do not add decorative figure or panel titles unless requested; retain structural stage labels, axis labels, legends, and facet identity needed to follow the science.

The default family is Helvetica Neue. If it is unavailable and the user has not required an exact font, select bundled Nimbus Sans explicitly and disclose the choice. Keep `publication_style(font_family=...)` and `audit_figure(expected_font=...)` consistent. An unavailable explicitly required font is a dependency to report, not a reason to abandon unrelated work or silently substitute another family.

## Figure work

Inspect the relevant data and plotting code before changing them. For creation or style changes, read the needed sections of [style-guide.md](references/style-guide.md), which contains canonical dimensions, typography, palette, encoding checks, and helper examples. A small label correction does not require redesigning the figure.

When choosing a plot or arranging comparisons, read the relevant sections of [plot-patterns.md](references/plot-patterns.md). It covers grouped comparisons, ablations, shared legends, uncertainty bands, composition, heatmaps, timelines, and specialised plots, with ideas drawn from `figures4papers` and adapted to this skill's style. These are optional patterns; retain the user's requested chart and scientific meaning.

For a mathematical or construction diagram, read [mathematical-schematics.md](references/mathematical-schematics.md). Make operations and correspondences traceable and verify the illustrated properties. Choose symbols or synthetic values according to the explanation; a schematic does not provide empirical performance evidence.

For Matplotlib artwork, import `scripts/mpl_style.py` relative to this skill directory and use `publication_style()` around figure creation. Preserve a suitable existing editable backend for other schematics, applying the established profile through its native controls. Set physical dimensions for the intended printed size. Starting values are 3.5 × 3.0 inches for one column and 7.2 × 3.05 inches for two panels, with 8-pt ordinary text, 10-pt panel labels, and a 7-pt effective minimum. Adjust layout or canvas dimensions to preserve readable type after scaling.

Use the Matplotlib helpers that fit the plot: `finish_axis()`, `place_legend()`, `add_panel_labels()`, `add_sample_sizes()`, and `shared_symmetric_limits()`. Run `audit_figure()` with the selected family, resolve material findings, and use `save_figure()` for the default PDF and 300-dpi PNG pair. For other backends, perform equivalent font, geometry, and export checks. Honour explicitly requested output formats.

Verify numerical or mathematical fidelity independently from visual clarity. Inspect rendered exports for clipping, overlap, spacing, colour distinguishability, and effective font size, including symbols, subscripts, and superscripts. Fix defects rather than lowering the minimum merely to pass an audit. Do not claim final-size compliance while text remains unreadable or a required family is unresolved.

## Manuscript work

Read [manuscript-integration.md](references/manuscript-integration.md) when changing LaTeX inclusion, figure placement, captions, or manuscript-linked results. Check source dimensions against inclusion scaling before regenerating artwork. Update requested exports and dependent captions or text together, then inspect the affected compiled pages. Standalone plotting does not require a manuscript project.

## Completion

Deliver the plotting source and requested exports, with a brief note about material changes, checks, and unresolved dependencies. Stop verification once applicable checks pass; repeat or broaden it only after another edit, a failure, or a concrete concern. A missing manuscript or renderer limits only the checks that need it. If a skill instruction requires a pause, identify its file and explain the specific conflict; retain authorization already given for the requested work.
