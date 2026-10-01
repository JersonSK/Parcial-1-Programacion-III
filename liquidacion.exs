# Integrantes: Jerson David Ballesteros, Juan David Baena, Sebastian Cortes
# Programación III - Parcial 1 - Empresa de mensajería

defmodule Liquidacion do
  @moduledoc """
  Calcula cuánto se le paga a cada repartidor en la semana:
  valor de servicios + bonificaciones - alquiler de bicicleta.
  """

  @tarifa_km 2500
  @km_bonificacion 80
  @bonificacion_diaria 15_000
  @alquiler_bicicleta 10_000

  @doc """
  Factor que se aplica al valor según el retraso:
  hasta 0 min +8 %, hasta 10 sin ajuste, hasta 30 -10 % y más de 30 -25 %.
  """
  def factor_puntualidad(retraso) do
    cond do
      retraso <= 0 -> 1.08
      retraso <= 10 -> 1.0
      retraso <= 30 -> 0.90
      true -> 0.75
    end
  end

  @doc "Valor de un servicio: kilómetros x tarifa x factor de puntualidad."
  def valor_servicio(servicio) do
    servicio.kilometros * @tarifa_km * factor_puntualidad(servicio.retraso)
  end

  @doc "Bonificación de un día según los kilómetros recorridos ese día."
  def bonificacion_dia(km) do
    if km >= @km_bonificacion, do: @bonificacion_diaria, else: 0
  end

  @doc """
  Agrupa los servicios de un repartidor por día.
  Devuelve `%{dia => %{km: _, valor: _, bonificacion: _}}`.
  """
  def resumen_por_dia(servicios) do
    servicios
    |> Enum.group_by(fn s -> s.dia end)
    |> Map.new(fn {dia, del_dia} ->
      km = Enum.sum(Enum.map(del_dia, fn s -> s.kilometros end))
      valor = Enum.sum(Enum.map(del_dia, fn s -> valor_servicio(s) end))
      {dia, %{km: km, valor: valor, bonificacion: bonificacion_dia(km)}}
    end)
  end

  @doc "Liquidación de un repartidor a partir de los servicios válidos."
  def liquidar_repartidor(repartidor, validos) do
    propios = Enum.filter(validos, fn s -> s.repartidor == repartidor.codigo end)
    dias = resumen_por_dia(propios)
    resumenes = Map.values(dias)

    kilometros = Enum.sum(Enum.map(resumenes, fn r -> r.km end))
    valor_servicios = Enum.sum(Enum.map(resumenes, fn r -> r.valor end))
    bonificaciones = Enum.sum(Enum.map(resumenes, fn r -> r.bonificacion end))

    alquiler =
      if repartidor.bicicleta, do: map_size(dias) * @alquiler_bicicleta, else: 0

    %{
      codigo: repartidor.codigo,
      nombre: repartidor.nombre,
      bicicleta: repartidor.bicicleta,
      kilometros: kilometros,
      valor_servicios: valor_servicios,
      bonificaciones: bonificaciones,
      alquiler: alquiler,
      neto: valor_servicios + bonificaciones - alquiler,
      dias: dias
    }
  end

  @doc "Liquidación de todos los repartidores, incluso los que no tienen servicios."
  def liquidar_todos(repartidores, validos) do
    Enum.map(repartidores, fn r -> liquidar_repartidor(r, validos) end)
  end
end
