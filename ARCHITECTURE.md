# Architecture

How the package is laid out and why. The design goal is a small, dependency-light
deliverable that a downstream whole-cell model can drop in: the multiplier itself
needs only `CSV` and `DataFrames`; the fit pipeline adds `JuMP` and `HiGHS`.

## File map

| File | Role |
|---|---|
| `src/multiplier.jl` | The deliverable. `load_handoff` / `save_handoff` (CSV round-trip), the dependency-free `export_handoff_json`, and the mean-preserving `multiplier(substrate, tf_levels, edges, means; q, clamp)`. No solver dependency. |
| `src/refit.jl` | The fit pipeline: `load_rna_seq`, `load_tf_network`, `build_regulators`, `fit_substrate`, `fit_all` (one L1 linear program per substrate via JuMP/HiGHS), `linear_interp`, and the low-level `multiplier(alphas, ratios; q)`. |
| `joint_fit.jl`, `joint_score.jl` | Multi-dataset (joint) refit and the gold-standard AUROC + paired-DeLong scoring used for the headline result. |
| `regen_derived.jl`, `regen_tf_means.jl` | Regenerate the derived CSVs (`tf_means.csv`, normalization tables) from the committed inputs, with a `HEAD:`-ref guard so a regenerated file must match what is committed. |
| `src/TranscriptionMultiplier.jl` | The module: `include`s `src/multiplier.jl` and `src/refit.jl` and re-exports the public API. `DATA_DIR` resolves to the package-root `data/` via `dirname(@__DIR__)`. |
| `runtests.jl` | Three-layer tests: L1 fit reproduces the committed handoff exactly; the multiplier's mean-preservation/boundedness invariants; the joint headline AUROC + DeLong (skips when `data/external/` is absent); SW2 serialization round-trip; SW3 thread-safety. |
| `data/` | The committed handoff (fitted network, TF means, q_x scores) plus small derived tables. The large third-party datasets are fetched, not committed (see `fetch_datasets.jl`). |
| `python_adapter/` | A thin Python read-side adapter; the canonical implementation stays Julia. |

## Layout

The implementation lives in `src/` as two files the module `include`s:
`src/multiplier.jl` (the deliverable) and `src/refit.jl` (the fit pipeline).
The root-level driver scripts (`joint_fit.jl`, `regen_*.jl`, `bin/`, `bench/`)
`include` them from `src/` and still run standalone; `data/` resolves from the
package root either way. This conventional `src/` layout is what lets the
ExplicitImports and JET quality gates analyse the package statically.

## Data flow

`src/refit.jl` fits per-substrate L1 couplings → the handoff CSVs in `data/` →
`src/multiplier.jl` loads them and turns a current TF-level vector into a
mean-preserving, bounded per-gene rate scaling. The downstream model multiplies
its baseline rate constant `k_x` by `M_x(t)`.
