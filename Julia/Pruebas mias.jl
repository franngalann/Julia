include("PropositionalLogic/src/PropositionalLogic.jl")
using .PropositionalLogic


p, q, r = vars(:p, :q, :r)

f0 = ((-p | q) & (q > r))
f1 = (-(-(-p | p) | p) | q)


formation_tree(f0)
subformulas(f0)

f2 = p > (q & r)

f3 = ((-p & q) > (q | r) > p)