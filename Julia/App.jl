include("PropositionalLogic/src/PropositionalLogic.jl")
using .PropositionalLogic
PropositionalLogic.version()

# ================================================================
# Ejemplo: Rectángulos 
# ================================================================
#=
Un rectángulo se divide en seis rectángulos menores tal y como se indica en 
la figura adyacente.

Demostrar que, si cada uno de los rectángulos menores tiene un lado (base o 
altura) cuya medida es un número entero, entonces la medida de alguno de los 
lados (base o altura) del rectángulo mayor (el formado por la unión de todos 
los rectángulos menores, y que los contiene) es un número entero.
______________
|     |   B   |
|  A  |_______|
|     |   |   |
------| D |   |
|  C  |   |   |
|_____|___| E |
|         |   |
|   F     |   |
|_________|___|
=#

b,h = vars("b","h")
b_A,h_A = vars("b_A","h_A")
b_B,h_B = vars("b_B","h_B")
b_C,h_C = vars("b_C","h_C")
b_D,h_D = vars("b_D","h_D")
b_E,h_E = vars("b_E","h_E")
b_F,h_F = vars("b_F","h_F")

R = [b_A | h_A, 
    b_B | h_B, 
    b_C | h_C, 
    b_D | h_D, 
    b_E | h_E, 
    b_F | h_F,
    b_A ~ b_C, 

    b_A & b_D > b_F, 
    b_F & b_A > b_D,
    b_F & b_D > b_A,
    
    b_D & b_E > b_B, 
    b_B & b_D > b_E,
    b_B & b_E > b_D,
    
    b_A & b_B > b,
    b & b_A > b_B,
    b & b_B > b_A,
    
    b_F & b_E > b,
    b & b_F > b_E,
    b & b_E > b_F,

    b_A & b_D & b_E > b,
    b & b_A & b_D > b_E,
    b & b_A & b_E > b_D,
    b & b_D & b_E > b_A,

    h_D & h_F > h_E, 
    h_E & h_D > h_F,
    h_E & h_F > h_D,

    h_A & h_C & h_F > h,
    h & h_A & h_C > h_F,
    h & h_A & h_F > h_C,
    h & h_C & h_F > h_A,
    
    h_B & h_D & h_F > h,
    h & h_B & h_D > h_F,
    h & h_B & h_F > h_D,
    h & h_D & h_F > h_B,

    h_B & h_E > h,
    h & h_B > h_E,
    h & h_E > h_B]

# R ⊧ (b | h)  <=>  R ∪ {¬(b | h)} inc <=> ⋀(R ∪ {¬(b | h)}) ∉ SAT

SAT(⋀([R..., -(b | h)]))
LC_Def(R, b | h)
DPLL_LC(R, b | h)


# Nota: Además de la cantidad de variables que pueden intervenir en un problema, 
# muchas veces el problema puede ser encontrar todas las fórmulas que determinan 
# la solución. Estas fórmulas no tienen porqué ser explícitas en el enunciado 
# del problema, sino que pueden derivarse de un conocimiento a priori que se 
# tiene del problema.
# A esta información imprescindible pero no explícita se le suele llamar "marco" 
# o "contexto" del problema.

# ================================================================
# Parametrización de variables y fórmulas
# ================================================================

#=
En los siguientes problemas trabajaremos con fórmulas parametrizadas, donde el 
número de variables que intervienen puede depender de la instancia del problema 
y, por tanto, no pueden ser declaradas a mano de forma sencilla (también puede 
ocurrir que el número de variables sea muy grande y prefiramos automatizar el 
proceso). 

Para ello, usaremos bucles y estructuras de datos de Julia (normalmente, arrays 
y diccionarios en sus diversas variedades) para crear las variables y las 
fórmulas que las relacionan.

Vamos a intentar seguir patrones similares a los que se usan en la teoría para 
definir las fórmulas, de forma que el paso de la definición matemática a la 
implementación sea lo más directo posible.

Los pasos que seguiremos para cada problema serán:
   1. Definir las variables proposicionales que intervienen en el problema, 
      normalmente como una colección (vector, matriz, diccionario, etc.) de 
      variables de Julia que dependen de parámetros que las definen.
   2. Definir las fórmulas, o conjunto de fórmulas, que representan las 
      restricciones explícitas y el marco del problema, normalmente como una 
      conjunción de varias fórmulas parciales.
   3. Usar alguno de los algoritmos disponibles para resolver el problema, 
      normalmente verificando la satisfactibilidad de la conjunción de todas 
      las restricciones.
   4. Interpretar la solución obtenida (si la hay) para el problema concreto.
      En algunos casos puede ser interpretar si es o no satisfactible, y en 
      otros casos puede ser interpretar un modelo concreto que cumpla las 
      restricciones impuestas por satisfactibilidad.
   5. Visualizar la solución (opcional).
   6. Probar con varias instancias del problema.


Variables y Fórmulas Parametrizadas
-----------------------------------

* Estructura base: Vector	

   Ejemplo 1:
      p = Vector{Var_PL}(undef, N)
      for i in 1:N
         p[i] = Var_PL("p_$i")
      end

   Ejemplo 2:
      p = [Var_PL("p_$i") for i in 1:N]

   Acceso/Muestra: p[1]/ p_1

* Estructura base: Matriz

   Ejemplo 1:
      p = Matrix{Var_PL}(undef, N, M)
      for i in 1:N, j in 1:M
         p[i, j] = Var_PL("p($i,$j)")
      end

   Ejemplo 2:
      p = [Var_PL("p($i,$j)") for i in 1:N, j in 1:M]

   Acceso/Muestra: p[1,1]/ p(1,1)

* Estructura base: Diccionario

   Ejemplo 1:
      p = Dict{Tuple{A,B}, Var_PL}()
      for a in A, b in B
         p[(a,b)] = Var_PL("p($a,$b)")
      end

   Ejemplo 2:
      p = Dict((a, b) => Var_PL("p($a,$b)") for a in A, b in B)

   Acceso/Muestra: p[(a1,b1)]/p(a1,b1)

=#

# Función general para crear variables parametrizadas.
#   par_vars(base, :vector, N)            -> Vector, p_1 ... p_N
#   par_vars(base, :matriz, N1, ..., Nm)  -> Array{Var_PL,m}, p(i,j,...)
#   par_vars(base, :dict, A1, ..., An)    -> Dict de tupla => Var_PL, p(a1,...,an)
# Los límites pueden ser enteros (se interpretan como 1:N) o cualquier colección.

