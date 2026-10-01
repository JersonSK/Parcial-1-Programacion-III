# Integrantes: Jerson David Ballesteros, Juan David Baena, Sebastian Cortes
# Programación III - Parcial 1 - Empresa de mensajería

defmodule Datos do
  @moduledoc """
  Datos de la semana: repartidores, zonas y servicios registrados.
  Los servicios llegan sin revisar, por eso algunos son inválidos a propósito.
  """

  @doc "Lista de repartidores de la empresa."
  def repartidores do
    [
      %{codigo: "M01", nombre: "Ana Torres", bicicleta: true},
      %{codigo: "M02", nombre: "David López", bicicleta: false},
      %{codigo: "M03", nombre: "Camila Ríos", bicicleta: true},
      %{codigo: "M04", nombre: "Julián Castaño", bicicleta: false},
      %{codigo: "M05", nombre: "Sofía Marín", bicicleta: true},
      %{codigo: "M06", nombre: "Andrés Gómez", bicicleta: false},
      %{codigo: "M07", nombre: "Valentina Ospina", bicicleta: true},
      %{codigo: "M08", nombre: "Mateo Duque", bicicleta: false},
      %{codigo: "M09", nombre: "Laura Henao", bicicleta: false},
      %{codigo: "M10", nombre: "Santiago Arango", bicicleta: true},
      %{codigo: "M11", nombre: "Daniela Patiño", bicicleta: true}
    ]
  end

  @doc "Lista de zonas de la ciudad. El área está en km²."
  def zonas do
    [
      %{id: "Z1", nombre: "Centro", area: 6.5},
      %{id: "Z2", nombre: "Norte", area: 10.2},
      %{id: "Z3", nombre: "Sur", area: 8.4},
      %{id: "Z4", nombre: "Occidente", area: 12.0}
    ]
  end

  @doc "Lista de servicios registrados durante los 6 días."
  def servicios do
    [
      # Día 1
      %{repartidor: "M01", zona: "Z1", dia: 1, kilometros: 18, retraso: 3},
      %{repartidor: "M01", zona: "Z2", dia: 1, kilometros: 25, retraso: 14},
      %{repartidor: "M01", zona: "Z3", dia: 1, kilometros: 40, retraso: -2},
      %{repartidor: "M02", zona: "Z2", dia: 1, kilometros: 30, retraso: 5},
      %{repartidor: "M02", zona: "Z4", dia: 1, kilometros: 22.5, retraso: 0},
      %{repartidor: "M03", zona: "Z1", dia: 1, kilometros: 15, retraso: -5},
      %{repartidor: "M03", zona: "Z3", dia: 1, kilometros: 28, retraso: 12},
      %{repartidor: "M04", zona: "Z4", dia: 1, kilometros: 35, retraso: 8},
      %{repartidor: "M04", zona: "Z1", dia: 1, kilometros: 20, retraso: -10},
      %{repartidor: "M05", zona: "Z2", dia: 1, kilometros: 42, retraso: 35},
      %{repartidor: "M05", zona: "Z3", dia: 1, kilometros: 18.5, retraso: 6},
      %{repartidor: "M06", zona: "Z2", dia: 1, kilometros: 25, retraso: -3},
      %{repartidor: "M06", zona: "Z1", dia: 1, kilometros: 26, retraso: 20},
      %{repartidor: "M07", zona: "Z4", dia: 1, kilometros: 33, retraso: 2},
      %{repartidor: "M07", zona: "Z2", dia: 1, kilometros: 21, retraso: 9},
      %{repartidor: "M08", zona: "Z1", dia: 1, kilometros: 19, retraso: 15},
      %{repartidor: "M08", zona: "Z4", dia: 1, kilometros: 27, retraso: -1},
      %{repartidor: "M09", zona: "Z4", dia: 1, kilometros: 24, retraso: 4},
      %{repartidor: "M09", zona: "Z3", dia: 1, kilometros: 31, retraso: 40},
      %{repartidor: "M10", zona: "Z3", dia: 1, kilometros: 12, retraso: 1},

      # Día 2
      %{repartidor: "M01", zona: "Z1", dia: 2, kilometros: 22, retraso: 6},
      %{repartidor: "M01", zona: "Z4", dia: 2, kilometros: 30, retraso: -4},
      %{repartidor: "M02", zona: "Z3", dia: 2, kilometros: 40, retraso: 10},
      %{repartidor: "M02", zona: "Z2", dia: 2, kilometros: 30, retraso: -6},
      %{repartidor: "M03", zona: "Z2", dia: 2, kilometros: 16, retraso: 25},
      %{repartidor: "M04", zona: "Z2", dia: 2, kilometros: 28, retraso: 7},
      %{repartidor: "M04", zona: "Z3", dia: 2, kilometros: 17.5, retraso: -2},
      %{repartidor: "M05", zona: "Z1", dia: 2, kilometros: 35, retraso: 0},
      %{repartidor: "M05", zona: "Z4", dia: 2, kilometros: 35, retraso: 18},
      %{repartidor: "M06", zona: "Z4", dia: 2, kilometros: 20, retraso: 45},
      %{repartidor: "M06", zona: "Z2", dia: 2, kilometros: 14, retraso: 3},
      %{repartidor: "M07", zona: "Z1", dia: 2, kilometros: 26, retraso: -8},
      %{repartidor: "M08", zona: "Z3", dia: 2, kilometros: 32, retraso: 11},
      %{repartidor: "M08", zona: "Z1", dia: 2, kilometros: 9, retraso: 2},
      %{repartidor: "M09", zona: "Z4", dia: 2, kilometros: 18, retraso: 30},
      %{repartidor: "M10", zona: "Z2", dia: 2, kilometros: 23, retraso: -15},
      %{repartidor: "M10", zona: "Z3", dia: 2, kilometros: 21, retraso: 5},

      # Día 3
      %{repartidor: "M01", zona: "Z2", dia: 3, kilometros: 27, retraso: 4},
      %{repartidor: "M01", zona: "Z3", dia: 3, kilometros: 24, retraso: -1},
      %{repartidor: "M02", zona: "Z1", dia: 3, kilometros: 38, retraso: 2},
      %{repartidor: "M02", zona: "Z4", dia: 3, kilometros: 44, retraso: 9},
      %{repartidor: "M03", zona: "Z4", dia: 3, kilometros: 29, retraso: -30},
      %{repartidor: "M03", zona: "Z1", dia: 3, kilometros: 17, retraso: 6},
      %{repartidor: "M04", zona: "Z3", dia: 3, kilometros: 36, retraso: 13},
      %{repartidor: "M04", zona: "Z2", dia: 3, kilometros: 25, retraso: 0},
      %{repartidor: "M05", zona: "Z1", dia: 3, kilometros: 20.5, retraso: 8},
      %{repartidor: "M05", zona: "Z3", dia: 3, kilometros: 31, retraso: 22},
      %{repartidor: "M06", zona: "Z2", dia: 3, kilometros: 33, retraso: -7},
      %{repartidor: "M06", zona: "Z4", dia: 3, kilometros: 19, retraso: 60},
      %{repartidor: "M07", zona: "Z3", dia: 3, kilometros: 40, retraso: 5},
      %{repartidor: "M07", zona: "Z1", dia: 3, kilometros: 15, retraso: -2},
      %{repartidor: "M08", zona: "Z4", dia: 3, kilometros: 26, retraso: 9},
      %{repartidor: "M08", zona: "Z2", dia: 3, kilometros: 22, retraso: 33},
      %{repartidor: "M09", zona: "Z1", dia: 3, kilometros: 28, retraso: -4},
      %{repartidor: "M09", zona: "Z1", dia: 3, kilometros: 13, retraso: 1},
      %{repartidor: "M10", zona: "Z4", dia: 3, kilometros: 30, retraso: 12},
      %{repartidor: "M10", zona: "Z1", dia: 3, kilometros: 10, retraso: 180},

      # Día 4
      %{repartidor: "M01", zona: "Z4", dia: 4, kilometros: 34, retraso: 7},
      %{repartidor: "M01", zona: "Z1", dia: 4, kilometros: 19, retraso: -3},
      %{repartidor: "M02", zona: "Z2", dia: 4, kilometros: 25, retraso: 16},
      %{repartidor: "M03", zona: "Z3", dia: 4, kilometros: 30, retraso: 3},
      %{repartidor: "M03", zona: "Z2", dia: 4, kilometros: 26, retraso: -9},
      %{repartidor: "M04", zona: "Z1", dia: 4, kilometros: 45, retraso: 2},
      %{repartidor: "M04", zona: "Z4", dia: 4, kilometros: 40, retraso: -5},
      %{repartidor: "M05", zona: "Z4", dia: 4, kilometros: 22, retraso: 28},
      %{repartidor: "M06", zona: "Z1", dia: 4, kilometros: 18, retraso: 1},
      %{repartidor: "M06", zona: "Z1", dia: 4, kilometros: 24.5, retraso: 9},
      %{repartidor: "M07", zona: "Z2", dia: 4, kilometros: 37, retraso: -12},
      %{repartidor: "M08", zona: "Z2", dia: 4, kilometros: 15, retraso: 50},
      %{repartidor: "M08", zona: "Z3", dia: 4, kilometros: 20, retraso: 4},
      %{repartidor: "M09", zona: "Z3", dia: 4, kilometros: 27, retraso: 6},
      %{repartidor: "M10", zona: "Z1", dia: 4, kilometros: 16, retraso: -6},
      %{repartidor: "M10", zona: "Z2", dia: 4, kilometros: 29, retraso: 10},

      # Día 5
      %{repartidor: "M01", zona: "Z3", dia: 5, kilometros: 26, retraso: 2},
      %{repartidor: "M01", zona: "Z2", dia: 5, kilometros: 30, retraso: -5},
      %{repartidor: "M02", zona: "Z4", dia: 5, kilometros: 31, retraso: 12},
      %{repartidor: "M02", zona: "Z1", dia: 5, kilometros: 24, retraso: -1},
      %{repartidor: "M03", zona: "Z1", dia: 5, kilometros: 33, retraso: 4},
      %{repartidor: "M03", zona: "Z4", dia: 5, kilometros: 21, retraso: 35},
      %{repartidor: "M04", zona: "Z2", dia: 5, kilometros: 29, retraso: -2},
      %{repartidor: "M04", zona: "Z3", dia: 5, kilometros: 23, retraso: 8},
      %{repartidor: "M05", zona: "Z3", dia: 5, kilometros: 38, retraso: 0},
      %{repartidor: "M05", zona: "Z2", dia: 5, kilometros: 19, retraso: 15},
      %{repartidor: "M06", zona: "Z4", dia: 5, kilometros: 27, retraso: 5},
      %{repartidor: "M06", zona: "Z1", dia: 5, kilometros: 22, retraso: -20},
      %{repartidor: "M07", zona: "Z1", dia: 5, kilometros: 30, retraso: 3},
      %{repartidor: "M07", zona: "Z3", dia: 5, kilometros: 25.5, retraso: 11},
      %{repartidor: "M08", zona: "Z2", dia: 5, kilometros: 35, retraso: -4},
      %{repartidor: "M08", zona: "Z4", dia: 5, kilometros: 20, retraso: 7},
      %{repartidor: "M09", zona: "Z4", dia: 5, kilometros: 33, retraso: 9},
      %{repartidor: "M09", zona: "Z1", dia: 5, kilometros: 17, retraso: -3},
      %{repartidor: "M10", zona: "Z2", dia: 5, kilometros: 24, retraso: 2},

      # Día 6
      %{repartidor: "M01", zona: "Z1", dia: 6, kilometros: 20, retraso: 1},
      %{repartidor: "M01", zona: "Z2", dia: 6, kilometros: 18, retraso: -2},
      %{repartidor: "M02", zona: "Z3", dia: 6, kilometros: 28, retraso: 7},
      %{repartidor: "M03", zona: "Z2", dia: 6, kilometros: 36, retraso: 14},
      %{repartidor: "M03", zona: "Z3", dia: 6, kilometros: 12, retraso: 0},
      %{repartidor: "M04", zona: "Z4", dia: 6, kilometros: 25, retraso: 3},
      %{repartidor: "M05", zona: "Z1", dia: 6, kilometros: 27, retraso: -7},
      %{repartidor: "M05", zona: "Z4", dia: 6, kilometros: 30, retraso: 4},
      %{repartidor: "M06", zona: "Z2", dia: 6, kilometros: 22, retraso: 9},
      %{repartidor: "M07", zona: "Z4", dia: 6, kilometros: 28, retraso: -1},
      %{repartidor: "M07", zona: "Z3", dia: 6, kilometros: 29, retraso: 6},
      %{repartidor: "M08", zona: "Z1", dia: 6, kilometros: 23, retraso: 19},
      %{repartidor: "M09", zona: "Z3", dia: 6, kilometros: 24, retraso: 2},
      %{repartidor: "M09", zona: "Z4", dia: 6, kilometros: 26, retraso: -11},
      %{repartidor: "M10", zona: "Z4", dia: 6, kilometros: 19, retraso: 8},

      # Registros con errores
      %{repartidor: "M99", zona: "Z1", dia: 2, kilometros: 15, retraso: 5},
      %{repartidor: "M12", zona: "Z2", dia: 3, kilometros: 20, retraso: 0},
      %{repartidor: "M20", zona: "Z9", dia: 8, kilometros: 60, retraso: 300},
      %{repartidor: "M03", zona: "Z5", dia: 2, kilometros: 18, retraso: 4},
      %{repartidor: "M11", zona: "Z7", dia: 4, kilometros: 25, retraso: 3},
      %{repartidor: "M02", zona: "Z1", dia: 0, kilometros: 20, retraso: 5},
      %{repartidor: "M04", zona: "Z3", dia: 7, kilometros: 15, retraso: 2},
      %{repartidor: "M11", zona: "Z2", dia: 3.0, kilometros: 10, retraso: 1},
      %{repartidor: "M05", zona: "Z2", dia: 3, kilometros: 0, retraso: 4},
      %{repartidor: "M08", zona: "Z4", dia: 5, kilometros: 46.5, retraso: 10},
      %{repartidor: "M09", zona: "Z1", dia: 6, kilometros: -5, retraso: 0},
      %{repartidor: "M07", zona: "Z1", dia: 1, kilometros: 20, retraso: 181},
      %{repartidor: "M10", zona: "Z3", dia: 4, kilometros: 15, retraso: -31},
      %{repartidor: "M01", zona: "Z2", dia: 5, kilometros: 10, retraso: nil}
    ]
  end
end
