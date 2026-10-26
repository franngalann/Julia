# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
# ▓                  📄 EJERCICIOS DE LÓGICA DE PRIMER ORDEN                  ▓
# ▓                                                                           ▓
# ▓              Demostraciones usando Tableros, Formas Normales y            ▓
# ▓                           Resolución                                      ▓
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

include("FirstOrderLogic/src/FirstOrderLogic.jl")
using .FirstOrderLogic

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🗄 DEFINICIONES INICIALES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Variables universales
x, y, z = vars(:x, :y, :z)

# Predicados
P, Q, R, S = predicates(:P, :Q, :R, :S)

# Constantes
a, b, c, d = constants(:a, :b, :c, :d)

# Funciones
f = function_("f")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔄 EJ. 1: VARIABLES LIBRES Y LIGADAS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Determina las variables libres y ligadas de las siguientes fórmulas:

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Fórmula 1: ∀x∃y [p(x,y) → p(x,z) ∨ ∃z(p(y,z) ∧ p(x,y))]                 │
# └─────────────────────────────────────────────────────────────────────────┘

f1 = ∀(x, ∃(y, P(x,y) > P(x,z) | ∃(z, P(y,z) & P(x,y))))
free_vars(f1)  # Variables libres: {z}

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Fórmula 2: ∃x∃z [p(x,y) → p(x,z) ∧ ∃x(p(y,z) ∧ p(x,y))]                 │
# └─────────────────────────────────────────────────────────────────────────┘

f2 = ∃(x, ∃(z, P(x,y) > P(x,z) & ∃(x, P(y,z) & P(x,y))))
free_vars(f2)  # Variables libres: {y}

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Fórmula 3: ∀x∃z [p(x,y) → p(x,z) → ∃y(p(y,z) ∧ p(x,y))]                 │
# └─────────────────────────────────────────────────────────────────────────┘

f3 = ∀(x, ∃(z, P(x,y) > (P(x,z) > ∃(y, P(y,z) & P(x,y)))))
free_vars(f3)  # Variables libres: {y}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🌳 EJ. 2: TABLEROS SEMÁNTICOS - CONJUNTO 1
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Decide: ¿Es consistente el conjunto {∃x Q(x), ∀x (Q(x) → R(x)), ∀x ¬R(x)}?

x, = vars("x")
Q, R = predicates("Q", "R")
formulas = [∃(x, Q(x)), ∀(x, Q(x) > R(x)), ∀(x, !R(x))]

println("\n📋 Conjunto a analizar:")
for (i, f) in enumerate(formulas)
    println("  $i. $f")
end

tableau = TS_FOL(formulas)
print_TS_FOL(tableau)
to_dot(tableau)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🌳 EJ. 3: TABLEROS SEMÁNTICOS - CONJUNTO 2
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Decide: ¿Es consistente {∃y∀x P(x,y), ∀x ¬P(x,x)}?
# Si es satisfactible, proporciona un modelo.

x, y = vars("x", "y")
P = predicate("P")
formulas = [∃(y, ∀(x, P(x,y))), ∀(x, !P(x,x))]

println("\n📋 Conjunto a analizar:")
for (i, f) in enumerate(formulas)
    println("  $i. $f")
end

tableau2 = TS_FOL(formulas)
print_TS_FOL(tableau2)
to_dot(tableau2)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🌳 EJ. 4: TABLEROS SEMÁNTICOS - CONJUNTO 3
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Decide: ¿Es consistente {∀x∀y (P(x,y) → P(y,x)), ∀x P(x,x), ∃x∃y P(x,y)}?
# Si es satisfactible, proporciona un modelo.

x, y = vars("x", "y")
P = predicate("P")
formulas = [∀(x, ∀(y, P(x,y) > P(y,x))), ∀(x, P(x,x)), ∃(x, ∃(y, P(x,y)))]

println("\n📋 Conjunto a analizar:")
for (i, f) in enumerate(formulas)
    println("  $i. $f")
end

tableau3 = TS_FOL(formulas)
print_TS_FOL(tableau3)
to_dot(tableau3)

# Extraer modelo si existe
M = tableau3 |> one_model |> to_LS
M |> show_LS
is_model_of(M, formulas)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🌳 EJ. 5: TABLEROS SEMÁNTICOS - CONJUNTO 4
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Decide: ¿Es consistente {∀x∃y P(x,y), ∀x ¬P(x,x)}?
# Si es satisfactible, proporciona un modelo.

x, y = vars("x", "y")
P = predicate("P")
formulas = [∀(x, ∃(y, P(x,y))), ∀(x, !P(x,x))]

println("\n📋 Conjunto a analizar:")
for (i, f) in enumerate(formulas)
    println("  $i. $f")
end

tableau4 = TS_FOL(formulas)
print_TS_FOL(tableau4)
to_dot(tableau4)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🌳 EJ. 6: TABLEROS SEMÁNTICOS - CON CLÁUSULAS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Decide: ¿Es satisfactible {P(c), ¬P(x) ∨ Q(x), ¬Q(x) ∨ R(x), ¬P(x) ∨ ¬R(x)}?

x, = vars("x")
P, Q, R = predicates("P", "Q", "R")
c, = constants("c")
formulas = [P(c), !P(x) | Q(x), !Q(x) | R(x), !P(x) | !R(x)]

println("\n📋 Conjunto a analizar (en forma de cláusulas):")
for (i, f) in enumerate(formulas)
    println("  $i. $f")
end

tableau5 = TS_FOL(formulas)
print_TS_FOL(tableau5)
to_dot(tableau5)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⊨ EJ. 7: VALIDEZ DE FÓRMULAS CON TABLEROS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Decide cuáles de las siguientes fórmulas son lógicamente válidas y cuáles
# insatisfactibles con tableros semánticos (en cada caso, P y Q de aridad
# adecuada):

# 1. ∀x∀y (P(x) ∨ Q(y)) ∨ ∃x∃y (¬P(x) ∧ ¬Q(y))
# 2. ¬∃x∃y P(x,y) ∨ ∃xP(x,x)
# 3. ∃x∃y P(x,y) ∨ ¬∃xP(x,x)
# 4. ∀x∀y (P(x,y) ∨ ¬P(y,x))
# 5. ∀x P(x,x) → ∃x∀y (P(x,y) → P(y,x))
# 6. ∀x P(x,x) → ∀x∃y (P(x,y) → P(y,x))
# 7. ∃x∀y (P(x,y) ↔ ¬P(y,y))
# 8. ∃x∀y (P(x,y) ↔ ¬∃z (P(y,z) ∧ P(z,y)))

