"""
    TranscriptionMultiplier

Yeast cell-cycle transcription-rate multiplier package.

The implementation lives in two source files that the module `include`s and
whose core public API it re-exports, so `using TranscriptionMultiplier` works:

  - `src/multiplier.jl` : `load_handoff`, `multiplier(substrate, tf_levels, edges, means; ...)`
  - `src/refit.jl`      : `load_rna_seq`, `load_tf_network`, `build_regulators`,
                          `fit_substrate`, `fit_all`, `linear_interp`,
                          `multiplier(alphas::Vector, ratios::Vector; q=...)`

Both files add methods to a single `multiplier` generic function (a Dict-based
convenience method and a low-level vector method); both are re-exported.
"""
module TranscriptionMultiplier

include("multiplier.jl")
include("refit.jl")

# ---- public API -----------------------------------------------------------
# mean-preserving multiplier (both Dict and Vector methods)
export multiplier
# load / save / refit helpers
export load_handoff, save_handoff, export_handoff_json, load_rna_seq, load_tf_network, build_regulators,
       fit_substrate, fit_all, linear_interp
# default data directory used by load_handoff
export DATA_DIR

# Useful constants from the fit pipeline (re-exported for downstream callers).
export MOLECULES_PER_CELL, RPM_TO_MOLECULES, DEFAULT_TAU, DEFAULT_W2, DEFAULT_MAX_NANS

end # module TranscriptionMultiplier
