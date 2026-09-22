# Publication plot patterns

Read the section that matches the scientific comparison. These patterns extend the Nature-style [style guide](style-guide.md); its typography, palette, dimensions, and export settings still apply. Prefer a simpler arrangement when it communicates the same result at the intended printed size. Honour an explicitly requested chart type.

## Choose the comparison

| Scientific question | Useful starting point | Check before drawing |
|---|---|---|
| How do methods compare across a few conditions? | Grouped bars or points with intervals | Same estimand, units, category order, and uncertainty definition |
| Which components change performance? | Horizontal ablation rows with intervals | Explicit component identities and a common full-model reference |
| How does a response vary with lead time, data amount, or a parameter? | Lines with measured points; separate panels for different metrics | Actual numeric spacing and a justified connection between points |
| How is a population divided among outcomes? | Stacked counts or 100% stacked bars | Mutually exclusive components, denominator, and complete totals |
| Where are differences across two categorical dimensions? | Heatmap with a labelled colour bar | Comparable scales, missingness, and any normalisation |
| What is the accuracy–cost trade-off? | Scatter with direct labels or a few labelled candidates | Metric direction, cost units, and comparable evaluation conditions |
| What is a method's profile across several metrics? | Aligned point panels; radar when requested or useful for profile shape | Metric direction and explicit per-metric scaling |

## Grouped comparisons and ablations

For grouped bars, centre the group on each category tick. With `n` series, use offsets `(j - (n - 1) / 2) * width`; keep the whole group narrower than the category spacing. Use a fixed method order across metrics and assign styles by method name so sorting or omitting a method cannot change its colour. Preserve readable category labels; hide them only when another visible encoding identifies every group unambiguously.

Use sparse hatches or marker shapes to distinguish related conditions in greyscale. If colour represents method and hatch represents condition, provide separate keys for those two meanings, using `matplotlib.patches.Patch` or `matplotlib.lines.Line2D` proxy artists. Alpha can soften secondary marks, but is a weak sole identifier for many ablation variants. Keep edges at the house stroke weight and check that hatches do not dominate the bars.

Bars retain a zero baseline. For small differences near a bounded score's ceiling, points with intervals allow a focused numeric range without implying a bar-length comparison. Long ablation names often fit horizontal rows better; wrap meaningful component names or align a compact component-presence matrix with the performance rows. Preserve row order across panels. A difference panel can show `variant − full model` against zero, provided the sign, units, and uncertainty of that difference are defined. Compute paired differences from matched samples or runs when available; marginal error bars alone do not determine uncertainty in a difference.

Record what an error bar represents: standard deviation, standard error, confidence interval, or quantiles, plus the independent sampling unit and sample size. Preserve asymmetric intervals. Do not invent uncertainty for a single reported value or infer significance from overlapping bars. Annotate exact values only when they help the comparison, with appropriate precision and visible clearance above whiskers.

### Centred bars with supplied asymmetric intervals

This is an original example with **synthetic values and illustrative interval endpoints**, not a statistical calculation. Replace all three arrays with the project's summaries; rows identify methods and columns identify regions. The example assumes each interval contains its central estimate. As in the [minimal import pattern](style-guide.md#minimal-pattern), make this skill's `scripts/` directory importable first. Select Nimbus Sans explicitly in both the context and audit if Helvetica Neue is unavailable.