x, y, z = vars("x", "y", "z")
P, Q = predicates("P", "Q")
formulas_list = [
    ∀(x, ∀(y, P(x) | Q(y))) | ∃(x, ∃(y, !P(x) & !Q(y))),
    !∃(x, ∃(y, P(x,y))) | ∃(x, P(x,x)),
    ∃(x, ∃(y, P(x,y))) | !∃(x, P(x,x)),
    ∀(x, ∀(y, P(x,y) | !P(y,x))),
    ∀(x, P(x,x)) > ∃(x, ∀(y, P(x,y) > P(y,x))),
    ∀(x, P(x,x)) > ∀(x, ∃(y, P(x,y) > P(y,x))),
    ∃(x, ∀(y, P(x,y) ~ !P(y,y))),
    ∃(x, ∀(y, P(x,y) ~ !∃(z, P(y,z) & P(z,y))))
]
for (i, f) in enumerate(formulas_list)
    println("\nFórmula $(i): ")
    tableau = TS_FOL([!f], max_depth=15)
    print_TS_FOL(tableau)
    display(to_dot(tableau))
end

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🌳 EJ. 8: CONSISTENCIA DE CONJUNTOS DE FÓRMULAS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Decide cuáles de los siguientes conjuntos de fórmulas son consistentes:

# 1. {∃xQ(x), ∀x (Q(x) → R(x)), ∀x ¬R(x)}
# 2. {∃y∀x P(x,y), ∀x ¬P(x,x)}
# 3. {∀x∀y (P(x,y) → P(y,x)), ∀x ¬P(x,x), ∃x∃y P(x,y)}
# 4. {∀x∃y P(x,y), ∀x ¬P(x,x)}

x, y = vars("x", "y")
Q, R, P = predicates("Q", "R", "P")
consistency_formulas_list = [
    [∃(x, Q(x)), ∀(x, Q(x) > R(x)), ∀(x, !R(x))],
    [∃(y, ∀(x, P(x,y))), ∀(x, !P(x,x))],
    [∀(x, ∀(y, P(x,y) > P(y,x))), ∀(x, !P(x,x)), ∃(x, ∃(y, P(x,y)))],
    [∀(x, ∃(y, P(x,y))), ∀(x, !P(x,x))]
]
for (i, formulas) in enumerate(consistency_formulas_list)
    println("\nConjunto de fórmulas $(i): ")
    tableau = TS_FOL(formulas, max_depth=20)
    print_TS_FOL(tableau)
    display(to_dot(tableau))
end

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⊨ EJ. 9: VALIDEZ DE CONSECUENCIA LÓGICA
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Decide mediante tableros si son correctas las siguientes afirmaciones:
# (donde 'a' es símbolo de constante)

# 1. {∀x (P(x) → Q(x))} ⊨ ∀x P(x) → ∀x Q(x)
# 2. {∀x P(x) → ∀x Q(x)} ⊨ ∀x (P(x) → Q(x))
# 3. {¬∀x (P(x) ∧ Q(x))} ⊨ ∃x ¬P(x) ∧ ∃x ¬Q(x)
# 4. {∀x (P(x) ∨ Q(f(x)))} ⊨ ∀x (P(x) ∨ Q(x))
# 5. ⊨ ∃x P(x) → P(a)
# 6. {∀x (P(x) → Q(x)), ∀y (Q(a) ∨ R(y) → S(a))} ⊨ ∀x (P(x) → S(a))
# 7. {∀x (P(x) → Q(x) → R(x))} ⊨ ∀x (Q(x) → R(x))

x, y = vars("x", "y")
P, Q, R, S = predicates("P", "Q", "R", "S")
a, = constants("a")
f = function_("f")
entailment_formulas_list = [
    ([∀(x, P(x) > Q(x))], ∀(x, P(x)) > ∀(x, Q(x))),
    ([∀(x, P(x)) > ∀(x, Q(x))], ∀(x, P(x) > Q(x))),
    ([-∀(x, P(x) & Q(x))], ∃(x, -P(x)) & ∃(x, -Q(x))),
    ([∀(x, P(x) | Q(f(x)))], ∀(x, P(x) | Q(x))),
    ([], ∃(x, P(x)) > P(a)),
    ([∀(x, P(x) > Q(x)), ∀(y, (Q(a) | R(y)) > S(a))], ∀(x, P(x) > S(a))),
    ([∀(x, P(x) > (Q(x) > R(x)))], ∀(x, Q(x) > R(x)))
]
for (i, (assumptions, conclusion)) in enumerate(entailment_formulas_list)
    println("\nAfirmación $(i): ")
    tableau = TS_FOL([!conclusion; assumptions...], max_depth=10)
    print_TS_FOL(tableau)
    display(to_dot(tableau))
end

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔄 EJ. 10: EQUIVALENCIAS LÓGICAS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Prueba mediante tableros semánticos las siguientes equivalencias:

# 1. ∀x (P(x) ∧ Q(x)) ≡ ∀x P(x) ∧ ∀x Q(x)
# 2. ∃x (P(x) ∨ Q(x)) ≡ ∃x P(x) ∨ ∃x Q(x)
# 3. ∀x (P(x) ∨ Q(x)) ≢ ∀x P(x) ∨ ∀x Q(x)
# 4. ∃x (P(x) ∧ Q(x)) ≢ ∃x P(x) ∧ ∃x Q(x)

x, = vars("x")
P, Q = predicates("P", "Q")
equivalence_formulas_list = [
    ∀(x, P(x) & Q(x)) ~ (∀(x, P(x)) & ∀(x, Q(x))),
    ∃(x, P(x) | Q(x)) ~ (∃(x, P(x)) | ∃(x, Q(x))),
    ∀(x, P(x) | Q(x)) ~ (∀(x, P(x)) | ∀(x, Q(x))),
    ∃(x, P(x) & Q(x)) ~ (∃(x, P(x)) & ∃(x, Q(x)))
]
for (i, f) in enumerate(equivalence_formulas_list)
    println("\nFórmula $(i): ")
    tableau = TS_FOL([!f], max_depth=20)
    print_TS_FOL(tableau)
    display(to_dot(tableau))
end

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🌳 EJ. 11: CONSISTENCIA CON CADENA DE IMPLICACIONES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Decide si es consistente: 
#      {∃x P(x), ∀x (¬P(x) ∨ Q(x)), ∀x (¬Q(x) ∨ R(x)), ∀x (¬P(x) ∨ ¬R(x))}

