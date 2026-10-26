################################################################################
#                                                                              #
#                    FirstOrderLogic.jl - Guía de Uso                          #
#                                                                              #
#        Demostración interactiva de la librería para Lógica de                #
#                        Primer Orden en Julia                                 #
#                                                                              #
################################################################################

include("FirstOrderLogic/src/FirstOrderLogic.jl")
using .FirstOrderLogic

# ---------------------------------------------------------------------------- #
# ⚠️ Nota importante:                                                          #
# ---------------------------------------------------------------------------- #
#                                                                              #
# Si la carga te da problemas porque no tienes instalado el paquete            #
# GraphvizDotLang, sigue los siguientes pasos:                                 #
#                                                                              #
# 1. Pasa a la consola de Julia (REPL) que se te ha abierto al intentar        #
#     cargar la librería (en la terminal que pone 'julia>').                   #
#                                                                              #
# 2. Ingresa al modo 'pkg>' presionando ']' (el corchete de cierre).           #
#                                                                              #
# 3. Ejecuta: 'pkg> add GraphvizDotLang'.                                      #
#                                                                              #
# 4. Espera a que se instale por completo y sal de 'pkg>' con Ctrl+C.          #
#                                                                              #
# 5. Vuelve a cargar la librería 'FirstOrderLogic.jl' (puede ser necesario     #
#     matar la terminal y volver a cargar la librería desde cero).             #
#                                                                              #
# ---------------------------------------------------------------------------- #


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📘 INFORMACIÓN Y AYUDA
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

version()  # Muestra la versión de la librería
help()     # Sistema de ayuda interactivo (en desarrollo)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔤 CONSTRUCCIÓN DEL LENGUAJE FORMAL
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 1. VARIABLES                                                            │
# └─────────────────────────────────────────────────────────────────────────┘

# Formas de crear variables:
x = var("x")                    # Variable individual
x, y, z = vars("x", "y", "z")   # Múltiples variables
v, w = vars("v", "w")
x, = vars("x")                  # Una sola variable (nota la coma)

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 2. CONSTANTES                                                           │
# └─────────────────────────────────────────────────────────────────────────┘

# Formas de crear constantes:
a = const_("a")                                  # Constante individual
juan, maria, cero = constants("Juan", "Maria", "0")  # Múltiples constantes
a, b, c = constants("a", "b", "c")
a, = constants("a")                              # Una sola constante

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 3. SÍMBOLOS DE FUNCIÓN                                                  │
# └─────────────────────────────────────────────────────────────────────────┘

# Formas de crear funciones:
f = function_("f")                                    # Función individual
padre, suma, hijo_de = functions("padre", "+", "hijo_de")  # Múltiples
suc, f, g, h = functions("succ", "f", "g", "h")
f, = functions("f")

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 4. SÍMBOLOS DE PREDICADO                                                │
# └─────────────────────────────────────────────────────────────────────────┘

# Formas de crear predicados:
P = predicate("P")                                    # Predicado individual
humano, ama, mayor, par = predicates("Humano", "Ama", "Mayor", "Par")
P, Q, R, S, T = predicates("P", "Q", "R", "S", "T")
P, = predicates("P")

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 5. CONSTRUCCIÓN DE TÉRMINOS                                             │
# └─────────────────────────────────────────────────────────────────────────┘

padre(juan)          # Término cerrado (sin variables)
suma(x, y)           # Término con variables
humano(x)            # Fórmula atómica
mayor(juan, maria)   # Término cerrado
hijo_de(x, juan)     # Término con variables
f(x)                 # Aplicación de función
g(a)                 # Término cerrado

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⚡ CONECTIVAS LÓGICAS Y CUANTIFICADORES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ FÓRMULAS ATÓMICAS                                                       │
# └─────────────────────────────────────────────────────────────────────────┘

humano(x)           # Humano(x)
ama(x,y)            # Ama(x,y)
mayor(x,juan)       # Mayor(x,Juan)
par(x)              # Par(x)

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ CONECTIVAS LÓGICAS                                                      │
# └─────────────────────────────────────────────────────────────────────────┘