```python
import numpy as np
import matplotlib.pyplot as plt
from mpl_style import (
    BASE_COLOUR, CORRECTED_COLOUR, NEUTRAL_COLOUR,
    publication_style, finish_axis, place_legend, audit_figure, save_figure,
)

categories = ["Coastal", "Inland", "Mountain"]
series = [("Baseline", BASE_COLOUR, ""),
          ("Corrected", CORRECTED_COLOUR, "//")]
estimate = np.array([[0.62, 0.68, 0.58], [0.70, 0.74, 0.66]])
lower = np.array([[0.56, 0.63, 0.52], [0.65, 0.70, 0.60]])
upper = np.array([[0.67, 0.72, 0.65], [0.76, 0.79, 0.71]])
assert estimate.shape == lower.shape == upper.shape == (len(series), len(categories))
assert np.isfinite([estimate, lower, upper]).all()
assert np.all(lower <= estimate) and np.all(estimate <= upper)

with publication_style():
    figure, axis = plt.subplots(figsize=(3.5, 3.0), constrained_layout=True)
    x = np.arange(len(categories))
    width = 0.8 / len(series)
    for j, (label, colour, hatch) in enumerate(series):
        error = np.vstack((estimate[j] - lower[j], upper[j] - estimate[j]))
        axis.bar(
            x + (j - (len(series) - 1) / 2) * width, estimate[j],
            width=width, yerr=error, label=label,
            color=colour, edgecolor=NEUTRAL_COLOUR, linewidth=0.7, hatch=hatch,
            error_kw={"ecolor": NEUTRAL_COLOUR, "elinewidth": 0.7,
                      "capsize": 2, "capthick": 0.7},
        )
    axis.set_xticks(x, categories)
    axis.set(ylabel="Accuracy", ylim=(0, 1))
    finish_axis(axis)
    place_legend(axis, loc="lower center", bbox_to_anchor=(0.5, 1.01), ncol=2)
    findings = audit_figure(figure)
    if findings:
        raise RuntimeError("\n".join(findings))
    save_figure(figure, "figures/grouped_comparison")
    plt.close(figure)
```

## Multiple panels and shared legends

Group panels around a single comparison and identify each metric through its axis label. Keep method styles and order consistent, with shared axis limits only for comparable quantities. Use `GridSpec` width or height ratios when a long label, colour bar, or shared legend needs deliberate space. Budget that space at the printed width; a large canvas later reduced into a column does not solve density.

For a shared legend, gather handles from **all** relevant panels and deduplicate by semantic label after confirming that repeated labels have identical encodings. A series present only in the second panel must still appear. A compact figure legend above or below the axes usually leaves more room for data than a full legend panel. Reserve a column or row for a large legend when necessary, call `set_axis_off()` on that auxiliary axis, and apply panel labels only to data axes. Use one layout mechanism; avoid combining constrained layout with later `tight_layout()` or manual subplot adjustments.

The current `audit_figure()` measures every axis, including colour bars and legend-only axes. Review an auxiliary-axis size finding against that axis's role and inspect its labels; retain the minimum dimensions for data panels and the 7-pt text minimum throughout. Do not shrink the global audit thresholds to accommodate a narrow colour bar. Inspect figure legends visually because the helper's overlap checks cover axis legends only.

## Trends, parameter sweeps, and uncertainty bands

Plot numeric parameters at their actual coordinates, including unequal steps. Use a logarithmic scale only when scientifically meaningful and handle nonpositive values explicitly. Equally spaced category positions are suitable for discrete conditions; connecting them must not imply a numeric slope. Put quantities with different units in separate panels unless a justified secondary-axis relationship is part of the requested figure.

Show measured points with distinct markers and line styles; use restrained fills behind the curves for supplied uncertainty. The band has a statistical meaning, not a decorative shadow. Preserve gaps for missing measurements in both the line and band. Sort coordinates and every corresponding array together. Disclose smoothing, aggregation, or interpolation; do not fabricate extra measurements to make a curve smooth.

### Two metrics with one legend

This original example uses **synthetic means and standard deviations**. Each array has shape `(method, lead_time)`; a real caption must identify the sampling unit and number of replicates. The bands show mean ± one standard deviation, not confidence intervals. The shared figure legend uses Matplotlib's constrained-layout `outside` placement (Matplotlib 3.7 or later).