x, = vars("x")
P, Q, R = predicates("P", "Q", "R")
formulas = [∃(x, P(x)), ∀(x, !P(x) | Q(x)), ∀(x, !Q(x) | R(x)), ∀(x, !P(x) | !R(x))]
tableau = TS_FOL(formulas, max_depth=20)
print_TS_FOL(tableau)
to_dot(tableau)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔄 EJ. 12: CÓLCULO DE FORMAS PRENEX - EJEMPLO 1
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Calcula una forma prenex de: ∀x ∃y (x + z = y) → ∃z ∀x (x ⋅ y = 0 + z)

x, y, z = vars("x", "y", "z")
suma = function_("+")
producto = function_("⋅")
igualdad = predicate("=")
cero = const_("0")
f = ∀(x, ∃(y, P(x, y))) > ∃(z, ∀(x, P(x,z)))
formation_tree(f)
prenex_forms_sorted(f)
to_Px(f)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔄 EJ. 13: CÓLCULO DE FORMAS PRENEX - EJEMPLO 2
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Calcula una forma prenex de: ∃x P(x,a) → (∀z P(x,z) → ∀x P(x,a))

x, z = vars("x", "z")
P = predicate("P")
a = const_("a")
f = ∃(x, P(x,a)) > (∀(z, P(x,z)) > ∀(x, P(x,a)))
formation_tree(f)
prenex_forms(f)
prenex_forms_sorted(f)
to_Px(f)

#--------------------
# Calcula una Forma Prenex de las siguientes fórmulas:

# 1. ∃x (∀y ∃z p(x,y,z) ∧ ∃z ∀y ¬p(x,y,z))
# 2. ∀x (∃y q(x,y) ∨ ∀y ∃z p(x,y,z))
# 3. ∀x ¬∃y p(x,y) → ∃x q(x,x)
# 4. ∀x [P(x) → P(x)]
# 5. (¬∀x P(x)) → ∃x ¬P(x)
# 6. ¬∀x [P(x) → [∀y [P(y) → P(f(x,y))] ∧ ¬∀y [Q(x,y) → P(y)]]]
# 7. ∀x ∃y (P(x,y) → Q(y,x)] ∧ (Q(x,y) → S(x,y))) → ∃x ∀y (P(x,y) → S(x,y))
# 8. ∀x ∃v ∀u [Q(u,x) → (∃y P(u,y) → ∃y (Q(y,v) ∧ P(u,y)))]

x, y, z, u, v = vars("x", "y", "z", "u", "v")
p, q, P, Q, S = predicates("p", "q", "P", "Q", "S")
f = function_("f")
formulas_prenex = [
    ∃(x, (∀(y, ∃(z, p(x,y,z))) & ∃(z, ∀(y, !p(x,y,z))))),
    ∀(x, (∃(y, q(x,y)) | ∀(y, ∃(z, p(x,y,z))))),
    ∀(x, !∃(y, p(x,y))) > ∃(x, q(x,x)),
    ∀(x, P(x) > P(x)),
    (!∀(x, P(x))) > ∃(x, !P(x)),
    !∀(x, P(x) > (∀(y, P(y) > P(f(x,y))) & !∀(y, Q(x,y) > P(y)))),
    (∀(x, ∃(y, (P(x,y) > Q(y,x)) & (Q(x,y) > S(x,y))))) > ∃(x, ∀(y, P(x,y) > S(x,y))),
    ∀(x, ∃(v, ∀(u, Q(u,x) > (∃(y, P(u,y)) > ∃(y, Q(y,v) & P(u,y))))))
]
for (i, f) in enumerate(formulas_prenex)
    println("\nFórmula $(i): $(f)")
    prenex_f = to_Px(f)
    println(prenex_f)
end

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⚙️ EJ. 15: FORMAS NORMALES - FND Y FNC
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Para cada fórmula, encuentra forma prenex con matriz en FND y FNC:

# 1. ∀x ∃y (x + y = 0) ∧ ∃u ∀x (x + u = x ∧ u + u = 0) ∧ ∀x (¬(x = u) → x + x = x)
# 2. ∀x (¬(x = 0) → ∀y (x + y = 0 → ¬(x = y)))
# 3. ∀x (x + y = y → ∀y ∀x (x + y = x))

x, y, u = vars("x", "y", "u")
suma = function_("+")
igualdad = predicate("=")
cero = const_("0")
formulas_fnd_fnc = [
    ∀(x, ∃(y, P(f(x,y), a))) & ∃(u, ∀(x, (P(f(x,u), x) & P(f(u,u), a)))) & ∀(x, (!P(x,u) > P(f(x,x), x))),
    ∀(x, (!P(x,a) > ∀(y, (P(f(x,y), a) > !P(x,y))))),
    ∀(x, (P(f(x,y), y) > ∀(y, ∀(x, P(f(x,y), x)))))
]
for (i, f) in enumerate(formulas_fnd_fnc)
    println("\nFórmula $(i): $(f)")
    prenex_f = to_Px(f)
    fnc = to_cnf(prenex_f)
    println("FNC: $(fnc)")
end

#--------------------
# Calcular la forma de Skolem de:
#    F = ∀x ∃y ∃z (P(y,x) ∧ P(z,y))

x, y, z = vars("x", "y", "z")
P = predicate("P")
F = ∀(x, ∃(y, ∃(z, P(y,x) & P(z,y))))
to_Sk(F)
f2 = ∀(y, ∃(x, ∃(z, (P(x,y) & Q(z)))))
to_Sk(f2)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⚙️ EJ. 17: FORMA DE SKOLEM - EJEMPLO 2
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Calcular la forma de Skolem de: ∃x ∀y ∃z ∀t ∃s ((x + b = y) → (t ⋅ s = 0 + z))

x, y, z, t, s = vars("x", "y", "z", "t", "s")
b, cero = constants("b", "0")
suma, producto, f, g = functions("+", "⋅", "f", "g")
igualdad = predicate("=")
F = ∃(x, ∀(y, ∃(z, ∀(t, ∃(s, (P(f(x,b), y) > p(g(t,s), f(a,z))))))))
to_Sk(F)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 18: FORMAS CLAUSALES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Obtener formas clausales de las siguientes fórmulas:
# (Convierte a Prenex → Skolem → CNF → Cláusulas)

