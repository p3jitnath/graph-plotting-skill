# Mathematical and construction schematics

Use when a figure explains a construction, algorithm, transformation, or mathematical relationship. Keep the existing Nature-style typography and palette unless the current user or document calls for another coherent profile. These checks are unnecessary for a local tick-label repair.

## Choose the scientific explanation

State what the reader should be able to follow: an input through an operation to its output, a correspondence between representations, or a property preserved by a construction. “More mathematical” means exposing the actual objects, assumptions, operations, and consequences. Extra notation or decorative curves do not strengthen the explanation.

Identify the fixed content before styling: nodes, edges, order, addresses, symbols, equations, labels, coordinate systems, and examples. If the user approves the explanation and requests colour or border changes, preserve this content. When alternatives are requested, include the current version as a reference and name variants by the presentation dimensions that differ. Keep previews separate from the active asset until selected.

## Make correspondence traceable

Show every transformation essential to the explanation, including an intermediate carrier map or representation when it determines how input becomes output. Give each operation an identifiable input, mapping, and result; an unexplained arrow must not conceal the central construction. Place equations beside their corresponding stages, with a clear link between terms and graphical objects. Align mathematical baselines within a row and give fractions, subscripts, and superscripts enough clearance.

Use the same identifier or visual encoding for the same object at every stage. Align corresponding positions or provide a clear mapping when coordinates change. Connect graphical marks to the notation in the accompanying expression. A change in colour or thickness must have a defined meaning if it appears to encode weight, probability, or importance.

Reserve arrows for meaningful relations. Distinguish data flow, time, conditional dependence, and inference if more than one appears. A stage frame or background can group related operations; ordinary statistical spine removal does not require removing a useful conceptual frame. Preserve necessary structural stage labels even when decorative titles are omitted.

Use symbols when the operation or invariant is central. Use numbers for a worked example or measured result, identifying synthetic values in the caption. Preserve mathematical restrictions rather than selecting an attractive but invalid example.

## Check the illustrated property

Choose checks that test the relationship actually claimed. Depending on the diagram, verify probability normalisation and nonnegativity, conservation, dimension compatibility, shared coordinates, boundary conditions, graph connectivity, or transformation order. Counting boxes or arrows does not establish the invariant.

For a constructed example of a mass-preserving linear map, let `p = (0.25, 0.75)` and let a matrix act on column vectors:

```text
T = [[0.8, 0.3],
     [0.2, 0.7]]
q = T p = (0.425, 0.575).
```

The columns of `T` sum to one and all entries are nonnegative, so `q` remains a probability vector. Labels and edge weights must follow that column convention. Labelling the same entries as a row-stochastic transition would change the explanation. This synthetic example illustrates conservation, not accuracy or calibration of a learned model.

Check formula restyling against the original definition, including stabilisers, branch conventions, and boundary cases. Keep a theoretical object, finite-sample estimate, and numerical approximation distinct when the contribution depends on their relationship. A proof of an invariant does not establish empirical robustness or decision value.

## Typography and space

Use a coherent text-and-mathematics profile. Preserve Helvetica Neue and compatible sans-serif mathematics for the existing Nature-style default. If the current document explicitly calls for LaTeX typography, use compatible text and mathematical faces and inspect ordinary, bold, italic, and symbolic glyphs. Check the actual exported font rather than accepting a fallback silently.

Diagnose whitespace before filling it: unused source canvas, uneven stage allocation, small document inclusion, and surrounding caption spacing need different repairs. Rebalance existing content before adding another annotation. Preserve visible gaps between labels, arrows, and frames, and review at the target physical size. A stroke can obscure a glyph even when coarse bounding boxes pass.

Preserve aspect ratio during resizing. Calculate inclusion effects on all text and line weights. For the house profile, use the final-size minimum in the [style guide](style-guide.md); do not shrink equations until they merely fit. A general plot audit may flag a deliberately small schematic stage as a small axis; inspect its role and readability without lowering global thresholds for data panels.

## Source and delivery

Use editable Matplotlib, SVG, TikZ, or an existing suitable diagram source. Prefer vector output for text, arrows, and shapes; retain raster data layers when useful. Record material fonts, dependencies, and rendering commands using portable paths where possible. Do not rasterise text to conceal a font problem.

Check the diagram's invariants separately from visual inspection of the export. When document integration is in scope, inspect the actual inclusion and caption too. Keep alternatives and accepted assets distinct, and update dependent labels and prose for an authorised semantic change. Report only checks actually performed.
