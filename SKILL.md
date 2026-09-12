---
name: graph-plotting
description: Create, revise, and review scientific Matplotlib figures with publication typography, accessible encodings, and reproducible PDF and PNG exports.
---

# Graph Plotting

Produce scientific figures that remain accurate and legible at their final publication size.

## Scope and defaults

Follow the user's requested figure, data, formats, and typography over this skill's house defaults. Preserve scientific values and the meaning of units, aggregation, reference baselines, and uncertainty. Infer routine layout choices from the data, existing script, and intended comparison, then finish the requested exports without pausing for ordinary design decisions.

Use British English unless the user, project, or venue specifies otherwise. Preserve literal identifiers and official names. Do not add figure or panel titles unless requested; use labels, legends, facet identity, and captions for necessary context.

The default family is Helvetica Neue. If it is unavailable and the user has not required an exact font, select bundled Nimbus Sans explicitly and disclose the choice. Keep `publication_style(font_family=...)` and `audit_figure(expected_font=...)` consistent. An unavailable explicitly required font is a dependency to report, not a reason to abandon unrelated work or silently substitute another family.

## Figure work

Inspect the relevant data and plotting code before changing them. For creation or style changes, read the needed sections of [style-guide.md](references/style-guide.md), which contains canonical dimensions, typography, palette, encoding checks, and helper examples. A small label correction does not require redesigning the figure.

Import `scripts/mpl_style.py` relative to this skill directory and use `publication_style()` around figure creation. Set physical dimensions for the intended printed size. Starting values are 3.5 × 3.0 inches for one column and 7.2 × 3.05 inches for two panels, with 8-pt ordinary text, 10-pt panel labels, and a 7-pt effective minimum. Adjust layout or canvas dimensions to preserve readable type after scaling.

Use the helpers that fit the plot: `finish_axis()`, `place_legend()`, `add_panel_labels()`, `add_sample_sizes()`, and `shared_symmetric_limits()`. Run `audit_figure()` with the selected family, resolve material findings, and use `save_figure()` for the default PDF and 300-dpi PNG pair. Honor explicitly requested output formats.

Inspect the rendered exports for faithful values, clipping, overlap, spacing, colour distinguishability, and effective font size. Fix defects rather than lowering the minimum merely to pass an audit. Do not claim final-size compliance while text remains unreadable or a required family is unresolved.

## Manuscript work

Read [manuscript-integration.md](references/manuscript-integration.md) when changing LaTeX inclusion, figure placement, captions, or manuscript-linked results. Check source dimensions against inclusion scaling before regenerating artwork. Update requested exports and dependent captions or text together, then inspect the affected compiled pages. Standalone plotting does not require a manuscript project.

## Completion

Deliver the plotting source and requested exports, with a brief note about material changes, checks, and unresolved dependencies. Stop verification once applicable checks pass; repeat or broaden it only after another edit, a failure, or a concrete concern. A missing manuscript or renderer limits only the checks that need it. If a skill instruction requires a pause, identify its file and explain the specific conflict; retain authorization already given for the requested work.