# 1. ∀x (P(x) → P(x))
# 2. ¬∀x P(x) → ∃x ¬P(x)
# 3. ¬∀x (P(x) → (∀y (P(y) → P(f(x, y))) ∧ ¬∀y (Q(x,y) → P(y))))
# 4. ∀x ∃y ((P(x,y) → Q(y,x)) ∧ (Q(x,y) → S(x,y))) → ∃x ∀y (P(x,y) → S(x,y))

x, y = vars("x", "y")
P, Q, S = predicates("P", "Q", "S")
f = function_("f")
formulas_clausal = [
    ∀(x, P(x) > P(x)),
    !∀(x, P(x)) > ∃(x, !P(x)),
    !∀(x, P(x) > (∀(y, P(y) > P(f(x,y))) & !∀(y, Q(x,y) > P(y)))),
    (∀(x, ∃(y, (P(x,y) > Q(y,x)) & (Q(x,y) > S(x,y))))) > ∃(x, ∀(y, P(x,y) > S(x,y)))
]
for (i, f) in enumerate(formulas_clausal)
    println("\nFórmula $(i): $(f)")
    skolem_f = to_Sk(f)
    cnf = to_cnf(skolem_f)
    clauses = to_clauses(cnf)
    println("Forma en FNC: $(cnf)")
    println("Forma clausal: { $(join(clauses, ", ")) }")
end


# -------------- Comprobación de razonamientos

# ------- Ejemplo Simple en Forma Clausal

# Ejemplo simple: {P(a)}, {¬P(x) ∨ Q(x)} ⊧ Q(a)
# Convertir a forma de cláusulas y resolver

# Premisas en forma de cláusulas
clausula1 = P(a)
clausula2 = !P(x) | Q(x)
conclusion = Q(a)

argumento = clausula1 & clausula2 & -conclusion

# Convertir a cláusulas
clauses_step = to_clauses(argumento)

# Aplicar resolución
resultado_res = RES_FOL(clauses_step)
resultado_res.result
println("¿Se encontró cláusula vacía? $(resultado_res.empty_clause)")
println("Iteraciones: $(resultado_res.iterations)")

to_dot(argumento)  # Genera código DOT

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ EJ. 20: Falacia - Afirmación del Consecuente                            │
# └─────────────────────────────────────────────────────────────────────────┘

# Premisas: P → Q, Q
# Conclusión (INCORRECTA): P
# ⚠️ NOTA: Este argumento es inválido

premisa_invalid1 = P(a) > Q(a)
premisa_invalid2 = Q(a)
conclusion_invalid = P(a)

resultado_invalid = verify_argument_detailed([premisa_invalid1, premisa_invalid2], conclusion_invalid)
println("¿El argumento es válido? $(resultado_invalid.valid)")
println("¿Las premisas implican la conclusión? $(resultado_invalid.entails)")

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ EJ. 21: Silogismo Clásico de Sócrates                                   │
# └─────────────────────────────────────────────────────────────────────────┘

# Argumento válido: "Todo hombre es mortal. Sócrates es hombre. 
#                    Luego, Sócrates es mortal."
# Método: Paso manual a forma clausal y resolución

# Definir términos y predicados
socrates = const_("Socrates")
hombre, mortal = predicates("Hombre", "Mortal")

# Definir premisas y conclusión
premisa1 = ∀(x, hombre(x) > mortal(x))  # ∀x.(Hombre(x) → Mortal(x))
premisa2 = hombre(socrates)               # Hombre(Socrates)
conclusion = mortal(socrates)             # Mortal(Socrates)

# 1. Escribimos el razonamiento como una implicación
razonamiento = (premisa1 & premisa2) > conclusion

# 2. Para que sea correcto, el razonamiento debe ser válido (tautología)
RES_VALID(razonamiento)

# Lo podemos hacer por pasos teniendo en cuenta que 
#    {A1, A2} ⊨ C  ⟺  A1 ∧ A2 ∧ ¬C es insatisfacible:
# ... podemos pasa todo a forma clausal y aplicar resolución

# 1. Skolemizar
reset_skolem_counter!()
pr1 = to_Sk(premisa1)
pr2 = to_Sk(premisa2)
neg_conclusion = to_Sk(!conclusion)

# 2. Eliminar cuantificadores universales (solo de pr1) 
pr1 = remove_∀_prefix(pr1)

# 3. Pasar a forma clausal
cl1 = to_clauses(pr1)
cl2 = to_clauses(pr2)
cl3 = to_clauses(neg_conclusion)

clauses =  cl1 ∪ cl2 ∪ cl3

# 4. Aplicar resolución
result = RES_FOL_with_tracking(clauses)
to_dot(result)
println("Resultado: $(result.final_result)")
println("Iteraciones: $(result.iterations)")
is_valid_argument = result.final_result == :unsat
println("¿El argumento es válido? $is_valid_argument")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 22: FUNCIONES DIRECTAS - ARGUMENTOS CON AMA
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Si todo el mundo ama a alguien y María es una persona, entonces María ama 
#     a alguien
# Premisas:
#   1. ∀x. (Persona(x) → ∃y. Ama(x,y))
#   2. Persona(María)
# Conclusión: ∃y. Ama(María,y)

maria = const_("Maria")
y = var("y")
persona, ama = predicates("Persona", "Ama")

premisa_amor1 = ∀(x, persona(x) > ∃(y, ama(x, y)))
premisa_amor2 = persona(maria)
conclusion_amor = ∃(y, ama(maria, y))

resultado_amor = verify_argument([premisa_amor1, premisa_amor2], conclusion_amor)
println("¿El argumento es válido? $(resultado_amor.valid)")
println("¿Las premisas implican la conclusión? $(resultado_amor.entails)")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 23: BASE DE CONOCIMIENTO - ANIMALES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Premisas:
#   1. Todos los perros son animales: ∀x. (Perro(x) → Animal(x))
#   2. Todos los animales necesitan comida: ∀x. (Animal(x) → NecesitaComida(x))
#   3. Fido es un perro: Perro(Fido)
# Conclusión: Fido necesita comida: NecesitaComida(Fido)

fido = const_("Fido")
perro, animal, necesita_comida = predicates("Perro", "Animal", "NecesitaComida")

premisa_animal1 = ∀(x, perro(x) > animal(x))
premisa_animal2 = ∀(x, animal(x) > necesita_comida(x))
premisa_animal3 = perro(fido)
conclusion_animal = necesita_comida(fido)