function par_vars(base::Union{Symbol,AbstractString}, tipo::Symbol, limites...)
    isempty(limites) && throw(ArgumentError("Faltan los límites de la parametrización"))
    nombre = string(base)
    dominio(l) = l isa Integer ? (1:l) : l
    doms = map(dominio, limites)
    if tipo == :vector
        length(doms) == 1 ||
            throw(ArgumentError("Un vector necesita exactamente un límite"))
        return [Var_PL("$(nombre)_$i") for i in doms[1]]
    elseif tipo == :matriz
        all(l -> l isa Integer, limites) ||
            throw(ArgumentError("Una matriz necesita límites enteros N1,...,Nm"))
        arr = Array{Var_PL}(undef, limites...)
        for idx in CartesianIndices(arr)
            arr[idx] = Var_PL("$(nombre)(" * join(Tuple(idx), ",") * ")")
        end
        return arr
    elseif tipo == :dict
        d = Dict{Tuple{eltype.(doms)...}, Var_PL}()
        for t in Iterators.product(doms...)
            d[t] = Var_PL("$(nombre)(" * join(t, ",") * ")")
        end
        return d
    else
        throw(ArgumentError("Tipo desconocido: $tipo (use :vector, :matriz o :dict)"))
    end
end

# Ejemplos:
#   p = par_vars(:p, :vector, 5)                      # p[3]       -> p_3
#   r = par_vars(:r, :matriz, 8, 8)                   # r[2,3]     -> r(2,3)
#   C = par_vars(:C, :dict, ["ES","FR"], 1:4)         # C[("ES",2)]-> C(ES,2)

# En los ejemplos siguientes lo usaremos de forma habitual.

# ================================================================
## Función "exactamente una"
# ================================================================

#=
Comenzamos definiendo una función que significa "exactamente uno" (∃_{=1} = ∃!) 
y que será de utilidad para los problemas siguientes. Esta función recibe un 
conjunto de variables proposicionales y devuelve la fórmula proposicional que 
se verifica cuando exactamente una, y solo una, de las variables de entrada es 
verdadera:

∃_{=1} (v_1,...,v_n) = ( ∃_{>=1} (v_1,...,v_n) )  ∧  ( ∃_{<=1} (v_1,...,v_n) )
∃_{=1} (v_1,...,v_n) = (⋁_{i=1..n} v_i) ∧ (⋀_{i=1..n-1} ⋀_{j=i+1..n} ¬(v_i ∧ v_j))

Observa que en el proceso de creación de la fórmula se usan los operadores `⋀` 
y `⋁` para crear las conjunciones y disyunciones de varias fórmulas, y que 
internamente hacemos uso de dos "operadores" intermedios: "al menos una" 
(∃_{>=1}) y "a lo sumo una" (∃_{<=1}).

Por ejemplo: 
∃_{=1} (v1,v2,v3) = (v1 ∨ v2 ∨ v3) ∧ ( ¬(v1 ∧ v2) ∧ ¬(v1 ∧ v3) ∧ ¬(v2 ∧ v3) )
=# 

function Ex1(vps::Vector{Var_PL})
    if length(vps) == 0
        error("No se puede crear restricción exactamente_una con lista vacía")
    elseif length(vps) == 1
        return vps[1]
    end
    
    # Al menos una
    al_menos_una = ⋁(vps)
    
    # A lo sumo una: para cada par, ¬(a ∧ b)
    a_lo_sumo_una = ⋀([!(vps[i] & vps[j]) for i in 1:length(vps) for j in (i+1):length(vps)])
    
    return al_menos_una & a_lo_sumo_una
end


# ================================================================
# N-reinas 
# ================================================================

#=
Vamos a suponer que tenemos una matriz de variables proposicionales r(i,j) con 
la interpretación:

                r(i,j) = 1 ⟺ hay una reina en la casilla (i,j)

Función que crea la fórmula general que contiene todas las restricciones que 
definen una solución del problema:

   * Una única reina por fila:         
                ⋀_{i=1..n} ∃_{=1}(r_{i,j})_{j=1..n}

   * Una única reina por columna:      
                ⋀_{j=1..n} ∃_{=1}(r_{i,j})_{i=1..n}

   * A lo sumo, una reina por diagonal principal: 
                ⋀_{i=1..n} ∃_{≤ 1} (D^1_{i}), 
      donde D^1_i es el conjunto de casillas de la diagonal principal i-ésima.

   * A lo sumo, una reina por diagonal secundaria: 
                ⋀_{i=1..n} ∃_{≤ 1} (D^2_{i}), 
      donde D^2_i es el conjunto de casillas de la diagonal secundaria i-ésima.
=#



# Función para el problema de las N-reinas
function formula_n_reinas(r::Matrix{Var_PL})        

    n = size(r, 1)  # tamaño del tablero (n x n)

    # Restricción 1: Exactamente una reina por fila
    Fila(i) = [r[i, j] for j in 1:n]      # variables de la fila i
    Filas = [Ex1(Fila(i)) for i in 1:n]
    
    # Restricción 2: Exactamente una reina por columna
    Columna(j) = [r[i, j] for i in 1:n]      # variables de la columna j
    Columnas = [Ex1(Columna(j)) for j in 1:n]
    
    # Restricción 3: A lo sumo una reina por diagonal principal (↘)

    Diags1 = FormulaPL[]
    for k in -(n-2):(n-2)  # Diagonales paralelas a la principal
        D = [ r[i, j] for i in 1:n, j in 1:n if i - j == k ]  # variables de la 
                                                            # diagonal principal k
        d = length(D)
        Diags1 = [Diags1; [!(D[i] & D[j]) for i in 1:d-1 for j in (i+1):d]]
    end
    
    # Restricción 4: A lo sumo una reina por diagonal secundaria (↙)

    Diags2 = FormulaPL[]
    for k in 2:(2*n)   # Diagonales paralelas a la secundaria
        D = [ r[i, j] for i in 1:n, j in 1:n if i + j == k] # variables de la 
                                                            # diagonal secundaria k
        d = length(D)
        Diags2 = [Diags2; [!(D[i] & D[j]) for i in 1:d-1 for j in (i+1):d]]
    end

    return [Filas ; Columnas ; Diags1 ; Diags2]
end