```python
import numpy as np
import matplotlib.pyplot as plt
from mpl_style import (
    BASE_COLOUR, CORRECTED_COLOUR, publication_style, finish_axis,
    add_panel_labels, audit_figure, save_figure,
)

lead_time = np.array([6, 12, 24, 48])
styles = [("Baseline", BASE_COLOUR, "o", "--"),
          ("Corrected", CORRECTED_COLOUR, "s", "-")]
panels = [
    ("RMSE (K)",
     np.array([[1.1, 1.3, 1.7, 2.2], [0.9, 1.1, 1.4, 1.9]]),
     np.array([[0.08, 0.10, 0.12, 0.15], [0.06, 0.09, 0.11, 0.13]])),
    ("MAE (K)",
     np.array([[0.8, 1.0, 1.3, 1.7], [0.7, 0.8, 1.1, 1.4]]),
     np.array([[0.05, 0.07, 0.08, 0.12], [0.04, 0.06, 0.07, 0.10]])),
]

with publication_style():
    figure, axes = plt.subplots(
        1, 2, figsize=(7.2, 3.05), sharex=True, constrained_layout=True,
    )
    for axis, (ylabel, mean, sd) in zip(axes, panels):
        assert mean.shape == sd.shape == (len(styles), len(lead_time))
        assert np.all(np.isfinite(sd) & (sd >= 0))
        for j, (label, colour, marker, line_style) in enumerate(styles):
            axis.fill_between(
                lead_time, mean[j] - sd[j], mean[j] + sd[j],
                color=colour, alpha=0.15, linewidth=0, zorder=1,
            )
            axis.plot(
                lead_time, mean[j], label=label, color=colour,
                marker=marker, markersize=3, linestyle=line_style, zorder=2,
            )
        axis.set(xlabel="Lead time (h)", ylabel=ylabel)
        axis.set_xticks(lead_time)
        finish_axis(axis)
    legend_entries = {}
    for axis in axes:
        handles, labels = axis.get_legend_handles_labels()
        for handle, label in zip(handles, labels):
            legend_entries.setdefault(label, handle)
    figure.legend(
        list(legend_entries.values()), list(legend_entries),
        loc="outside upper center", ncol=2, frameon=False,
    )
    add_panel_labels(axes)
    findings = audit_figure(figure)
    if findings:
        raise RuntimeError("\n".join(findings))
    save_figure(figure, "figures/trend_comparison")
    plt.close(figure)
```

## Composition and transitions

Use stacked bars for mutually exclusive components of a whole. Compute cumulative bottoms from the displayed component order and verify sums against the source totals. For 100% stacks, divide by the correct group total, label the axis as a proportion or percentage, and retain sample sizes when group sizes differ. A zero-total group is undefined, not a row of measured zero proportions. Overlapping categories need separate counts or an explicitly defined allocation rather than a misleading stack.

Preserve component order and colour meanings across groups. Stack only when the total or composition is the question: interior segments do not share a baseline, so grouped bars or point panels often make small component differences easier to compare. Separate before/after performance from transition counts when both matter. A transition such as incorrect → correct must state whether its denominator is all cases or only initially incorrect cases; the two answer different questions. Pairing individual observations can justify a paired-point display.

## Heatmaps and count matrices

Keep both category dimensions labelled, with consistent row and column ordering across panels. Use a sequential colour map for counts or nonnegative magnitude and a diverging scale with a meaningful centre for signed differences. Reuse one normalisation for comparable panels; use `shared_symmetric_limits()` for comparable difference matrices. Explain row, column, or global normalisation and label the colour bar accordingly. Summing across overlapping categories does not produce a count of unique observations.

Use `imshow(..., interpolation="nearest")` or a suitable `pcolormesh` so interpolation does not imply unsampled intermediate categories. Mask missing cells and distinguish them from true zero values. Add cell values only when they remain readable at final size, use a justified numeric precision, and group long row labels with spacing or subtle separators. Place annotations outside dark cells or select a legible text colour; preserve the quantitative colour mapping and its colour bar. Do not lighten individual cells independently to fit black text. Rasterise a dense mesh when useful while retaining vector text and axes in the PDF.

## Distributions and diagnostic proxies

Identify the random quantity and representation: finite sample, weighted empirical distribution, histogram, or continuous density estimate. Retain the weights, normalisation, bin widths, and smoothing convention needed to interpret it. Do not add smooth tails or uncertainty bands solely to imitate another paper. A scalar-summary density does not represent an entire multivariate law, and a density contour is not automatically a confidence region.

For spread against a difficulty or similarity proxy, define the proxy, units, reference population, grouping, and weighting. Keep means and medians distinct and inspect influential observations when a sharp group-mean change drives the interpretation. Association between spread and a proxy does not establish calibration or the correct uncertainty magnitude. Retain relevant comparator patterns and use consistent normalisation before comparing absolute values.

If a valid transform hides a small but important component, consider a direct comparison, aligned panels, or a labelled zoom within the requested scope. Keep the data fixed and disclose the transformation or restricted range. Distinguish pooled crossings, subgroup crossings, and settings where every subgroup has the same sign; markers identify tested settings, not an unmeasured exact threshold.

## Event timelines and cumulative trends