humano(x) & ama(x,y)      # Conjunción:     Humano(x) ∧ Ama(x,y)
mayor(x,y) | par(x)       # Disyunción:     Mayor(x,y) ∨ Par(x)
!humano(x)                # Negación:       ¬Humano(x)
-humano(x)                # Negación (alt): ¬Humano(x)
humano(x) > ama(x,y)      # Implicación:    Humano(x) → Ama(x,y)
humano(x) ~ mayor(x,y)    # Bicondicional:  Humano(x) ↔ Mayor(x,y)

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ CUANTIFICADORES                                                         │
# └─────────────────────────────────────────────────────────────────────────┘

# Forma 1: Constructores explícitos
Forall(x, humano(x))      # ∀x. Humano(x)
Exists(y, ama(x,y))       # ∃y. Ama(x,y)

# Forma 2: Operadores Unicode (recomendado)
# Escribe \forall + TAB para ∀
# Escribe \exists + TAB para ∃

∀(x, humano(x) > mayor(x,y))     # ∀x. (Humano(x) → Mayor(x,y))
∀(y, humano(y) > mayor(y,x))     # ∀y. (Humano(y) → Mayor(y,x))
∃(y, ama(x,y) & humano(y))       # ∃y. (Ama(x,y) ∧ Humano(y))

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📝 PARSING DE FÓRMULAS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Puedes parsear fórmulas escritas en notación matemática
# NOTA: El punto (.) tras la variable del cuantificador actúa como separador

# ⚠️ IMPORTANTE: Todos los símbolos del lenguaje deben estar declarados primero
#    (variables, constantes, funciones y predicados)

f1 = parse_formula("∀x.(P(x) → T(x))")
f2 = parse_formula("∃x (P(x) ∧ ∀y (Q(y) → R(x,y)))")
f3 = parse_formula("∀ x. P(x) ∨ ∃ y. Q(x,y)")
f4 = parse_formula("∃x.(P(x) ∧ ∀y (Q(y) → R(x,y)))")
f5 = parse_formula("∃x (P(x) ∧ (∀y Q(y)) → R(x,y))")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🌳 ÁRBOLES DE FORMACIÓN Y SUBFÓRMULAS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ EJEMPLO 1: "Todo humano ama a alguien"                                  │
# └─────────────────────────────────────────────────────────────────────────┘

ϕ₁ = ∀(x, humano(x) > ∃(y, ama(x,y)))

formation_tree(ϕ₁)
# ∀x      
# └── →
#     ├── Humano(x)
#     └── ∃y
#         └── Ama(x, y)

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ EJEMPLO 2: Silogismo clásico de Sócrates                                │
# │ "Todos los humanos son mortales, Sócrates es humano → Sócrates mortal"  │
# └─────────────────────────────────────────────────────────────────────────┘

socrates = const_("Socrates")
humano, mortal = predicates("Humano", "Mortal")
ϕ₂ = (∀(x, humano(x) > mortal(x)) & humano(socrates)) > mortal(socrates)

formation_tree(ϕ₂)
# →       
# ├── ∧
# │   ├── ∀x
# │   │   └── →
# │   │       ├── Humano(x)
# │   │       └── Mortal(x)
# │   └── Humano(Socrates)
# └── Mortal(Socrates)

subformulas(ϕ₂)
#   (Humano(x) → Mortal(x))
#   (∀x.(Humano(x) → Mortal(x)) ∧ Humano(Socrates))
#   Mortal(Socrates)
#   Humano(x)
#   ∀x.(Humano(x) → Mortal(x))
#   Humano(Socrates)
#   ((∀x.(Humano(x) → Mortal(x)) ∧ Humano(Socrates)) → Mortal(Socrates))
#   Mortal(x)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🗄️ EJEMPLOS DE BASES DE CONOCIMIENTO
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ EJEMPLO 1: Relaciones Familiares                                        │
# └─────────────────────────────────────────────────────────────────────────┘

# Predicados del dominio
padre_de, madre_de, progenitor_de = predicates("Padre", "Madre", "Progenitor")
hermano_de, abuelo_de = predicates("Hermano", "Abuelo")