# Función para visualizar la solución de N-reinas
function visual_sol_n_reinas(solution_dict, r::Matrix{Var_PL})
    n = size(r, 1)  # tamaño del tablero (n x n)
    # Rellenado del tablero vacío
    tablero = fill("▢", n, n)
    # Colocación de reinas de solución
    for i in 1:n
        for j in 1:n
            if solution_dict[r[i,j]]
                tablero[i, j] = "♕"
            end
        end
    end
    
    # Mostrar el tablero
    for i in 1:n
        println(join(tablero[i, :], " "))
    end
    
    # Contar reinas colocadas
    queen_count = count(==("♕"), tablero)
    println("\nReinas colocadas: $queen_count/$n")
    
    return tablero
end

# Ejemplo de uso:
function test_n_reinas(n::Int)
    # Generar variables r_{ij} - reina en fila i, columna j
    r = par_vars(:r, :matriz, n, n)

    # Crear la matriz de variables directamente:
    #  r = Matrix{Var_PL}(undef, n, n)
    #  for i in 1:n, j in 1:n
    #      r[i,j] = Var_PL("r($i,$j)")
    #  end

    # Crear la fórmula 
    formula = formula_n_reinas(r);

    # Resolver
    sat, sol = DPLL(formula);
    #sol = TS_solve(formula)
    
    # Representar
    if sat == false
        println("No hay solución para $n reinas.")
    else
        println("Solución encontrada:")
        visual_sol_n_reinas(sol, r)
    end
end

# Ejemplo de uso:
test_n_reinas(10);

# ================================================================
# Sudoku
# ================================================================

#=
El problema del Sudoku se puede resolver de forma similar, pero teniendo en 
cuenta ahora que las variables proposicionales serán de la forma $S(i,j,k)$ con 
la interpretación:

            S(i,j,k) = 1 ⟺ en la casilla (i,j) está el número k

Las restricciones que tenemos que considerar son:

   * Hay exactamente un número en cada casilla:
            ⋀_{i=1..9} ⋀_{j=1..9} ∃_{=1} ({S(i,j,k)}_{k=1..9})

   * Hay exactamente una ocurrencia de cada número por cada fila:
            ⋀_{i=1..9} ⋀_{k=1..9} ∃_{=1} ({S(i,j,k)}_{j=1..9})

   * Hay exactamente una ocurrencia de cada número por cada columna:
            ⋀_{j=1..9} ⋀_{k=1..9} ∃_{=1} ({S(i,j,k)}_{i=1..9})

   * Hay exactamente una ocurrencia de cada número por cada bloque 3×3:
            ⋀_{B ∈ Bloque} ⋀_{(i,j) ∈ B} ∃_{=1} ({S(i,j,k)}_{k=1..9})

   * Además, habrá que añadir las celdas que vienen ya prefijadas/rellenas.
=#

function formula_sudoku(S::Array{Var_PL}, Rellenas::Vector{Tuple{Int, Int, Int}} = [] )    
    # Exactamente un número por celda
    celda(i,j) = Ex1([S[i, j, k] for k in 1:9])
    Celdas = [celda(i, j) for i in 1:9 for j in 1:9]
    
    # Exactamente una ocurrencia de cada número por fila
    Fila(i,k) = Ex1([S[i, j, k] for j in 1:9])
    Filas = [Fila(i, k) for i in 1:9 for k in 1:9]
    
    # Exactamente una ocurrencia de cada número por columna
    Columna(j,k) = Ex1([S[i, j, k] for i in 1:9])
    Columnas = [Columna(j, k) for j in 1:9 for k in 1:9]

    # Exactamente una ocurrencia de cada número por bloque de Sudoku
    Bloque(i, j, k) = Ex1([S[i + bi, j + bj, k] for bi in 0:2 for bj in 0:2])
    Bloques = [Bloque(i, j, k) for i in [1 4 7] for j in [1 4 7] for k in 1:9]

    # Restricciones de celdas ya rellenadas
    Rellenas = [S[i, j, k] for (i, j, k) in Rellenas]

    return [Celdas ; Filas ; Columnas ; Bloques ; Rellenas]
end

# Función para visualizar la solución de N-reinas
function visual_sol_sudoku(solution_dict, S)
    tablero = fill(0, 9, 9)
    
    # Procesar cada variable en la solución
    for i in 1:9, j in 1:9, k in 1:9
        var = S[i,j,k]
        if solution_dict[var]
            tablero[i,j] = k
        end
    end

    # Mostrar el tablero
    for i in 1:9
        println(join(tablero[i, :], " "))
    end
    
    return tablero
end

# Ejemplo de uso:
function test_sudoku()
    # Variables S(i,j,k) - número k en posición (i,j)
    S = par_vars(:S, :matriz, 9, 9, 9)

    # Crear la matriz de variables directamente:
    #  S = Array{Var_PL}(undef, 9, 9, 9)
    #  for i in 1:9, j in 1:9, k in 1:9
    #      S[i,j,k] = Var_PL("S($i,$j,$k)")
    #  end

    formula = formula_sudoku(S, [(1, 1, 1), (1, 2, 2), (1, 3, 3), (1, 4, 4), 
                              (1, 5, 5), (1, 6, 6), (1, 7, 7), (1, 8, 8), 
                              (1, 9, 9)]);
    sat, sol = DPLL(formula)
    
    if sat == false
        println("No hay solución para el Sudoku.")
    else
        println("Solución encontrada:")
        visual_sol_sudoku(sol, S)
    end
end

test_sudoku();

# ================================================================
# Coloreado de Mapas
# ================================================================

#=
Un problema similar es el de coloreado de mapas, donde se supone que tenemos un 
conjunto de países (P, una colección de cadenas, por ejemplo), indicando qué 
pares de países comparten frontera (F) y K colores (que podemos considerarlos 
como números consecutivos). Entonces las restricciones de un coloreado válido 
serían:

   * Todos los países deben estar coloreados con exactamente un único color:
                ⋀_{p ∈ P} ∃_{=1} ({C(p,c)}_{c=1..K})

   * Dos países que compartan frontera deben tener coloreados distintos:
                ⋀_{(p_1,p_2) ∈ F} ⋀_{c=1..K} ¬( C(p_1,c) ∧ C(p_2,c) )
=#