Use real dates for date axes and label whether values are interval counts, rates, or cumulative totals. Accumulate once, in chronological order, with an explicit missing-period policy. A filled area down to zero represents magnitude; an uncertainty band lies between statistical bounds. A stack must represent additive components, while overlaid fills can conceal one another.

Store events as a list of `(date, label)` records so multiple events on the same date survive. Anchor arrows to verified dates or measurements and use point offsets for annotation text. Stagger nearby labels into a small number of rows or a reserved annotation band. Choose a few relevant events; dense callouts compete with the trend. An event marker establishes timing, not causation.

## Trade-offs, radar plots, and conceptual geometry

For accuracy–cost comparisons, label cost in actual units and state which direction improves each metric. Avoid joining independent methods as a continuous trajectory. If showing a Pareto frontier, calculate dominance using those directions on comparable measurements; missing results remain missing, and uncertainty may change which candidates appear dominant.

For a requested radar chart, fix spoke order, disclose each metric's transformation and bounds, and make the direction of improvement consistent. Preserve real vertex values and explicitly identify any clipping. Do not replace missing metrics with a method's mean or zero to close a polygon; keep visible gaps or choose an alternative display. Polygon area is not an aggregate performance score and changes with spoke order. Keep fills faint and use markers; use separate panels when profiles overlap too heavily.

Conceptual spheres, manifolds, and trajectories can explain a mechanism when spatial structure is part of the claim. Identify synthetic geometry as schematic in the caption and retain axes or scales for measured coordinates. Seed stochastic illustrative geometry for reproducibility. Use equal aspect where geometry depends on it; viewpoint, shading, and occlusion must not imply unsupported distances or superiority. Dense backgrounds can be rasterised separately while labels and meaningful trajectories stay vector. Keep decorative 3D out of ordinary quantitative comparisons.

## Sources and implementation notes

Design inspiration: Chen Liu's [figures4papers](https://github.com/ChenLiu-1996/figures4papers), reviewed at commit [`3c181f85e82c6f24948fcaaf3be6696102b41d8d`](https://github.com/ChenLiu-1996/figures4papers/tree/3c181f85e82c6f24948fcaaf3be6696102b41d8d). This reference contains newly written guidance and examples, with local statistical and Nature-style adaptations. Upstream code, figures, and data are not bundled; the repository's [licence](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/LICENSE) is CC BY-NC 4.0.

| Inspected source | Useful idea informing this reference |
|---|---|
| [ImmunoStruct comparisons](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/figure_ImmunoStruct/plot_bars.py) | Aligned metric panels, error bars, horizontal ablation rows, and reserved legend space |
| [CellSpliceNet ablations](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/figure_CellSpliceNet/plot_ablation.py) | A common full-model reference and explicit changes after component removal |
| [Brainteaser rewriting](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/figure_Brainteaser/plot_rewriting.py) | Separate method/condition encodings and before/after versus transition comparisons |
| [RNAGenScape sweeps](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/figure_RNAGenScape/plot_sweep.py) | Measured markers at actual parameter coordinates with one metric per panel |
| [Ophthalmology count matrix](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/figure_ophthal_review/plot_composition.py) | Annotated counts with category groupings and marginal totals |
| [Ophthalmology trends](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/figure_ophthal_review/plot_trend.py) | Cumulative trends with dated event callouts |
| [VIGIL radar comparison](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/figure_VIGIL/plot_comparison_radar.py) | Benchmark-specific spoke scales and markers on measured vertices |
| [Dispersion illustration](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/figure_Dispersion/plot_illustration.py) | Mechanism diagrams using geometry and trajectories |

Keep using this skill's `publication_style()`, `audit_figure()`, and `save_figure()`. The upstream [API document](https://github.com/ChenLiu-1996/figures4papers/blob/3c181f85e82c6f24948fcaaf3be6696102b41d8d/scientific-figure-making/references/api.md) describes suggested helper interfaces; it does not provide a shared module to import. Translate its layout ideas into the local helper rather than replacing the style configuration.

For Matplotlib mechanics, consult the official [grouped bar example](https://matplotlib.org/stable/gallery/lines_bars_and_markers/barchart.html), [figure legend example](https://matplotlib.org/stable/gallery/text_labels_and_annotations/figlegend_demo.html), [`fill_between` reference](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.fill_between.html), and [colour normalisation guide](https://matplotlib.org/stable/users/explain/colors/colormapnorms.html).
