# Integrantes: Juan David Baena, Jerson David Ballesteros, Sebastian Cortes
# Programación III - Parcial 1 - Empresa de mensajería

defmodule Reportes do
  @moduledoc """
  Cálculos de los reportes R1 a R8. Las funciones devuelven datos;
  la impresión se hace en `Impresion`.
  """

  @meta_diaria 500
  @dias 1..6
  @minimo_servicios_puntualidad 3
  @motivos [
    :repartidor_desconocido,
    :zona_desconocida,
    :dia_invalido,
    :kilometros_fuera_de_rango,
    :retraso_invalido
  ]

  @doc """
  Ordena una lista de mapas según las opciones recibidas en una keyword list:
  `por:` campo a comparar (por defecto `:neto`), `orden:` `:asc` o `:desc`
  (por defecto `:desc`) y `limite:` cantidad máxima de elementos (por defecto todos).
  """
  def ranking(lista, opciones) do
    campo = Keyword.get(opciones, :por, :neto)
    orden = Keyword.get(opciones, :orden, :desc)
    limite = Keyword.get(opciones, :limite)

    ordenada = Enum.sort_by(lista, fn elemento -> Map.get(elemento, campo) end, orden)

    if limite == nil, do: ordenada, else: Enum.take(ordenada, limite)
  end

  @doc "R1: servicios rechazados y cantidad de rechazos por cada motivo."
  def rechazos(rechazados) do
    frecuencias = Enum.frequencies_by(rechazados, fn {_servicio, motivo} -> motivo end)
    conteo = Enum.map(@motivos, fn motivo -> {motivo, Map.get(frecuencias, motivo, 0)} end)

    %{detalle: rechazados, conteo: conteo, total: length(rechazados)}
  end

  @doc "R2: kilómetros y densidad (km / área) de cada zona, de mayor a menor densidad."
  def km_por_zona(validos, zonas) do
    km_zona =
      validos
      |> Enum.group_by(fn s -> s.zona end, fn s -> s.kilometros end)
      |> Map.new(fn {zona, kms} -> {zona, Enum.sum(kms)} end)

    zonas
    |> Enum.map(fn zona ->
      km = Map.get(km_zona, zona.id, 0)
      %{id: zona.id, nombre: zona.nombre, area: zona.area, km: km, densidad: km / zona.area}
    end)
    |> ranking(por: :densidad, orden: :desc)
  end

  @doc "R3: mapa `%{dia => km}` con los kilómetros de toda la empresa en cada día."
  def km_por_dia(validos) do
    km = Enum.group_by(validos, fn s -> s.dia end, fn s -> s.kilometros end)
    Map.new(@dias, fn dia -> {dia, Enum.sum(Map.get(km, dia, []))} end)
  end

  @doc "R3: indica qué días se alcanzó la meta, si fue todos los días y si fue al menos uno."
  def metas(km_por_dia) do
    por_dia = Map.new(km_por_dia, fn {dia, km} -> {dia, km >= @meta_diaria} end)
    cumplidos = Map.values(por_dia)

    %{
      meta: @meta_diaria,
      por_dia: por_dia,
      todos: Enum.all?(cumplidos),
      alguno: Enum.any?(cumplidos)
    }
  end

  @doc "R4: liquidaciones ordenadas por neto de mayor a menor."
  def liquidacion_ordenada(liquidaciones) do
    ranking(liquidaciones, por: :neto, orden: :desc)
  end

  @doc "R5: por cada día, el o los repartidores con más kilómetros."
  def lideres_por_dia(validos) do
    for dia <- @dias do
      km_repartidores =
        validos
        |> Enum.filter(fn s -> s.dia == dia end)
        |> Enum.group_by(fn s -> s.repartidor end, fn s -> s.kilometros end)
        |> Enum.map(fn {codigo, kms} -> {codigo, Enum.sum(kms)} end)

      if km_repartidores == [] do
        %{dia: dia, km: 0, lideres: []}
      else
        maximo = Enum.max(Enum.map(km_repartidores, fn {_codigo, km} -> km end))
        lideres = for {codigo, km} <- km_repartidores, km == maximo, do: codigo
        %{dia: dia, km: maximo, lideres: Enum.sort(lideres)}
      end
    end
  end

  @doc "R5: repartidor(es) que ocuparon el primer lugar en más días."
  def mas_dias_lider(lideres_por_dia) do
    conteo =
      lideres_por_dia
      |> Enum.flat_map(fn l -> l.lideres end)
      |> Enum.frequencies()

    if conteo == %{} do
      %{codigos: [], dias: 0}
    else
      maximo = Enum.max(Map.values(conteo))
      codigos = for {codigo, veces} <- conteo, veces == maximo, do: codigo
      %{codigos: Enum.sort(codigos), dias: maximo}
    end
  end

  @doc "Retraso promedio ponderado por kilómetros: suma(retraso x km) / suma(km)."
  def retraso_ponderado(servicios) do
    suma_ponderada = Enum.sum(Enum.map(servicios, fn s -> s.retraso * s.kilometros end))
    suma_km = Enum.sum(Enum.map(servicios, fn s -> s.kilometros end))
    suma_ponderada / suma_km
  end

  @doc "Promedio simple de los retrasos (para compararlo con el ponderado)."
  def retraso_promedio_simple(servicios) do
    Enum.sum(Enum.map(servicios, fn s -> s.retraso end)) / length(servicios)
  end

  @doc """
  R6: repartidores con al menos 3 servicios válidos, ordenados
  del menor al mayor retraso ponderado.
  """
  def puntualidad(validos) do
    validos
    |> Enum.group_by(fn s -> s.repartidor end)
    |> Enum.filter(fn {_codigo, servicios} -> length(servicios) >= @minimo_servicios_puntualidad end)
    |> Enum.map(fn {codigo, servicios} ->
      %{
        codigo: codigo,
        servicios: length(servicios),
        retraso_ponderado: retraso_ponderado(servicios),
        promedio_simple: retraso_promedio_simple(servicios)
      }
    end)
    |> ranking(por: :retraso_ponderado, orden: :asc)
  end

  @doc "R6: el o los candidatos con el menor retraso ponderado."
  def mejor_puntualidad(candidatos) do
    case candidatos do
      [] -> []
      [primero | _] -> Enum.filter(candidatos, fn c -> c.retraso_ponderado == primero.retraso_ponderado end)
    end
  end

  @doc "R7: total pagado en la semana y costo promedio por kilómetro."
  def totales(liquidaciones) do
    total_pagado = Enum.sum(Enum.map(liquidaciones, fn l -> l.neto end))
    total_km = Enum.sum(Enum.map(liquidaciones, fn l -> l.kilometros end))
    costo_por_km = if total_km > 0, do: total_pagado / total_km, else: 0

    %{total_pagado: total_pagado, total_km: total_km, costo_por_km: costo_por_km}
  end

  @doc "R8: códigos de los repartidores con al menos un servicio válido en todas las zonas."
  def todas_las_zonas(validos, zonas) do
    todas = MapSet.new(zonas, fn z -> z.id end)

    validos
    |> Enum.group_by(fn s -> s.repartidor end, fn s -> s.zona end)
    |> Enum.filter(fn {_codigo, zonas_atendidas} ->
      MapSet.subset?(todas, MapSet.new(zonas_atendidas))
    end)
    |> Enum.map(fn {codigo, _zonas} -> codigo end)
    |> Enum.sort()
  end
end