# Función para el problema del coloreado de mapas
function formula_coloreado_mapas(paises::Vector{String}, fronteras::Vector{Tuple{String, String}}, C, num_colores::Int = 4)

    # Restricción 1: Cada país debe tener exactamente un color
    pais_color(pais) = Ex1([C[(pais, color)] for color in 1:num_colores])
    Coloreado_funcional = [pais_color(pais) for pais in paises]
    
    # Restricción 2: Países que comparten frontera no pueden tener el mismo color
    Coloreado_correcto = [ !(C[(p1, c)] & C[(p2, c)]) for (p1, p2) in fronteras for c in 1:num_colores ]

    return [Coloreado_funcional ; Coloreado_correcto]
end

# Función para visualizar la solución del coloreado de mapas
function visual_sol_coloreado_mapas(solution_dict, paises::Vector{String}, C, num_colores::Int = 4)
    println("\nVisualización del Coloreado de Mapas:")
        
    # Mostrar el coloreado
    println("┌─────────────────────────────┬──────────────┐")
    println("│            País             │    Color     │")
    println("├─────────────────────────────┼──────────────┤")
    
    for pais in sort(paises), color_num in 1:num_colores
        var = C[(pais, color_num)]
        if solution_dict[var]
            println("│ $(rpad(pais, 27)) │ $(rpad(color_num, 12)) │")
        end
    end
    
    println("└─────────────────────────────┴──────────────┘")    
end

# Función para probar el coloreado de mapas
function test_coloreado_mapas(paises::Vector{String}, fronteras::Vector{Tuple{String, String}}, num_colores::Int = 4)
    println("Probando coloreado de mapas con $(length(paises)) países y $num_colores colores")
    println("Países: $(join(paises, ", "))")
    println("Fronteras: $(length(fronteras)) conexiones")
    
    # Generar variables C(pais, color) - país tiene color
    C = par_vars(:C, :dict, paises, 1:num_colores)

    # Crear la colección de variables directamente:
    #  C = Dict{Tuple{String, Int}, Var_PL}()
    #  for pais in paises, color in 1:num_colores
    #      C[(pais, color)] = Var_PL("C($pais,$color)")
    #  end

    formula = formula_coloreado_mapas(paises, fronteras, C, num_colores)
    sat, sol = DPLL(formula)
    
    if sat == false
        println("No hay solución para el coloreado con $num_colores colores.")
        return sat, sol
    else
        println("¡Solución encontrada!")
        visual_sol_coloreado_mapas(sol, paises, C, num_colores)
    end
end

# Ejemplos de uso del coloreado de mapas

# Ejemplo 1: Mapa simple de 4 países
begin
   println("=== EJEMPLO 1: Mapa Simple ===")
   paises_simple = ["España", "Francia", "Italia", "Alemania"]
   fronteras_simple = [("España", "Francia"), ("Francia", "Italia"), 
                     ("Francia", "Alemania"), ("Italia", "Alemania")]
   test_coloreado_mapas(paises_simple, fronteras_simple, 3)
end

# Ejemplo 2: Mapa más complejo (grafo completo K5 - requiere 5 colores)
begin
   println("\n=== EJEMPLO 2: Grafo Completo K5 ===")
   paises_k5 = ["A", "B", "C", "D", "E"]
   fronteras_k5 = [(paises_k5[i], paises_k5[j]) for i in 1:5 for j in (i+1):5]

   test_coloreado_mapas(paises_k5, fronteras_k5,5)
end

# Ejemplo 3: Algunos países europeos reales
begin
   println("\n=== EJEMPLO 3: Europa Occidental ===")
   paises_europa = ["España", "Francia", "Alemania", "Italia", "Suiza", "Austria", "Bélgica"]
   fronteras_europa = [
      ("España", "Francia"),
      ("Francia", "Alemania"), ("Francia", "Italia"), ("Francia", "Suiza"), ("Francia", "Bélgica"),
      ("Alemania", "Austria"), ("Alemania", "Suiza"), ("Alemania", "Bélgica"),
      ("Italia", "Suiza"), ("Italia", "Austria"),
      ("Suiza", "Austria")
   ]

   test_coloreado_mapas(paises_europa, fronteras_europa, 3)
end

# ================================================================
# Casas Coloreadas
# ================================================================

"""
    Ejercicio A1: Puzzle Lógico - Casas Coloreadas
    
DESCRIPCIÓN:
Tres casas en fila, cada una con un color, y que presentan un tipo de vivienda 
distinto. Resolver el puzzle con restricciones semánticas.

VARIABLES (diccionario):
- C[(pos, color)] = "la casa que ocupa la posición pos tiene ese color"
- H[(pos, tipo)] = "la casa que ocupa la posición pos es de ese tipo de vivienda"

RESTRICCIONES:
1. Cada casa tiene exactamente un color
2. Cada color aparece exactamente una vez
3. Restricciones espaciales (vecindad)
4. Restricciones de atributos

OBJETIVO: Determinar la configuración única de las 3 casas (posición, color y tipo)
"""