# Reglas de conocimiento
regla1 = ∀(x, ∀(y, padre_de(x, y) > progenitor_de(x, y)))     # Padre → Progenitor
regla2 = ∀(x, ∀(y, madre_de(x, y) > progenitor_de(x, y)))     # Madre → Progenitor
regla3 = ∀(x, ∀(y, abuelo_de(x, y) > ∃(z, padre_de(x, z) & progenitor_de(z, y))))
regla4 = ∀(x, ∀(y, hermano_de(x, y) > ∃(z, progenitor_de(z, x) & progenitor_de(z, y))))

# Razonamiento: Juan es abuelo de Luis
Juan, Pedro, Luis = constants("Juan", "Pedro", "Luis")
razonamiento = (padre_de(Juan, Pedro) & padre_de(Pedro, Luis)) > abuelo_de(Juan, Luis)

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ EJEMPLO 2: Propiedades Numéricas (Números Naturales)                    │
# └─────────────────────────────────────────────────────────────────────────┘

# Símbolos del lenguaje
succ, plus = functions("succ", "+")
igual = predicate("=")
cero = const_("0")

# Axiomas de Peano (simplificados)
axioma1 = ∀(x, !igual(succ(x), cero))                         # ∀x. succ(x) ≠ 0
axioma2 = ∀(x, ∀(y, igual(succ(x), succ(y)) > igual(x, y)))   # Inyectividad
axioma3 = ∀(x, igual(plus(x, cero), x))                       # x + 0 = x

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ EJEMPLO 3: Teoría de Conjuntos Básica                                   │
# └─────────────────────────────────────────────────────────────────────────┘

# Símbolos del lenguaje
Pertenece, Subconjunto, Igual = predicates("∈", "⊆", "=")
Union, Interseccion = functions("∪", "∩")
A, B, C, x = vars("A", "B", "C", "x")

# Axiomas básicos de conjuntos
axioma_ext = ∀(A, ∀(B, Igual(A, B) ~ ∀(x, Pertenece(x, A) ~ Pertenece(x, B))))  # Extensionalidad
axioma_sub = ∀(A, ∀(B, Subconjunto(A, B) ~ ∀(x, Pertenece(x, A) > Pertenece(x, B))))  # Subconjunto
axioma_union = ∀(A, ∀(B, ∀(x, Pertenece(x, Union(A, B)) ~ (Pertenece(x, A) | Pertenece(x, B)))))  # Unión
axioma_inter = ∀(A, ∀(B, ∀(x, Pertenece(x, Interseccion(A, B)) ~ (Pertenece(x, A) & Pertenece(x, B)))))  # Intersección

axiomas_conjuntos = [axioma_ext, axioma_sub, axioma_union, axioma_inter]

# Teorema: A ∩ B ⊆ A
teorema = ∀(A, ∀(B, Subconjunto(Interseccion(A, B), A)))

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔄 VARIABLES LIBRES Y SUSTITUCIONES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Fórmula con variables libres y ligadas
w = var("w")
P, Q, R = predicates("P", "Q", "R")
s = function_("s")

φ_ejemplo = P(x) & ∀(y, Q(x,y) > ∃(z, R(z,w)))
t_sustituto = s(w)

# Identificar variables libres
vars_libres = free_vars(φ_ejemplo)

# ⚠️ NOTA: Solo se sustituyen las variables LIBRES (no ligadas por cuantificadores)