resultado_animal = verify_argument([premisa_animal1, premisa_animal2, premisa_animal3], conclusion_animal)
println("¿El argumento es válido? $(resultado_animal.valid)")
println("¿Las premisas implican la conclusión? $(resultado_animal.entails)")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 24: BASE DE CONOCIMIENTO - RELACIONES FAMILIARES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Reglas sobre relaciones familiares (Padre, Ama, Odia)
x, y = vars("x", "y")
juan, maria = constants("Juan", "Maria")
padre, ama, odia = predicates("Padre", "Ama", "Odia")

# Reglas universales
# ∀x,y. Padre(x,y) → Ama(x,y)
rule1 = ∀(x,∀(y, padre(x, y) > ama(x, y)))

# ∀x,y. (Ama(x,y) ∧ Odia(x,y)) → ⊥  (equivalente a ¬(Ama(x,y) ∧ Odia(x,y)))
rule2 = ∀(x,∀(y, !(ama(x, y) & odia(x, y))))

# Hechos específicos
fact1 = padre(juan, maria)  # Juan es padre de María
fact2 = odia(juan, maria)   # Juan odia a María

family_formula = rule1 & rule2 & fact1 & fact2
to_dot(family_formula)  # Genera código DOT

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📋 EJ. 25: LÓGICA PROPOSICIONAL EN LÓGICA DE PRIMER ORDEN
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Sistema lógico con cadena de implicaciones
# 🚩 NOTA: Variables proposicionales → predicados de aridad 0
llueve = pred("Llueve")
suelo_mojado = pred("SueloMojado") 
peligroso = pred("Peligroso")
juan_casa = pred("JuanEnCasa")
juan_trabajo = pred("JuanTrabajo")
juan_dinero = pred("JuanGanaDinero")

# Cadena de implicaciones
impl1 = llueve > suelo_mojado
impl2 = suelo_mojado > peligroso  
impl3 = peligroso > juan_casa
impl4 = juan_casa > !juan_trabajo
impl5 = !juan_trabajo > !juan_dinero

# Hechos contradictorios
hecho1 = llueve           # Llueve
hecho2 = juan_dinero      # Juan gana dinero

complex_formula = impl1 & impl2 & impl3 & impl4 & impl5 & hecho1 & hecho2
cls = to_clauses(complex_formula)
to_dot(complex_formula)  # Genera código DOT

result = RES_FOL(cls)


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 26: TEORÍA DE CONJUNTOS (PARADOJA DE RUSSELL)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Teoría de conjuntos simplificada:                   │
# │ - Todo elemento pertenece a algún conjunto          │
# │ - Ningún conjunto se contiene a sí mismo            │
# │ - Existe un conjunto universal que contiene         │
# │ - Conclusión: Paradoja de Russell                   │
# └─────────────────────────────────────────────────────┘

# 📝 Variables y definiciones
x, y, z = vars("x", "y", "z")
universal = const_("U")  # Conjunto universal

# ⚛️ Regla 1: Todo elemento pertenece a algún conjunto
rule1 = ∀(x, ∃(y, pred("∈", x, y)))

# ⚛️ Regla 2: Ningún conjunto se contiene a sí mismo
rule2 = ∀(x, !pred("∈", x, x))

# ⚛️ Regla 3: El conjunto universal contiene todo
rule3 = ∀(x, pred("∈", x, universal))

# 📋 Conversión a formas normales
for r in [rule1, rule2, rule3]
    println("\n📚 Regla:")
    println(r)
    r |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses |> println  
end

set_theory_formula = rule1 & rule2 & rule3
set_theory_formula2 = rule2 & rule3

to_dot(set_theory_formula)
to_dot(set_theory_formula2)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 27: RESOLUCIÓN CON PREDICADOS COMPLEJOS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Σ = {∀x (P(x,f(x)) → ¬P(x,b)),                      │
# │      ∀x (P(x,a) → P(x,b)),                          │
# │      ∀x (¬∃z P(x,z) ∨ P(x,f(x)))}                   │
# │                                                     │
# │ Decide mediante resolución:                         │
# │ 1. Σ ⊨ ¬∃x ∃z (P(x,z) ∧ P(x,a))                     │
# │ 2. Σ ⊨ P(x,z) ∧ P(x,a)                              │
# └─────────────────────────────────────────────────────┘

# 📝 Sea Σ el conjunto de fórmulas (donde a y b son símbolos de constante):
# 🔤 Definiciones
x, z = vars("x", "z")
a, b = constants("a", "b")
P = predicate("P")
f = function_("f")

# ⚛️ Fórmulas
f1 = ∀(x, P(x, f(x)) > -P(x, b))
f2 = ∀(x, P(x, a) > P(x, b))
f3 = ∀(x, !∃(z, P(x, z)) | P(x, f(x)))

reset_skolem_counter!()
cf1 =  f1 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf2 =  f2 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf3 =  f3 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

# 📌 Caso 1: Σ ⊨ ¬∃x ∃z (P(x,z) ∧ P(x,a))
c1 = !∃(x, ∃(z, P(x, z) & P(x, a)))
cc1 = (-c1) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

r1 = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cf3 ∪ cc1) 
to_dot(r1)

# 📌 Caso 2: Σ ⊨ P(x,z) ∧ P(x,a)
c2 = ∀(x, ∀(z, P(x, z) & P(x, a)))
cc2 = (-c2) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

r2 = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cf3 ∪ cc2)
to_dot(r2)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 29: DETERMINA REFUTACIONES DE CONJUNTOS DE CLÁUSULAS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Determina si existe refutación a partir de:         │
# │ 1. {p(x,x), ¬p(x,f(x)),                             │
# │     p(x,f(x)) ∨ ¬p(f(x),y),                         │
# │     ¬p(x,y) ∨ ¬p(x,z) ∨ ¬p(y,z)}                    │
# │                                                     │
# │ 2. Similar pero: ¬p(x,y) ∨ p(x,z) ∨ p(y,z)          │
# └─────────────────────────────────────────────────────┘

x, y, z = vars("x", "y", "z")
p = predicate("p")

# 📌 Conjunto 1
c1 = to_clauses(∀(x,p(x,x)))
c2 = to_clauses(∀(x, !p(x,f(x))))
c3 = to_clauses(∀(x, ∀(y, p(x,f(x)) | !p(f(x),y))))
c4 = to_clauses(∀(x, ∀(y, ∀(z, !p(x,y) | !p(x,z) | !p(y,z)))))

r1 = RES_FOL_with_tracking(c1 ∪ c2 ∪ c3 ∪ c4)
to_dot(r1)