function casas_coloreadas()
    # Las posiciones (1,2,3), identifican las casas y la asignación de atributos
    pos = 1:3
    colores = ["Rojo", "Verde", "Azul"]
    tipos = ["Piso", "Casa", "Cabaña"]
    
    println("✓ 3 casas en fila (se identifican con sus posiciones 1, 2, 3)")
    println("✓ Atributos: Colores = $(join(colores, ", "))")
    println("✓              Tipos = $(join(tipos, ", "))")
    
    # 1. VARIABLES (usando diccionarios)
    C = par_vars(:C, :dict, pos, colores)
    T = par_vars(:T, :dict, pos, tipos)
    
    # Creación de variables directamente:
    #  C = Dict((c, col) => Var_PL("C($c,$col)") for c in pos, col in colores)
    #  T = Dict((c, tipo) => Var_PL("T($c,$tipo)") for c in pos, tipo in tipos)

    # 2. RESTRICCIONES
    restricciones = FormulaPL[]
    
    # R1: Cada casa tiene exactamente un color
    println("\n✓ R1: Cada casa tiene un color único")
    for c in pos
        push!(restricciones, Ex1([C[(c, col)] for col in colores]))
    end
    
    # R2: Cada color aparece exactamente una vez
    println("✓ R2: Cada color aparece exactamente una vez")
    for col in colores
        push!(restricciones, Ex1([C[(c, col)] for c in pos]))
    end
    
    # R3: Cada casa tiene exactamente un tipo
    println("✓ R3: Cada casa tiene un tipo único")
    for c in pos
        push!(restricciones, Ex1([T[(c, tipo)] for tipo in tipos]))
    end
    
    # R4: Cada tipo aparece exactamente una vez
    println("✓ R4: Cada tipo aparece exactamente una vez")
    for tipo in tipos
        push!(restricciones, Ex1([T[(c, tipo)] for c in pos]))
    end
    
    # R5-R8: Restricciones específicas del puzzle
    # La casa roja está al lado de la casa azul
    # (si la roja está en 1, la azul en 2; o roja en 2, azul en 1 ó 3; etc.)
    println("✓ R5: Rojo y Azul están en casas vecinas")
    roja_azul = FormulaPL[]
    for c1 in pos, c2 in pos
        if abs(c1 - c2) == 1  # Son vecinas
            push!(roja_azul, (C[(c1, "Rojo")] & C[(c2, "Azul")]) | (C[(c1, "Azul")] & C[(c2, "Rojo")]))
        end
    end
    push!(restricciones, ⋁(roja_azul))
    
    # El piso es de color verde
    println("✓ R6: El Piso es de color Verde")
    for c in pos
        push!(restricciones, (T[(c, "Piso")] > C[(c, "Verde")]))
    end
    
    # La cabaña es roja
    println("✓ R7: La Cabaña es Roja")
    for c in pos
        push!(restricciones, (T[(c, "Cabaña")] > C[(c, "Rojo")]))
    end
    
    # La casa está en posición 2 (del medio)
    println("✓ R8: La Casa está en el medio (posición 2)")
    push!(restricciones, T[(2, "Casa")])
    
    # 3. RESOLVER
    println("\n⏳ Resolviendo...")
    sat, solucion = DPLL(restricciones)
    
    # 4. MOSTRAR RESULTADO
    println("\n📊 Resultado:")
    if sat
        println("✓ Puzzle RESUELTO\n")
        println("Configuración de las 3 casas:")
        println("┌──────────┬─────────┬──────────┐")
        println("│  Casa    │  Color  │   Tipo   │")
        println("├──────────┼─────────┼──────────┤")
        for c in pos
            color = [col for col in colores if solucion[C[(c, col)]] == 1][1]
            tipo = [t for t in tipos if solucion[T[(c, t)]] == 1][1]
            println("│ Pos. $c   │ $(rpad(color, 7)) │ $(rpad(tipo, 8)) │")
        end
        println("└──────────┴─────────┴──────────┘")
    else
        println("✗ No hay solución para este puzzle")
    end
end

# Ejecutar
casas_coloreadas()


# ================================================================
# Acertijo de Einstein (Zebra Puzzle)
# ================================================================

#=
El famoso **acertijo de Einstein** (también conocido como **Zebra Puzzle**) nos 
dice que hay 5 casas en fila, cada una de ellas con diferentes características, 
pero no nos dicen qué característica corresponde a cada casa:

 - Nacionalidades: Británico, Sueco, Danés, Noruego, Alemán
 - Colores: Rojo, Verde, Amarillo, Azul, Blanco
 - Mascotas: Perro, Pájaro, Gato, Caballo, Pez (Pez Cebra, de ahí el nombre del 
   puzzle)
 - Bebidas: Té, Café, Leche, Cerveza, Agua
 - Cigarrillos: Pall Mall, Dunhill, Blend, Blue Master, Prince

Pero sí nos dan información acerca de posibles relaciones y restricciones 
existente:
 1.  El británico vive en la casa roja
 2.  El sueco tiene un perro
 3.  El danés bebe té
 4.  La casa verde está inmediatamente a la izquierda de la casa blanca
 5.  El dueño de la casa verde bebe café
 6.  La persona que fuma Pall Mall tiene un pájaro
 7.  El dueño de la casa amarilla fuma Dunhill
 8.  El hombre en la casa del medio bebe leche
 9.  El noruego vive en la primera casa
 10. El hombre que fuma Blend vive al lado del que tiene un gato
 11. El hombre que tiene un caballo vive al lado del que fuma Dunhill
 12. El hombre que fuma Blue Master bebe cerveza
 13. El alemán fuma Prince
 14. El noruego vive al lado de la casa azul
 15. El hombre que fuma Blend vive al lado del que bebe agua

 El objetivo es indicar claramente qué características tiene cada casa.
=#