substitute_var(φ_ejemplo, w, juan)        # w es libre → se sustituye ✓
substitute_var(φ_ejemplo, w, t_sustituto) # w es libre → se sustituye ✓
substitute_var(φ_ejemplo, x, t_sustituto) # x es libre → se sustituye ✓
substitute_var(φ_ejemplo, y, t_sustituto) # y está ligada → NO se sustituye ✗
substitute_var(φ_ejemplo, z, t_sustituto) # z está ligada → NO se sustituye ✗

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🏗️ L-ESTRUCTURAS (MODELOS)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Una L-estructura está formada por:
#   
#  🔹 Universo: Conjunto no vacío de elementos de cualquier tipo
#  🔹 Interpretación de Predicados: Diccionario que asocia cada predicado
#      con el conjunto de tuplas (de su aridad) que lo satisfacen
#  🔹 Interpretación de Funciones: Diccionario que asocia cada función
#      con un diccionario que mapea tuplas → imagen
#  🔹 Interpretación de Constantes: Diccionario que asocia cada constante
#      con el elemento del universo que representa

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ EJEMPLO 1: L-Estructura básica                                          │
# │                                                                         │
# │ Lenguaje: L = {P (aridad 1), Q (aridad 2), f (aridad 1)}                │
# │ Universo: |M| = {0, 1, 2, 3}                                            │
# │ Interpretación:                                                         │
# │   • P = {0, 1}                                                          │
# │   • Q = {(0,1), (1,1), (2,1)}                                           │
# │   • f(0)=1, f(1)=1, f(2)=0, f(3)=2                                      │
# └─────────────────────────────────────────────────────────────────────────┘

# Definir el lenguaje L
P, Q = predicates("P", "Q")
f = function_("f")

# Construir la L-estructura M
universo = Set([0, 1, 2, 3])

predicados = Dict(
    "P" => Set([(0,), (1,)]),
    "Q" => Set([(0, 1), (1, 1), (2, 1)])
)

funciones = Dict(
    "f" => Dict((0,) => 1, (1,) => 1, (2,) => 0, (3,) => 2)
)

constantes = Dict()

M = LStructure(universo, predicados, funciones, constantes)

show_LS(M)

# Verificar si M es modelo de fórmulas
# Base de conocimiento Σ:
#   ∀x (P(x) → ∃y Q(y,x))
#   ∀x Q(f(x),x)
#   ∀x (Q(f(x),x) → Q(x,x))
#   ∀x∀y (Q(x,y) → P(x))
#   ∀x∃y (Q(x,y) ∨ Q(y,x))

is_model_of(M, ∀(x, P(x) > ∃(y, Q(y,x))))
is_model_of(M, ∃(x, Q(f(x), x)))
is_model_of(M, ∀(x, Q(f(x), x) > Q(x,x)))
is_model_of(M, ∀(x, ∀(y, Q(x,y) > P(x))))
is_model_of(M, ∀(x, ∃(y, Q(x,y) | Q(y,x))))

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ EJEMPLO 2: Verificación de fórmulas en L-Estructura                     │
# │                                                                         │
# │ Lenguaje: L = {A (aridad 1), F (aridad 1), P (aridad 2), c}             │
# │ Universo: |M| = {0, 1, 2, 3}                                            │
# │ Interpretación:                                                         │
# │   • A = {0, 1, 2}                                                       │
# │   • F = {0, 1, 3}                                                       │
# │   • P = {(0,3), (1,0), (1,2), (2,3)}                                    │
# │   • c = 0                                                               │
# │                                                                         │
# │ Objetivo: Decidir qué fórmulas son válidas en M                         │
# └─────────────────────────────────────────────────────────────────────────┘

x,y = vars("x", "y")
A,F,P = predicates("A", "F", "P")
c, = constants("c")

universe3 = Set([0, 1, 2, 3])

predicates3 = Dict(
    "A" => Set([(0,), (1,), (2,)]),
    "F" => Set([(0,), (1,), (3,)]),
    "P" => Set([(0,3), (1,0), (1,2), (2,3)])
)

functions3 = Dict()

constants3 = Dict("c" => 0)

M3 = LStructure(universe3, predicates3, functions3, constants3)

show_LS(M3)

# Base de conocimiento U:
is_model_of(M3, A(c) > ∃(y, A(y) & P(y,c)))      # A(c) → ∃y (A(y) ∧ P(y,c))
is_model_of(M3, ∀(x, F(x) > -∃(y, A(y) & P(x,y))))  # ∀x (F(x) → ¬∃y (A(y) ∧ P(x,y)))
is_model_of(M3, F(c))                              # F(c)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🌳 TABLEROS SEMÁNTICOS (Semantic Tableaux)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Construcción y Visualización de Tableros                                │
# └─────────────────────────────────────────────────────────────────────────┘

x,y,z = vars("x", "y", "z")
P, Q, R = predicates("P", "Q", "R")
a, b = constants("a","b")

