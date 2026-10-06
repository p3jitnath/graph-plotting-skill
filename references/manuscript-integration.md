# Manuscript integration

Use only when a manuscript inclusion or its dependent captions and text are in scope. A standalone figure does not require a manuscript, compilation, or a paper-wide audit.

Distinguish changes to the source figure from changes to its LaTeX inclusion. When a reviewer asks for a larger figure, first inspect `\includegraphics` scaling and available page width. Do not regenerate or distort the source artwork when full-width inclusion solves the problem.

Identify the active source, asset, caption, and build route from current content. Preserve explicit caption gaps, protected wording, and aspect ratios. Unused source canvas, panel allocation, inclusion size, and surrounding document whitespace need different repairs; fix the source of the gap rather than adding content or negative spacing indiscriminately.

When an authorised figure-to-table conversion better communicates exact estimates, preserve values and interval meanings, update object references and the caption, and replace prose about marks that no longer exist. For a publication-name change, update visible labels while preserving the mapping to historical result identifiers. Review markup and its colours are separate from scientific figure encodings.

When accepting revisions, inspect editable figure sources and embedded figure text as well as manuscript prose for the designated review-colour layer. Remove or accept that layer inside the assets and regenerate affected exports, preserving scientific colours, category meanings, equations, emphasis, and accepted wording. Do not strip all uses of a colour simply because it also marks revisions.

Use a source-versus-inclusion gate for any undersized figure. Increase LaTeX inclusion width when that alone restores legibility. Regenerate at the intended one- or two-column dimensions when scaling would reduce effective text below 7 pt, and inspect single-column figures at single-column dimensions.

After compilation, verify:

- The actual page and final printed dimensions.
- The effective font size after LaTeX scaling.
- Whether the caption and following interpretive paragraph remain with the figure.
- Whether enlargement creates a float-only page or disrupts reading order.

Inspect the rendered manuscript page, not only the standalone PDF or PNG. Treat unreadable effective typography, clipping, crowding, or misleading placement in the compiled paper as blocking failures even when the source figure passes its standalone audit.

Audit readability independently of numerical correctness. Check overlapping labels, faint colours, border opacity, map-number legibility, colour-bar tick spacing and separation from its parent axes, and whether zero or neutral values remain recognisable at final size.

For every panel, make the plotted model, route, target, metric, difference direction, and reference recoverable from its labels and caption. Define the reference level, direction of improvement, threshold rule, and meaning of extrema or positive regions for nonstandard curves. Difference plots must state which sign favours which model, and decision-value, reliability, and discrimination curves must define their reference lines and useful regions.

Before delivery, run an encoding-consistency gate: marker shape, colour, line continuity, legend text, and manuscript caption must describe the same categories and phase relationships. Verify that a distinct phase such as inference remains visually disconnected when it is not part of the training trajectory.

When an accepted asset's encoding changes, update and verify the plotting script, requested exports, paper-local figure copy, legend, and manuscript caption as one coordinated change. Keep requested previews and alternatives separate until selected; generating a variant does not replace the active manuscript asset automatically.

After regeneration, compare the plotting script, PNG, PDF, paper-local copy, and compiled manuscript page. Regenerate or clearly exclude stale generated artefacts in scope. Preserve source data and unrelated files. A provenance-bearing filename may retain a run identifier, but visible reader-facing text must use the agreed scientific name.

After a layout-only revision, compare the new compiled page with the prior page at final size, checking text positions, panel boundaries, labels, legends, clipping, and preservation of scientific marks and values. For a data-changing revision, compare plotted values with the canonical result artefact separately from the page-layout inspection.

When the user requests two figures, produce two independent PDF/PNG pairs unless the user explicitly requests one multi-panel canvas. After integrating replacements, remove stale active references and clearly separate obsolete generated exports; preserve requested alternatives and source history.

When a figure combines domain context with forecast or verification panels, split it into separate figures if the map reduces the size or comparability of the scientific panels.

For a data-changing revision, identify the canonical experiment and source data, regenerate requested outputs, and reconcile dependent captions and text. For inclusion or layout changes, compile and inspect affected pages at final size. Check for stale values where the changed result is used. Report unresolved warnings separately from passed checks, and repeat successful checks only after a new edit or concrete concern.

## Caption narrative

Use polished academic English and the manuscript's requested writing convention for captions and accompanying prose. Define every acronym, specialised term, metric and architectural component at first use in a self-contained caption, including metric units, reference and direction of improvement where relevant. Keep terminology consistent with the manuscript and the figure.

Connect the plotted observation to the scientific question, supported interpretation and consequence. When accompanying narrative is in scope, carry observation → problem → response → result → consequence through that argument without forcing all five moves into a short caption. Use an explicit bridge when a demonstrated result or trade-off motivates the next step. Each sentence should explain the scientific role of the marks, comparison or finding.

State supported results directly, precisely and confidently. Preserve every value, uncertainty interval, comparison and scientific distinction. Keep essential interpretation conditions with the figure and concentrate general limitations neutrally in the manuscript's Discussion or Scope section. Combine the result, interpretation and relevant trade-off when this produces one clear thought. Fluency must not imply unmeasured superiority or alter data, units, colour scales or encodings.