function formula_acertijo_einstein()
    # Definir los conjuntos de características
    nacionalidades = ["Britanico", "Sueco", "Danes", "Noruego", "Aleman"]
    colores = ["Rojo", "Verde", "Amarillo", "Azul", "Blanco"]
    mascotas = ["Perro", "Pajaro", "Gato", "Caballo", "Pez"]
    bebidas = ["Te", "Cafe", "Leche", "Cerveza", "Agua"]
    cigarrillos = ["PallMall", "Dunhill", "Blend", "BlueMaster", "Prince"]
    
    # Variables: X(casa, caracteristica) - la casa tiene esa característica
    N = par_vars(:N, :dict, 1:5, nacionalidades)  # Nacionalidades
    C = par_vars(:C, :dict, 1:5, colores)
    M = par_vars(:M, :dict, 1:5, mascotas)  # Mascotas
    B = par_vars(:B, :dict, 1:5, bebidas)  # Bebidas
    F = par_vars(:F, :dict, 1:5, cigarrillos)  # Cigarrillos (Smoking)

    # Creación de variables directamente:
    #  N = Dict{Tuple{Int, String}, Var_PL}()  # Nacionalidades
    #  C = Dict{Tuple{Int, String}, Var_PL}()  # Colores
    #  M = Dict{Tuple{Int, String}, Var_PL}()  # Mascotas
    #  B = Dict{Tuple{Int, String}, Var_PL}()  # Bebidas
    #  F = Dict{Tuple{Int, String}, Var_PL}()  # Cigarrillos (Smoking)
    
    # Generar todas las variables
    #  for casa in 1:5
    #      for nac in nacionalidades
    #          N[(casa, nac)] = Var_PL("N($casa,$nac)")
    #      end
    #      for col in colores
    #          C[(casa, col)] = Var_PL("C($casa,$col)")
    #      end
    #      for mas in mascotas
    #          M[(casa, mas)] = Var_PL("M($casa,$mas)")
    #      end
    #      for beb in bebidas
    #          B[(casa, beb)] = Var_PL("B($casa,$beb)")
    #      end
    #      for cig in cigarrillos
    #          F[(casa, cig)] = Var_PL("F($casa,$cig)")
    #      end
    #  end
    
    # RESTRICCIONES BÁSICAS: 
    
    # Cada casa tiene exactamente una nacionalidad, color, mascota, bebida y 
    # cigarrillo
    Basicas = [ [Ex1([N[(casa, nac)] for nac in nacionalidades]) for casa in 1:5] ;
              [Ex1([C[(casa, col)] for col in colores]) for casa in 1:5] ; 
              [Ex1([M[(casa, mas)] for mas in mascotas]) for casa in 1:5] ;
              [Ex1([B[(casa, beb)] for beb in bebidas]) for casa in 1:5] ;
              [Ex1([F[(casa, cig)] for cig in cigarrillos]) for casa in 1:5] ]

    # Cada característica aparece en exactamente una casa
    Caracteristicas = [ [Ex1([N[(casa, nac)] for casa in 1:5]) for nac in nacionalidades] ;
                      [Ex1([C[(casa, col)] for casa in 1:5]) for col in colores] ;
                      [Ex1([M[(casa, mas)] for casa in 1:5]) for mas in mascotas] ;
                      [Ex1([B[(casa, beb)] for casa in 1:5]) for beb in bebidas] ;
                      [Ex1([F[(casa, cig)] for casa in 1:5]) for cig in cigarrillos] ]

    # RESTRICCIONES DEL ACERTIJO
    rest = Vector{Vector{FormulaPL}}(undef, 15)  # Vector para las restricciones 
                                                 # del acertijo
    
    # 1. El británico vive en la casa roja
    rest[1] = [ (N[(casa, "Britanico")] ~ C[(casa, "Rojo")]) for casa in 1:5 ]
    
    # 2. El sueco tiene un perro
    rest[2] = [ (N[(casa, "Sueco")] ~ M[(casa, "Perro")]) for casa in 1:5 ]
    
    # 3. El danés bebe té
    rest[3] = [ (N[(casa, "Danes")] ~ B[(casa, "Te")]) for casa in 1:5 ]
    
    # 4. La casa verde está inmediatamente a la izquierda de la casa blanca
    rest[4] = [[ (C[(casa, "Verde")] > C[(casa+1, "Blanco")]) for casa in 1:4 ] ;
             [!C[(1, "Blanco")]];  # La casa blanca no puede estar en la pos. 1
             [!C[(5, "Verde")]]]   # La casa verde no puede estar en la pos. 5
    
    # 5. El dueño de la casa verde bebe café
    rest[5] = [ (C[(casa, "Verde")] ~ B[(casa, "Cafe")]) for casa in 1:5 ]
    
    # 6. La persona que fuma Pall Mall tiene un pájaro
    rest[6] = [ (F[(casa, "PallMall")] ~ M[(casa, "Pajaro")]) for casa in 1:5 ]
    
    # 7. El dueño de la casa amarilla fuma Dunhill
    rest[7] = [ (C[(casa, "Amarillo")] ~ F[(casa, "Dunhill")]) for casa in 1:5 ]
    
    # 8. El hombre en la casa del medio bebe leche
    rest[8] = [B[(3, "Leche")]]  # La casa del medio (casa 3) bebe leche
    
    # 9. El noruego vive en la primera casa
    rest[9] = [N[(1, "Noruego")]]  # El noruego vive en la primera casa
    
    # 10. El hombre que fuma Blend vive al lado del que tiene un gato
    r10 = FormulaPL[]
    for casa in 1:5
        vecinos_gato = FormulaPL[]
        if casa > 1
            push!(vecinos_gato, M[(casa-1, "Gato")])
        end
        if casa < 5
            push!(vecinos_gato, M[(casa+1, "Gato")])
        end
        if length(vecinos_gato) > 0
            push!(r10, (F[(casa, "Blend")] > ⋁(vecinos_gato)))
        end
    end
    
    rest[10] = r10  # Asegurar que se cumple para todas las casas

    # 11. El hombre que tiene un caballo vive al lado del que fuma Dunhill
    r11 = FormulaPL[]
    for casa in 1:5
        vecinos_dunhill = FormulaPL[]
        if casa > 1
            push!(vecinos_dunhill, F[(casa-1, "Dunhill")])
        end
        if casa < 5
            push!(vecinos_dunhill, F[(casa+1, "Dunhill")])
        end
        if length(vecinos_dunhill) > 0
            push!(r11, (M[(casa, "Caballo")] > ⋁(vecinos_dunhill)))
        end
    end
    rest[11] = r11  # Asegurar que se cumple para todas las casas
    
    # 12. El hombre que fuma Blue Master bebe cerveza
    rest[12] = [ (F[(casa, "BlueMaster")] ~ B[(casa, "Cerveza")]) for casa in 1:5 ]

    # 13. El alemán fuma Prince
    rest[13] = [ (N[(casa, "Aleman")] ~ F[(casa, "Prince")]) for casa in 1:5 ]

    # 14. El noruego vive al lado de la casa azul
    # Como el noruego está en casa 1, la casa azul debe estar en casa 2
    rest[14] = [C[(2, "Azul")]]
    
    # 15. El hombre que fuma Blend vive al lado del que bebe agua
    r15 = FormulaPL[]
    for casa in 1:5
        vecinos_agua = FormulaPL[]
        if casa > 1
            push!(vecinos_agua, B[(casa-1, "Agua")])
        end
        if casa < 5
            push!(vecinos_agua, B[(casa+1, "Agua")])
        end
        if length(vecinos_agua) > 0
            push!(r15, (F[(casa, "Blend")] > ⋁(vecinos_agua)))
        end
    end
    rest[15] = r15  # Asegurar que se cumple para todas las casas
    
    Acertijo = reduce(vcat, [rest[i] for i in 1:15])
    #Acertijo = ⋀(restricciones_acertijo)

    return [Basicas ; Caracteristicas ; Acertijo]
end

