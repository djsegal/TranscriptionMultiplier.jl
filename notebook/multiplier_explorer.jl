### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #= mock-bind for running outside Pluto =#
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ f4f1f6b2-8fed-4d37-9c2a-928d41d30854
md"""
# The transcription multiplier, interactively

For a gene $x$, the cell-cycle multiplier rescales its transcription rate **without changing the average**:

$$M_x(t) = 1 + q_x\,\frac{\sum_i \alpha_i\left(\mathrm{TF}_i(t)/\overline{\mathrm{TF}_i} - 1\right)}{\sum_i |\alpha_i|}.$$

Pick a gene, set the cell-cycle weight $q_x$, and sweep its strongest regulator's level to watch $M_x$ respond. The curve always passes through $M_x = 1$ at the mean — that is the guarantee.
"""

# ╔═╡ 117c5012-6079-412f-8889-674fbd293079
using TranscriptionMultiplier, PlutoUI, Plots

# ╔═╡ 7b08fb86-bdb5-450b-bfde-96394a04308f
begin
	edges, means = load_handoff()
	genelist = sort([g for g in keys(edges) if length(edges[g]) >= 2])
	length(genelist)
end

# ╔═╡ 67c60849-92d3-402f-906e-b8358b6c6d39
md"""
Gene: $(@bind gene Select(genelist; default = "CWP2"))     cell-cycle weight $q_x$: $(@bind q Slider(0:0.05:1; default = 1.0, show_value = true))
"""

# ╔═╡ 1f4b83fa-d0c6-496d-a28f-d226b1df7acc
begin
	regs   = edges[gene]
	topreg = regs[argmax([abs(a) for (_, a) in regs])][1]
	md"**$(gene)** has **$(length(regs))** fitted regulators; the sweep below moves its strongest-coupling one, **$(topreg)**, while the rest stay at their means."
end

# ╔═╡ 117ba3fe-e3bc-4728-ac10-4e1147278709
let
	folds = 0.25:0.05:4.0
	levels(f) = Dict(r => (r == topreg ? means[r] * f : means[r]) for (r, _) in regs)
	Ms = [multiplier(gene, levels(f), edges, means; q = q) for f in folds]
	plot(folds, Ms; lw = 3, legend = false,
	     xlabel = "$(topreg) level  (× its cell-cycle mean)", ylabel = "M_x",
	     title  = "$(gene):  M_x vs $(topreg)   (q = $(q))")
	hline!([1.0]; ls = :dash, c = :gray)
	vline!([1.0]; ls = :dash, c = :gray)
end

# ╔═╡ 91230d03-0479-47da-89b5-ad1bb3036d35
md"""
The curve crosses **$M_x = 1$ exactly at the mean** (dashed lines) for *every* gene, *every* $q_x$, and any mix of activators and repressors: $\langle M_x\rangle_t = 1$, so the gene's long-run average rate is unchanged. Only the *shape* of the cell-cycle modulation changes.
"""

# ╔═╡ Cell order:
# ╟─f4f1f6b2-8fed-4d37-9c2a-928d41d30854
# ╠═117c5012-6079-412f-8889-674fbd293079
# ╠═7b08fb86-bdb5-450b-bfde-96394a04308f
# ╟─67c60849-92d3-402f-906e-b8358b6c6d39
# ╟─1f4b83fa-d0c6-496d-a28f-d226b1df7acc
# ╠═117ba3fe-e3bc-4728-ac10-4e1147278709
# ╟─91230d03-0479-47da-89b5-ad1bb3036d35
