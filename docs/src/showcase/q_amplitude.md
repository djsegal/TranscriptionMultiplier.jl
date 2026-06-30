# q sets the amplitude, never the mean

The weight `q_x` controls how strongly a gene's transcription swings over the cell cycle — but
the curve always pivots through `M_x = 1` at each regulator's mean, so the **cycle-average is fixed**
no matter where you put `q`. Drag it:

```@raw html
<iframe src="../assets/widgets/q_amplitude.html" width="100%" height="500" frameborder="0" style="border:1px solid #ddd;border-radius:6px"></iframe>
```

(`CWP2`, sweeping its strongest-coupling regulator; the dashed line is `M_x = 1`.)