# Función para visualizar la solución del acertijo de Einstein
function visual_sol_acertijo_einstein(solution_dict)    
    # Crear estructura para almacenar la solución
    casas = [Dict{String, String}() for _ in 1:5]
    
    # Procesar la solución
    for (var, value) in solution_dict
        if value == 1
            # Parsear variables del tipo X(casa,caracteristica)
            if occursin(r"^[NCMBF]\(\d+,\w+\)$", var.name)
                tipo = var.name[1]
                contenido = var.name[3:end-1]
                partes = split(contenido, ",")
                casa = parse(Int, partes[1])
                caracteristica = string(partes[2])
                
                categoria = Dict('N' => "Nacionalidad", 'C' => "Color", 
                               'M' => "Mascota", 'B' => "Bebida", 'F' => "Cigarrillo")[tipo]
                casas[casa][categoria] = caracteristica
            end
        end
    end
    
    # Mostrar la tabla
    println("┌──────┬──────────────┬───────────┬──────────┬──────────┬────────────┐")
    println("│ Casa │ Nacionalidad │   Color   │ Mascota  │  Bebida  │ Cigarrillo │")
    println("├──────┼──────────────┼───────────┼──────────┼──────────┼────────────┤")
    
    for casa in 1:5
        nac = get(casas[casa], "Nacionalidad", "?")
        col = get(casas[casa], "Color", "?")
        mas = get(casas[casa], "Mascota", "?")
        beb = get(casas[casa], "Bebida", "?")
        cig = get(casas[casa], "Cigarrillo", "?")
        
        println("│  $casa   │ $(rpad(nac, 12)) │ $(rpad(col, 9)) │ $(rpad(mas, 8)) │ $(rpad(beb, 8)) │ $(rpad(cig, 10)) │")
    end
    
    println("└──────┴──────────────┴───────────┴──────────┴──────────┴────────────┘")
    
    # Encontrar y destacar quién tiene el pez
    println("\n" * "="^25 * " RESPUESTA " * "="^25)
    for casa in 1:5
        if get(casas[casa], "Mascota", "") == "Pez"
            nacionalidad = get(casas[casa], "Nacionalidad", "Desconocido")
            println("         ¡El $nacionalidad tiene el PEZ! (Casa #$casa)")
            break
        end
    end
    println("="^61)
    
end

# Función principal para resolver el acertijo
function resolver_acertijo_einstein()
    println("Resolviendo el Acertijo de Einstein...")
    println("   (También conocido como 'Zebra Puzzle')")

    println("\n⏳ Generando fórmula SAT...")
    formula = formula_acertijo_einstein()
    
    println("\n⏳ Ejecutando solucionador DPLL...")
    sat, sol = DPLL(formula)
    
    if sat == false
        println("❌ No se encontró solución. ¡Esto no debería pasar!")
        return false
    else
        println("✅ ¡Solución encontrada!")
        casas = visual_sol_acertijo_einstein(sol)
        return casas
    end
end

resolver_acertijo_einstein()

# ================================================================
# Sistemas Expertos
# ================================================================

#=
Un sistema experto es un sistema de aplicaciones informáticas que utiliza la 
Inteligencia Artificial para simular el razonamiento de un experto humano en 
un área específica, resolviendo problemas complejos a través de una base de 
conocimientos y un motor de inferencia. Estos sistemas pueden analizar 
información, ofrecer diagnósticos, recomendaciones y tomar decisiones de 
nivel experto, utilizando reglas lógicas para llegar a una solución. 

Los componentes principales de los sistemas expertos son:

* Base de conocimientos: Almacena el conocimiento especializado adquirido a 
través de la experiencia de un experto humano. Se compone de datos, hechos y 
reglas sobre un área particular.

* Motor de inferencia: Contiene la lógica o las reglas que utiliza el sistema 
para procesar la información de la base de conocimientos y llegar a una 
conclusión o solución. 

Su funcionamiento suele seguir los siguientes pasos:

1. El usuario proporciona datos y síntomas o información sobre un problema. 
2. El motor de inferencia utiliza estas entradas y las reglas de la base de 
conocimientos para buscar una respuesta. 
3. El sistema proporciona una solución, diagnóstico o recomendación al usuario. 

Podemos encontrar multitud de ejemplos de aplicaciones:

- Medicina: Diagnóstico de enfermedades o análisis de síntomas. 
- Finanzas: Evaluación de riesgo para la concesión de préstamos o determinación 
   de precios de seguros. 
- Ingeniería: Diseño y configuración de soluciones complejas o control de 
   sistemas de potencia. 
- Soporte técnico: Diagnóstico de averías en sistemas. 
- Educación: Sistemas que ayudan a identificar errores y desarrollar planes de 
   enseñanza para un estudiante. 

A continuación, se presentan dos ejemplos de sistemas expertos pequeños que 
usan la librería de lógica proposicional que hemos desarrollado para el curso.

De forma independiente, puedes encontrar una ampliación del Sistema Experto de
Diagnóstico Médico.

=#


#=
Ejemplo 1: Diagnóstico de fallos en un sistema técnico
------------------------------------------------------

Contexto: Se quiere diagnosticar fallos en un sistema eléctrico industrial. 
   El técnico introduce información observada, y el sistema debe deducir 
   posibles causas.

Hechos y reglas (simplificados pero no triviales):

Variables proposicionales (Var_PL):

p: Hay corriente en el sistema
b: El breaker está activado
f: El fusible está fundido
s: El sensor muestra actividad
a: La alarma está activada
r: El relé está cerrado
l: Hay luz en el panel

Conocimiento (conjunto Γ de fórmulas):

b → p — Si el breaker está activado, hay corriente
¬f → p — Si el fusible no está fundido, hay corriente
(p ∧ r) → l — Si hay corriente y el relé está cerrado, hay luz
p → s — Si hay corriente, el sensor muestra actividad
¬p → a — Si no hay corriente, se activa la alarma
l → ¬a — Si hay luz, no hay alarma
a → ¬s — Si hay alarma, el sensor no muestra actividad

Objetivo: Dado un conjunto de observaciones (hechos actuales), deducir qué 
falla(s) son compatibles o necesarias, o si hay contradicción.

=#

# Variables
p, b, f, s, a, r, l = vars("p", "b", "f", "s", "a", "r", "l")

# Base de conocimiento (reglas del sistema)
Γ = [
    b > p,                 # breaker → corriente
    -f > p,                # no fusible quemado → corriente
    (p & r) > l,           # corriente y relé → luz
    p > s,                 # corriente → sensor activo
    -p > a,                # no corriente → alarma
    l > -a,                # luz → no alarma
    a > -s                 # alarma → no sensor activo
]

println("Base de conocimiento cargada.")

# Observaciones:
# - Hay alarma (a)
# - No hay luz (¬l)
# - El breaker está activado (b)

observaciones = [a, -l, b]

# Pregunta: ¿Se deduce que el fusible está fundido?
φ = f

# ¿Γ ∪ observaciones ⊨ f?
println("\n¿Se deduce que el fusible está fundido?")
se_deduce = DPLL_LC(vcat(Γ, observaciones), φ)
println("Resultado: ", se_deduce)