# Construir tablero para conjunto de fórmulas
t = TS_FOL([∃(x, Q(x)), ∀(x, Q(x) > R(x)), ∀(x, !R(x))])

# Imprimir en modo texto
print_TS_FOL(t)

# 🎨 Visualización gráfica con to_dot(tablero):
#   🔵 Azul:  Conjunto de fórmulas inicial
#   ⚪ Blanco: Nodos interiores
#   🟢 Verde: Hojas de ramas abiertas (satisfactibles)
#   🔴 Rojo:  Hojas de ramas cerradas (insatisfactibles)

to_dot(t)  # Genera y muestra el árbol

# ------------------- Ejemplos -----------------------
Formulas = [
   [∃(y,∀(x, P(x,y))), ∀(x, -P(x,x))],
   [∀(x,∀(y,(P(x,y) > P(y,x)))),∀(x,P(x,x)),∃(x,∃(y,P(x,y)))],
   [∀(x,∃(y, P(x,y))), ∀(x, !P(x,x))],
   [P(a), -P(x) | Q(x), -Q(x) | R(x), -P(x) | -R(x)],
   [-(∀(x,∀(y,(P(x) | Q(y)))) | ∃(x,∃(y,-P(x) & -Q(y))))],
   [(∀(x,∀(y,(P(x) | Q(y)))) | ∃(x,∃(y,-P(x) & -Q(y))))]
]

for f in Formulas
    println("\nFórmulas:")
    for fi in f
        println("  • $fi")
    end
    println("\nTablero Semántico:")
    t = TS_FOL(f)
    display(to_dot(t))
    print_TS_FOL(t)
end

# ------------------- Pruebas de satisfactibilidad y validez

TS_SAT(P(a))
TS_SAT(P(a) & !P(a))
TS_SAT(∀(x, P(x)))
TS_SAT(∃(x, P(x) & Q(x)))
TS_SAT(∀(x, P(x) > Q(x)) & P(a) & !Q(a))

TS_VALID(∀(x, P(x) | !P(x)))
TS_VALID(∀(x, P(x)) > P(a))
TS_VALID((∀(x, P(x))) > (∃(y, P(y))))
TS_VALID((∃(x, P(x))) > (∀(y, P(y))))
TS_VALID((P(a) & (P(a) > Q(a))) > Q(a))
TS_VALID((!∀(x, P(x)) ~ ∃(x, !P(x))))
TS_VALID((∀(x, ∃(y, R(x,y)))) > (∃(y, ∀(x, R(x,y)))))  
TS_VALID((∀(x, P(x) > Q(x)) & ∀(x, Q(x) > R(x))) > ∀(x, P(x) > R(x)))

sat, valid = TS_solve(∀(x, P(x) | !P(x)))
sat, valid = TS_solve(P(a) & !P(a))
sat, valid = TS_solve(P(a))
sat, valid = TS_solve((∀(x, P(x)) & P(a) > Q(a)) > Q(a))
sat, valid = TS_solve(∀(x, P(x) > Q(x)) & ∃(x, P(x)))

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Extracción de Modelos desde Tableros                                    │
# └─────────────────────────────────────────────────────────────────────────┘

f = P(a) & Q(b) & ∀(x, P(x) > Q(x))
t = TS_FOL([f])
to_dot(t)

# Extraer UN modelo (de una rama abierta) y convertirlo a L-Estructura
t |> one_model |> to_LS |> show_LS

# Extraer TODOS los modelos del tablero
# ⚠️ NOTA: Solo extrae los modelos "legibles" del tablero finito.
#          Si la fórmula es satisfactible, puede tener infinitos modelos.
models = all_models(t)
for (i, m) in enumerate(models)
    println("\nModelo $i:")
    m |> to_LS |> show_LS
end

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔄 FORMA NORMAL PRENEX (PNF)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Forma Prenex: Todos los cuantificadores al inicio de la fórmula

f2 = (∀(x, P(x)) & ∃(y, Q(y))) > ∃(z, R(z))
formation_tree(f2)

# Calcular TODAS las formas prenex posibles (hay múltiples)
prenex_forms_sorted(f2)

