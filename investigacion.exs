# Integrantes: Jerson David Ballesteros, Juan David Baena, Sebastian Cortes
# Programación III - Parcial 1 - Empresa de mensajería

defmodule Investigacion do
  @moduledoc """
  Combinación de kilómetros con la empresa aliada usando `Map.merge/3`
  y mediciones de tiempo con `:timer.tc/1`.
  """

  @repeticiones 1000

  @doc "Kilómetros por día informados por la empresa aliada."
  def empresa_aliada do
    %{1 => 580.5, 2 => 430, 3 => 510, 5 => 625, 7 => 180}
  end

  @doc """
  Combina los kilómetros por día de R3 con los de la empresa aliada.
  Si un día está en los dos mapas, se suman los kilómetros.
  """
  def combinar_con_aliada(km_por_dia, aliada) do
    Map.merge(km_por_dia, aliada, fn _dia, km_propios, km_aliada -> km_propios + km_aliada end)
  end

  @doc "Resultado de `Map.merge/2`, solo para compararlo con `combinar_con_aliada/2`."
  def combinar_sin_funcion(km_por_dia, aliada) do
    Map.merge(km_por_dia, aliada)
  end

  @doc "Mide el tiempo de una función con `:timer.tc/1`. Devuelve la descripción y los microsegundos."
  def medir(descripcion, funcion) do
    {microsegundos, _resultado} = :timer.tc(funcion)
    %{descripcion: descripcion, microsegundos: microsegundos}
  end

  @doc """
  Ejecuta las mediciones del informe. Para que los tiempos se noten,
  la lista de servicios se repite #{@repeticiones} veces.
  """
  def mediciones(servicios, repartidores, zonas) do
    muchos = Enum.flat_map(1..@repeticiones, fn _ -> servicios end)
    cantidad = length(muchos)
    lista_codigos = Enum.map(repartidores, fn r -> r.codigo end)
    conjunto_codigos = MapSet.new(lista_codigos)
    {validos, _rechazados} = Validacion.separar_servicios(servicios, repartidores, zonas)
    km_dia = Reportes.km_por_dia(validos)

    [
      medir("Buscar el repartidor en una lista (Enum.member?), #{cantidad} servicios", fn ->
        Enum.count(muchos, fn s -> Enum.member?(lista_codigos, s.repartidor) end)
      end),
      medir("Buscar el repartidor en un MapSet (MapSet.member?), #{cantidad} servicios", fn ->
        Enum.count(muchos, fn s -> MapSet.member?(conjunto_codigos, s.repartidor) end)
      end),
      medir("Validar y separar #{cantidad} servicios", fn ->
        Validacion.separar_servicios(muchos, repartidores, zonas)
      end),
      medir("Liquidar a todos los repartidores (#{length(validos)} servicios válidos)", fn ->
        Liquidacion.liquidar_todos(repartidores, validos)
      end),
      medir("Combinar con la empresa aliada (Map.merge/3)", fn ->
        combinar_con_aliada(km_dia, empresa_aliada())
      end)
    ]
  end
end