# 📌 Conjunto 2
c1b = to_clauses(∀(x,p(x,x)))
c2b = to_clauses(∀(x, !p(x,f(x))))
c3b = to_clauses(∀(x, ∀(y, p(x,f(x)) | !p(f(x),y))))
c4b = to_clauses(∀(x, ∀(y, ∀(z, !p(x,y) | p(x,z) | p(y,z)))))

r2 = RES_FOL_with_tracking(c1b ∪ c2b ∪ c3b ∪ c4b)
to_dot(r2)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 30: RESOLUCIÓN CON SUCESORES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Sea Σ={p(x,0,x), p(x,y,z) → p(x,s(y),s(z))}         │
# │ Prueba mediante resolución:                         │
# │ 1. Σ ⊨ p(s(s(0)),s(0),s(s(s(0))))                   │
# │ 2. Σ ⊭ p(0,x,x)                                     │
# └─────────────────────────────────────────────────────┘

x, y, z = vars("x", "y", "z")
p = predicate("p")
s = function_("s")
cero = const_("0")

# ⚛️ Base y regla de recursión
f1 = ∀(x, p(x, cero, x))
f2 = ∀(x, ∀(y, ∀(z, p(x,y,z) > p(x,s(y),s(z)))))

reset_skolem_counter!()
cf1 =  f1 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf2 =  f2 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

# 📌 Caso 1: Σ ⊨ p(s(s(0)),s(0),s(s(s(0))))
c1 = p(s(s(cero)), s(cero), s(s(s(cero))))
cc1 = (-c1) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
r1 = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cc1)
to_dot(r1)

# 📌 Caso 2: Σ ⊭ p(0,x,x)
c2 = ∀(x, p(cero, x, x))
cc2 = (-c2) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
r2 = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cc2)
to_dot(r2)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 31: VALIDEZ DE FÓRMULAS COMPLEJAS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────────┐
# │ Determina por resolución la validez de:                 │
# │ 1. ∃x ((P(x) → P(a)) ∧ (P(x) → P(b)))                   │
# │ 2. ∀z (Q(z) → P(z)) → (∃x [Q(x) → P(a)) ∧ (Q(x) → P(b)) │
# │ 3. ∃x∃y ((P(f(x)) ∧ Q(f(b))) → (P(f(a)) ∧ P(y) ∧ Q(y))) │
# │ 4. ∃x∀y P(x,y) → ∀y∃x P(x,y)                            │
# │ 5. ∀x (P(x) ∧ (Q(a) ∨ Q(b))) → ∃x (P(x) ∧ Q(x))         │
# └─────────────────────────────────────────────────────────┘

x, y, z = vars("x", "y", "z")
P, Q = predicates("P", "Q")
a, b = constants("a", "b") 
f = function_("f")

# 1️⃣ ∃x ((P(x) → P(a)) ∧ (P(x) → P(b)))
f1 = ∃(x, (P(x) > P(a)) & (P(x) > P(b)))
cf1 =  (-f1) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
rf1 = RES_FOL_with_tracking(cf1)
to_dot(rf1)

# 2️⃣ ∀z (Q(z) → P(z)) → (∃x [Q(x) → P(a)) ∧ (Q(x) → P(b))
f2 = (∀(z, Q(z) > P(z))) > (∃(x, (Q(x) > P(a)) & (Q(x) > P(b))))
cf2 =  (-f2) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
rf2 = RES_FOL_with_tracking(cf2) 
to_dot(rf2)

# 3️⃣ ∃x∃y ((P(f(x)) ∧ Q(f(b))) → (P(f(a)) ∧ P(y) ∧ Q(y)))
f3 = ∃(x, ∃(y, (P(f(x)) & Q(f(b))) > (P(f(a)) & P(y) & Q(y))))
cf3 =  (-f3) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
rf3 = RES_FOL_with_tracking(cf3)
to_dot(rf3)

# 4️⃣ ∃x∀y P(x,y) → ∀y∃x P(x,y)
f4 = (∃(x, ∀(y, P(x,y)))) > (∀(y, ∃(x, P(x,y))))
cf4 =  (-f4) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
rf4 = RES_FOL_with_tracking(cf4)
to_dot(rf4)

# 5️⃣ ∀x (P(x) ∧ (Q(a) ∨ Q(b))) → ∃x (P(x) ∧ Q(x))
f5 = ∀(x, P(x) & (Q(a) | Q(b))) > ∃(x, P(x) & Q(x))
cf5 =  (-f5) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
rf5 = RES_FOL_with_tracking(cf5)
to_dot(rf5)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 32: CONSISTENCIA DE CONJUNTOS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Estudia la consistencia de:                         │
# │ {M(a,s(c),s(b)), P(a), M(x,x,s(x)),                 │
# │  ¬M(x,y,z) ∨ D(x,z),                                │
# │  ¬P(x) ∨ ¬M(y,z,u) ∨ ¬D(x,u) ∨ D(x,y),              │
# │  ¬D(a,b)}                                           │
# └─────────────────────────────────────────────────────┘

a, b, c = constants("a", "b", "c")
x, y, z, u = vars("x", "y", "z", "u")
M, P, D = predicates("M", "P", "D")
s = function_("s")

# ⚛️ Conjunto de fórmulas
Σ = [
    M(a, s(c), s(b)),
    P(a),
    ∀(x, M(x,x,s(x))),
    ∀(x, ∀(y, ∀(z, !M(x,y,z) | D(x,z)))),
    ∀(x, ∀(y, ∀(z, ∀(u, !P(x) | !M(y,z,u) | !D(x,u) | D(x,y))))),
    !D(a,b)
]

# 🔄 Conversión a cláusulas y resolución
cΣ = [f |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses for f in Σ]
r = RES_FOL_with_tracking(reduce(∪, cΣ))
to_dot(r)  

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 33: CONSECUENCIA LÓGICA Y RESOLUCIÓN
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Decide la validez de asertos sobre consecuencia:    │
# │ 1. {...} ⊨ ∃x∃y Q(x,y)                              │
# │ 2. {...} ⊨ ∃x∃y ((B(x) ∧ C(x)) ∨ (D(y) ∧ B(y)))     │
# │ 3. {...} ⊨ ∀x∀y ¬P(y,x)                             │
# │ 4. {...} ⊨ ∀x∃y P(x,y)                              │
# │ 5. {...} ⊨ ∃x∀y P(y,x,y)                            │
# └─────────────────────────────────────────────────────┘