# Obtener la forma prenex óptima (para Skolemización)
to_Px(f2)

# 🔹 Manejo de variables repetidas
#    Si la fórmula tiene variables repetidas, to_Px hace renombramiento automático
f2rep = (∀(x, P(x)) & ∃(y, Q(y))) > ∃(x, R(x))  # x aparece 2 veces
formation_tree(f2rep)
prenex_forms_sorted(f2rep)
to_Px(f2rep)  # Renombra automáticamente

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⚙️ FORMA NORMAL DE SKOLEM (SNF)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Elimina cuantificadores existenciales introduciendo funciones/constantes de Skolem
# Los símbolos de Skolem se generan automáticamente: sk1, sk2, sk3(x)...

x, y, w, z = vars("x", "y", "w", "z")
P, Q = predicates("P", "Q")

# Ejemplo: ∃x. ∀y. P(x,y) → Q(y)
formula = ∃(x, ∀(y, P(x, y) > Q(y)))

skolemized = to_Sk(formula)

# Verificar que no tiene cuantificadores existenciales
has_∃(skolemized)
is_Sk_form(skolemized)

# Eliminar cuantificadores universales sobrantes para obtener la matriz
matrix = remove_∀_prefix(skolemized)

# Resetear el contador de Skolem para ejemplos independientes
reset_skolem_counter!()

# 🔹 Ejemplo con cuantificadores anidados
f4 = ∀(x, ∃(y, ∀(z, ∃(w, P(x, y, z, w)))))
to_Sk(f4)

# 🔹 Uso automático de Forma Prenex (internamente)
reset_skolem_counter!()
f5 = ∃(x, P(x) & ∀(y, Q(y) > ∃(z, R(x, y, z))))
to_Px(f5)  # Primero Prenex
to_Sk(f5)  # Luego Skolem (hace Prenex internamente)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 FORMA CLAUSAL (CNF)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Conjunción de cláusulas (disyunciones de literales)

formula1 = (P(x) | Q(x)) & (!P(x) | R(x))
cnf1 = to_cnf(formula1)       # Forma CNF como fórmula
clauses1 = to_clauses(formula1)  # Conjunto de cláusulas

# ⚠️ IMPORTANTE: Para fórmulas con cuantificadores, primero Prenex + Skolem
f = f5 |> to_Px |> to_Sk

# ❌ Error sin Skolemizar:
# to_cnf(f5)     # Resultado incorrecto
# to_clauses(f5) # Error

# ✓ Correcto con Skolemización:
to_cnf(f)
to_clauses(f)

# ===============================================================
# ==================== EXTENSIÓN DE HERBRAND ====================
# ===============================================================

x, y = vars("x", "y")
P, Q, R = predicates("P", "Q", "R")
f, g = functions("f", "g")
a, b, c = constants("a", "b", "c")

# H_Un calcula el universo de Herbrand hasta un cierto nivel
formula = ∃(x, P(x)) & ∀(y, P(y) > Q(y))
hu_level0 = H_Un(formula; max_depth=0)  # nivel 0: solo constantes

formulas = [∀(x, P(x) | Q(f(x))), ∀(x, P(g(x)) | Q(f(b))), ∀(x, P(g(x)) | Q(f(x)))]
for formula in formulas
   println("\nFórmula: $formula")
   for j in 0:2
      universe = H_Un(formula; max_depth=j)
      println("   Nivel $j: {", join(universe, ", "), "}")
   end
end

# También funciona con conjuntos de fórmulas
conjunto = Set([
    ∀(x, P(x) > Q(f(x))),
    P(a),
    P(b)
])
universe = H_Un(conjunto; max_depth=2)

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Extensión de Herbrand (H_Ex)                                            │
# │   Instancia fórmulas con términos del universo                          │
# └─────────────────────────────────────────────────────────────────────────┘

herbrand = H_Ex(conjunto; max_depth=2)
show_H_ex(herbrand)

KB = Set([
    ∀(x, P(x) > Q(x, c)),
    P(a),
    P(b)
])

