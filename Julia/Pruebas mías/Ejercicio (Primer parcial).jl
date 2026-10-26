# ==============================================================================
# Examen de LITI - Parte de Julia
# Curso 2025-2026
# Fecha: 7 de noviembre de 2025
# ==============================================================================

# 1: Rellena los siguientes datos:

#------------------------------------------------------------------------------
#
# Nombre y apellidos: Francisco José Galán Ruiz
# 
# DNI: 24525870G 
#
#------------------------------------------------------------------------------

#===============================================================================
2: Enunciado del ejercicio propuesto:

Haciendo uso de la librería de Lógica Proposicional desarrollada para el curso 
en Julia, formaliza los siguientes hechos y reglas:

Σ = "o el testigo no dice la verdad o Juan estaba en la casa antes de cometerse
el crimen. Si Juan estaba en la casa antes de cometerse el crimen, vio al 
criminal. Si vio al criminal, sabe que no pudo ser el mayordomo".

A continuación:
1. Pasa todas las fórmulas de Σ a FNC.
2. Calcula una forma clausal de Σ.
3. Comprueba si podemos deducir que "si el testigo dice la verdad, Juan vio al 
criminal y sabe que no pudo ser el mayordomo" a partir de Σ aplicando el método 
que quieras.

===============================================================================#

# ==============================================================================
# 3: Solución:

# Añade aquí las instrucciones necesarias para resolver el ejercicio.
include("PropositionalLogic/src/PropositionalLogic.jl")
using .PropositionalLogic

version()

#Definición de variables: 
V = Var_PL("el testigo dice la verdad")
J = Var_PL("Juan estaba en la casa antes de cometerse el crimen")
C = Var_PL("Juan vió al criminal")
M = Var_PL("no fue el mayordomo")

#Definición de fórmulas: 
f1 = V > J #ya que es equilavente a: -V | J 
f2 = J > C
f3 = C > M 

#1: 
f1 |> to_CNF
f2 |> to_CNF
f3 |> to_CNF


#comprobamos la equivalencia de las FNC con las fórmulas anterioremente definidas: 
EQUIV(f1, to_CNF(f1))
EQUIV(f2, to_CNF(f2))
EQUIV(f3, to_CNF(f3))

#2: 
Σ = [f1, f2, f3]

print("Forma clausal de Σ: ")
for f in Σ
    print(to_CF(f))
end

#3: 
conclusion = (V > (C & M))

#comprobación de la consecuencia lógica por definición: 
print("¿Σ ∪ {V, ¬C} insatisfacible? => ", UNSAT(⋀(vcat(Σ, [V, -C]))))
print("¿Σ ∪ {V, ¬M} insatisfacible? => ", UNSAT(⋀(vcat(Σ, [V, -M]))))