x, y, z, u, v, w = vars("x", "y", "z", "u", "v", "w")
P, Q, R, A, B, C, D, F, G = predicates("P", "Q", "R", "A", "B", "C", "D", "F", "G")
f, g, h = functions("f", "g", "h")

# 1️⃣ {∀x (P(x) → ∃y (R(y) ∧ Q(x,y))), ∃x P(x)} ⊨ ∃x∃y Q(x,y)
Γ1 = [
    ∀(x, P(x) > ∃(y, R(y) & Q(x,y))),
    ∃(x, P(x))
]  
c1 = ∃(x, ∃(y, Q(x,y)))
cΓ1 = [f |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses for f in Γ1]
cc1 = (-c1) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
r1 = RES_FOL_with_tracking(reduce(∪, cΓ1) ∪ cc1)
to_dot(r1)

# 2️⃣ {¬A(x) ∨ F(x) ∨ G(f(x)), ...} ⊨ ∃x∃y((B(x) ∧ C(x)) ∨ (D(y) ∧ B(y)))
Γ2 = [
    ∀(x, !A(x) | F(x) | G(f(x))),
    ∀(x, !F(x) | B(x)),
    ∀(x, !F(x) | C(x)),
    ∀(x, !G(x) | B(x)),
    ∀(x, !G(x) | D(x)),
    ∀(x, A(g(x)) | F(h(x)))
]
c2 = ∃(x, ∃(y, (B(x) & C(x)) | (D(y) & B(y))))
cΓ2 = [f |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses for f in Γ2]
cc2 = (-c2) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
# r2 = RES_FOL_with_tracking(reduce(∪, cΓ2) ∪ cc2)
# to_dot(r2)

# 3️⃣ {∃x∀y ¬P(y,x), ...} ⊨ ∀x∀y ¬P(y,x)
Γ3 = [
    ∃(x, ∀(y, !P(y,x))),
    ∀(z, ∃(y, ∀(x, P(x,y) ~ (P(x,z) & !P(x,y)))))
]  
c3 = ∀(x, ∀(y, !P(y,x)))
cΓ3 = [f |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses for f in Γ3]
cc3 = (-c3) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
r3 = RES_FOL_with_tracking(reduce(∪, cΓ3) ∪ cc3)
to_dot(r3)

# 4️⃣ {∃x∀y P(x,y), ...} ⊨ ∀x∃y P(x,y)
Γ4 = [
    ∃(x, ∀(y, P(x,y))),
    ∀(x, ∀(y, P(x,y) > !P(y,x)))
]  
c4 = ∀(x, ∃(y, P(x,y)))
cΓ4 = [f |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses for f in Γ4]
cc4 = (-c4) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
r4 = RES_FOL_with_tracking(reduce(∪, cΓ4) ∪ cc4)
to_dot(r4)

# 5️⃣ {∀x∀y∀z∀u∀v∀w (P(...) ∧ P(...) ∧ P(...) → P(...)), ...} ⊨ ∃x∀y P(y,x,y)
Γ5 = [
    ∀(x, ∀(y, ∀(z, ∀(u, ∀(v, ∀(w, (P(x,y,u) & P(y,z,v) & P(x,v,w)) > P(u,z,w))))))),
    ∀(x, ∀(y, ∃(z, P(z,x,y)))),
    ∀(x, ∀(y, ∃(z, P(x,z,y))))
]
c5 = ∃(x, ∀(y, P(y,x,y)))
cΓ5 = [f |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses for f in Γ5]
cc5 = (-c5) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
# r5 = RES_FOL_with_tracking(reduce(∪, cΓ5) ∪ cc5)
# to_dot(r5)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 34: MÉDICOS Y CURANDEROS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Sabemos:                                            │
# │ • Existen pacientes a quienes les gustan todos los  │
# │   médicos                                           │
# │ • A ningún paciente le gusta ningún curandero       │
# │ • Pregunta: ¿Ningún médico es curandero?            │
# └─────────────────────────────────────────────────────┘

x, y = vars("x", "y")
P, M, C, G = predicates("P", "M", "C", "G")

# ⚛️ Fórmulas del problema
f1 = ∃(x, P(x) & ∀(y, M(y) > G(x,y)))   # 1
f2 = ∀(x, P(x) > ∀(y, C(y) > !G(x,y)))  # 2
conclusion = ∀(x, M(x) > !C(x))         # Conclusión

# 🔄 Conversión a cláusulas
cf1 =  f1 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf2 =  f2 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cc = (-conclusion) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

# ⊨ Resolución
r = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cc)
to_dot(r)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 35: AFICIONES MUSICALES Y DEPORTIVAS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Sabemos:                                            │
# │ 1. Los aficionados a la música son cultos           │
# │ 2. A algunos cultos les gusta el fútbol             │
# │ 3. Los aficionados a todo no son cultos             │
# │ 4. Los aficionados al fútbol, pero no a la música,  │
# │    no son cultos                                    │
# │ Pregunta: ¿Hay a quien le gusta la música y el      │
# │           fútbol?                                   │
# └─────────────────────────────────────────────────────┘

x, y = vars("x", "y")
AF = predicate("AF")
CU = predicate("CU")
m, f = const_("m"), const_("f")  # música y fútbol

# ⚛️ Fórmulas del problema
f1 = ∀(x, (AF(x,m) > CU(x)))               # 1
f2 = ∃(x, CU(x) & AF(x,f))                 # 2
f3 = ∀(x, (∀(y, AF(x,y)) > !CU(x)))        # 3
f4 = ∀(x, (AF(x,f) & !AF(x,m) > !CU(x)))   # 4
conclusion = ∃(x, AF(x,m) & AF(x,f))       # Conclusión
# 🔄 Conversión a cláusulas
cf1 =  f1 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf2 =  f2 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf3 =  f3 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf4 =  f4 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cc = (-conclusion) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

# ⊨ Resolución
r = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cf3 ∪ cf4 ∪ cc)
to_dot(r)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 36: ADUANEROS Y NARCOTRAFICANTES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Sabemos:                                            │
# │ 1. Los pasajeros no VIP fueron registrados por      │
# │    algún aduanero                                   │
# │ 2. Algunos pasajeros eran narcotraficantes,         │
# │    registrados solo por narcotraficantes            │
# │ 3. Ningún narcotraficante era VIP                   │
# │ Conclusión: ¿Algún aduanero es narcotraficante?     │
# └─────────────────────────────────────────────────────┘

x, y = vars("x", "y")
P, V, A, N, R = predicates("P", "V", "A", "N", "R")