herbrand2 = H_Ex(KB; max_depth=2)
println("Universo: {", join(herbrand2.constants, ","), "}")
println("Predicados generados: {", join(herbrand2.interpretations, ","), "}")
println("Fórmulas instanciadas: {", join(herbrand2.ground_formulas, ", "),"}")
show_H_ex(herbrand2)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🔗 UNIFICACIÓN (Most General Unifier)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# UMG calcula el Unificador Más General (MGU) entre dos términos o predicados
# Retorna nothing si no son unificables

x, y, z, u, v, w = vars("x", "y", "z", "u", "v", "w")
f, g = functions("f", "g")
a, b = constants("a", "b")

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Unificación de Términos                                                 │
# └─────────────────────────────────────────────────────────────────────────┘

t1 = f(x,a)
t2 = f(b,y)
mgu = UMG(t1, t2)  # {x → b, y → a}

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Unificación de Predicados                                               │
# └─────────────────────────────────────────────────────────────────────────┘

Loves = predicate("Loves")
mother = function_("mother")
John = const_("John")

p1 = Loves(x, mother(x))
p2 = Loves(John, y)
mgu2 = UMG(p1, p2)  # {x → John, y → mother(John)}

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Más Ejemplos de Unificación                                             │
# └─────────────────────────────────────────────────────────────────────────┘

P, = predicates("P")
c, = constants("c")

UMG(P(x,y), P(y,f(z)))            # {x → y, y → f(z)} o similar
UMG(P(x,g(x),y), P(z,u,g(u)))      # Unifica estructura compleja
UMG(P(c,y,f(y)), P(z,z,u))        # {z → c, y → c, u → f(c)}
UMG(P(x,g(x)), P(y,y))            # nothing (occur check: x no puede ser g(x))
UMG(P(g(w),u,g(w)), P(v,v,g(w)))  # {v → g(w), u → g(w)}
UMG(P(f(a),x), P(x,a))            # nothing (x no puede ser f(a) y a simultáneamente)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ⚛️ RESOLUCIÓN EN LÓGICA DE PRIMER ORDEN
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Resolución Básica                                                       │
# └─────────────────────────────────────────────────────────────────────────┘

f1 = P(a) & Q(b) & (-P(a) | Q(b)) & (P(b) | -Q(b))

# Convertir a cláusulas y resolver
cl = to_clauses(f1)
res = RES_FOL(cl)
res = RES_FOL_with_tracking(cl)  # Con tracking de pasos
to_dot(f1)  # Visualizar árbol de resolución

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Satisfactibilidad (RES_SAT)                                             │
# └─────────────────────────────────────────────────────────────────────────┘

f2 = P(a) & Q(b)
RES_SAT(f2)  # Satisfacible ✓
to_dot(f2)

f3 = P(a) & !P(a)
RES_SAT(f3)  # Insatisfacible ✗
to_dot(f3)

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Validez (RES_VALID)                                                     │
# │   Una fórmula es válida si su negación es insatisfacible                │
# └─────────────────────────────────────────────────────────────────────────┘

f4 = P(a) | !P(a)  # Ley del tercio excluso
RES_VALID(f4)  # Válida ✓
to_dot(!f4)

f5 = ((P(a) > Q(a)) & P(a)) > Q(a)  # Modus Ponens
RES_VALID(f5)  # Válida ✓
to_dot(!f5)

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Visualización de Refutaciones                                           │
# └─────────────────────────────────────────────────────────────────────────┘

proof_of_insat_graph(∀(x, P(x) > Q(x)) & P(a) & !Q(a))  # Árbol en modo texto
proof_of_insat_text(∀(x, P(x) > Q(x)) & P(a) & !Q(a))   # Texto paso a paso

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ Consecuencia Lógica (RES_LC)                                            │
# │   KB ⊨ φ si KB ∪ {¬φ} es insatisfacible                                 │
# └─────────────────────────────────────────────────────────────────────────┘

x, y = vars("x", "y")
P, Q = predicates("P", "Q")
a = const_("a")

KB = [
    ∀(x, P(x) > Q(x)),
    P(a)
]
conclusion = Q(a)
RES_LC(KB, conclusion)  # true: KB ⊨ Q(a)