# Alternativa: ¿Cuáles son los modelos compatibles con las observaciones + base?
modelos = models(vcat(Γ, observaciones))

println("\nModelos compatibles con las observaciones:")
for m in modelos
    println(m)
end

# Introducimos ahora que el sensor muestra actividad (s)

observaciones2 = [a, -l, b, s]

println("\n¿Hay contradicción si también se observa sensor activo?")
contradiccion = UNSAT(⋀(vcat(Γ, observaciones2)))
println("¿Contradicción?: ", contradiccion)

#=
Comentarios:
* Este sistema experto no podría resolverse cómodamente a mano por el número 
   de combinaciones (7 variables → 128 posibles mundos).
* Se analiza si ciertas conclusiones (como f) son necesarias dada la evidencia.
* También se detectan observaciones inconsistentes con el conocimiento 
   (observaciones contradictorias).
=#

#=

Ejemplo 2: Diagnóstico de Enfermedades Respiratorias
----------------------------------------------------

* Contexto 

Se desea desarrollar un **sistema experto proposicional** capaz de diagnosticar 
enfermedades respiratorias comunes basándose en:
- Síntomas observados en el paciente
- Antecedentes médicos del paciente
- Reglas de inferencia derivadas del conocimiento médico

El objetivo es determinar qué enfermedad(es) es(son) compatible(s) con los 
síntomas y antecedentes observados.

* Variables Proposicionales

Enfermedades (4)

| Variable | Significado                                |
|----------|--------------------------------------------|
| asma     | El paciente tiene asma                     |
| gripe    | El paciente tiene gripe                    |
| covid    | El paciente tiene COVID-19                 |
| alergia  | El paciente tiene una alergia respiratoria |

Síntomas (5)

| Variable | Significado                                   |
|----------|-----------------------------------------------|
| tos      | El paciente presenta tos                      |
| fiebre   | El paciente presenta fiebre                   |
| mialgia  | El paciente presenta dolores musculares       |
| disnea   | El paciente presenta dificultad para respirar |
| estornudo| El paciente presenta estornudos               |

Antecedentes (2)

| Variable | Significado                            |
|----------|----------------------------------------|
| fumador  | El paciente es fumador                 |
| asma_prev| El paciente tiene antecedentes de asma |

Factores de Riesgo (1)

| Variable | Significado                                                              |
|----------|--------------------------------------------------------------------------|
| riesgo   | El paciente pertenece a población de riesgo (edad, comorbilidades, etc.) |

Respuesta a Tratamiento (2)

| Variable             | Significado                                 |
|----------------------|---------------------------------------------|
| responde_antivirales | El paciente responde a medicación antiviral |
| responde_bronco      | El paciente responde a broncodilatadores    |


* Base de Conocimiento (Reglas de Inferencia)

Las reglas definen relaciones causales entre síntomas y enfermedades:

* Reglas de Diagnóstico por Síntomas
R1: tos ∧ fiebre → gripe (Tos y fiebre son indicadores de gripe)
R2: fiebre ∧ mialgia → covid (Fiebre y dolores musculares sugieren COVID-19)
R3: tos ∧ estornudo → alergia (Tos con estornudos indica posible alergia)
R4: disnea ∧ fiebre → asma (Dificultad respiratoria con fiebre puede indicar asma)

* Reglas de Riesgo por Antecedentes
R5: fumador ∧ disnea → asma (Fumadores con disnea tienen mayor riesgo de asma)
R6: asma_prev ∧ tos → asma (Antecedentes de asma con tos indican recurrencia)

* Reglas de Población de Riesgo
R7: riesgo → covid (Pacientes de riesgo tienen mayor probabilidad de COVID-19)
R8: riesgo → asma (Pacientes de riesgo tienen mayor probabilidad de asma)

* Reglas de Tratamiento
R9: covid → responde_antivirales (Pacientes con COVID responden a antivirales)
R10: asma → responde_bronco (Pacientes con asma responden a broncodilatadores)

* Restricciones de Compatibilidad
R11: estornudo ∧ mialgia → ¬alergia (Los estornudos con mialgia NO son típicos de alergia)
R12: disnea ∧ estornudo → ¬gripe (La disnea con estornudos NO es típica de gripe)
=#

# Variables Nombradas

# Enfermedades
asma      = Var_PL("asma")
gripe     = Var_PL("gripe")
covid     = Var_PL("covid")
alergia   = Var_PL("alergia")

# Síntomas
tos       = Var_PL("tos")
fiebre    = Var_PL("fiebre")
mialgia   = Var_PL("mialgia")
disnea    = Var_PL("disnea")
estornudo = Var_PL("estornudo")

# Antecedentes
fumador   = Var_PL("fumador")
asma_prev = Var_PL("asma_prev")

# Tratamientos
responde_antivirales = Var_PL("responde_antivirales")
responde_bronco      = Var_PL("responde_bronco")

# Riesgo
riesgo = Var_PL("riesgo")

# Base de Conocimiento

Γ = [
    # Reglas de síntomas comunes
    tos & fiebre       > gripe,
    fiebre & mialgia   > covid,
    tos & estornudo    > alergia,
    disnea & fiebre    > asma,

    # Reglas de antecedentes
    fumador & disnea   > asma,
    asma_prev & tos    > asma,

    # Población de riesgo
    riesgo > covid,
    riesgo > asma,

    # Diagnóstico implica respuesta a tratamiento
    covid  > responde_antivirales,
    asma   > responde_bronco,

    # Síntomas incompatibles
    estornudo & mialgia > -alergia,
    disnea & estornudo  > -gripe
]

# Observaciones de un paciente concreto

observaciones = [
    tos,
    fiebre,
    disnea,
    fumador,
    riesgo
]

# Inferencias

# ¿Se deduce que tiene asma?
println("¿El paciente tiene asma?: ", DPLL_LC([Γ; observaciones], asma))

# ¿Se deduce que tiene covid?
println("¿El paciente tiene covid?: ", DPLL_LC([Γ; observaciones], covid))

# ¿Modelos compatibles con las observaciones?
println("\nModelos compatibles:")
print_table(models([Γ; observaciones]))
for m in models([Γ; observaciones])
    println(m)
end

# ¿Contradicción si decimos que NO responde a broncodilatadores?
println("\n¿Contradicción si ¬responde_bronco?: ",
    UNSAT(⋀(Γ) & ⋀(observaciones) & -responde_bronco))