# ⚛️ Fórmulas del problema
f1 = ∀(x, (P(x) & !V(x) > ∃(y, A(y) & R(x,y))))   # 1
f2 = ∃(x, (P(x) & N(x) & ∀(y, R(x,y) > N(y))))    # 2
f3 = ∀(x, (N(x) > !V(x)))                         # 3
conclusion = ∃(x, A(x) & N(x))                    # conclusión

# 🔄 Conversión a cláusulas
cf1 =  f1 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf2 =  f2 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf3 =  f3 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cc = (-conclusion) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

# ⊨ Resolución
r = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cf3 ∪ cc)
to_dot(r)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 37: SILVESTRE Y GARFIELD (GATOS)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Sabemos de dos personajes famosos:                  │
# │ 1. Silvestre y Garfield son gatos                   │
# │ 2. A todos los gatos les gusta el queso o ratones   │
# │ 3. A nadie a quien le guste queso, le gusta vino    │
# │ 4. A quienes gustan ratones, les gusta cerveza      │
# │ 5. A Garfield no le gusta lo que le gusta a         │
# │    Silvestre                                        │
# │ 6. A Silvestre le gusta vino y cerveza              │
# │ Prueba: A Garfield le gusta queso y no le gusta     │
# │         vino                                        │
# └─────────────────────────────────────────────────────┘

x, y = vars("x", "y")
SIL, GAR = constants("SIL", "GAR")
Q, R, V, C = constants("Q", "R", "V", "C")
G = predicate("G")
GU = predicate("GU")

# ⚛️ Fórmulas del problema
f1 = G(SIL) & G(GAR)                   # 1
f2 = ∀(x, G(x) > (GU(x,Q) | GU(x,R)))  # 2
f3 = ∀(x, GU(x,Q) > !GU(x,V))          # 3
f4 = ∀(x, GU(x,R) > GU(x,C))           # 4
f5 = ∀(y, GU(SIL,y) > !GU(GAR,y))      # 5
f6 = GU(SIL,V) & GU(SIL,C)             # 6
conclusion = GU(GAR,Q) & !GU(GAR,V)    # conclusión

# 🔄 Conversión a cláusulas
cf1 =  f1 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf2 =  f2 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf3 =  f3 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf4 =  f4 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf5 =  f5 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf6 =  f6 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cc = (-conclusion) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

# ⊨ Resolución
r = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cf3 ∪ cf4 ∪ cf5 ∪ cf6 ∪ cc)
to_dot(r)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 38: PERSONAS MOTORIZADAS Y ADUANEROS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Demostrar por resolución que el argumento es        │
# │ correcto:                                           │
# │ 1. Quien intente entrar sin pasaporte encontrará    │
# │    un aduanero que le impida el paso                │
# │ 2. Algunas personas motorizadas que intentan entrar │
# │    solo son frenadas por motorizados                │
# │ 3. Ninguna persona motorizada tiene pasaporte       │
# │ Conclusión: Algunos aduaneros están motorizados     │
# └─────────────────────────────────────────────────────┘

x, y = vars("x", "y")
P = predicate("P")   # x tiene pasaporte
A = predicate("A")   # x es aduanero
M = predicate("M")   # x es motorizado
E = predicate("E")   # x intenta entrar en un país
I = predicate("I")   # y le impide el paso a x

# ⚛️ Fórmulas del problema
f1 = ∀(x, (E(x) & !P(x) > ∃(y, A(y) & I(y,x))))  # 1
f2 = ∃(x, (M(x) & E(x) & ∀(y, I(y,x) > M(y))))   # 2
f3 = ∀(x, (M(x) > !P(x)))                        # 3
conclusion = ∃(x, A(x) & M(x))                   # conclusión

# 🔄 Conversión a cláusulas
cf1 =  f1 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf2 =  f2 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf3 =  f3 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cc = (-conclusion) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

# ⊨ Resolución
r = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cf3 ∪ cc)
to_dot(r)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 EJ. 39: MÁQUINAS Y REPARACIONES (TX-150 Y FÉLIX)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────┐
# │ Hechos conocidos:                                   │
# │ 1. Todos los ordenadores son máquinas               │
# │ 2. El TX-150 es un ordenador                        │
# │ 3. Félix puede arreglar o estropear cualquier       │
# │    máquina                                          │
# │ 4. Cada cosa puede ser arreglada por alguien        │
# │ 5. Las cosas desesperan a quienes no pueden         │
# │    arreglarlas                                      │
# │ 6. El TX-150 desespera a Félix                      │
# │ 7. Ninguna máquina puede ser arreglada por sí       │
# │    misma                                            │
# │ Preguntas:                                          │
# │ 1. ¿Puede arreglar Félix el TX-150?                 │
# │ 2. ¿Estropea Félix el TX-150?                       │
# └─────────────────────────────────────────────────────┘

x, y = vars("x", "y")
TX150, FELIX = constants("TX150", "FELIX")
O = predicate("O")
M = predicate("M")
A = predicate("A")
E = predicate("E")
D = predicate("D")

# ⚛️ Fórmulas del problema
f1 = ∀(x, O(x) > M(x))                      # 1
f2 = O(TX150)                               # 2
f3 = ∀(x, M(x) > (A(FELIX,x) | E(FELIX,x))) # 3
f4 = ∀(x, ∃(y, A(y,x)))                     # 4
f5 = ∀(x, ∀(y, D(x,y) > !A(y,x)))           # 5
f6 = D(TX150,FELIX)                         # 6
f7 = ∀(x, M(x) > !A(x,x))                   # 7

# 🔄 Conversión a cláusulas
cf1 =  f1 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf2 =  f2 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf3 =  f3 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf4 =  f4 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf5 =  f5 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf6 =  f6 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
cf7 =  f7 |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses

# 1️⃣ Pregunta 1: ¿Puede arreglar Félix el TX-150?  
conclusion1 = A(FELIX,TX150)
cc1 = (-conclusion1) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
r1 = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cf3 ∪ cf4 ∪ cf5 ∪ cf6 ∪ cf7 ∪ cc1)
to_dot(r1)

# 2️⃣ Pregunta 2: ¿Estropea Félix el TX-150?  
conclusion2 = E(FELIX,TX150)
cc2 = (-conclusion2) |> to_Px |> to_Sk |> remove_∀_prefix |> to_clauses
r2 = RES_FOL_with_tracking(cf1 ∪ cf2 ∪ cf3 ∪ cf4 ∪ cf5 ∪ cf6 ∪ cf7 ∪ cc2)
to_dot(r2)
