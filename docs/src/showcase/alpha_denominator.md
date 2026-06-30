# Why the |α| denominator

A natural-looking multiplier would divide by the *signed* sum `Σ αᵢ`. For a gene with both
activators and repressors that sum can pass through zero — and the multiplier explodes or goes
negative. Dividing by `Σ |αᵢ|` instead keeps it bounded. Slide `q` and watch the naive form (red)
run away while the real deviation form (blue) holds:

```@raw html
<iframe src="../assets/widgets/alpha_denominator.html" width="100%" height="500" frameborder="0" style="border:1px solid #ddd;border-radius:6px"></iframe>
```

(`RTS3`, two activators and two repressors, sweeping its strongest repressor.)
