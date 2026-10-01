# Integrantes: Juan David Baena, Jerson David Ballesteros, Sebastian Cortes
# Programación III - Parcial 1 - Empresa de mensajería

defmodule Validacion do
  @moduledoc """
  Revisa los servicios con las cinco reglas del negocio, en el orden exigido.
  Cada verificación devuelve `{:ok, servicio}` o `{:error, motivo}`.
  """

  @dia_minimo 1
  @dia_maximo 6
  @km_maximo 45
  @retraso_minimo -30
  @retraso_maximo 180

  @doc """
  Valida un servicio encadenando las cinco reglas con `with`.
  Solo se devuelve el primer error encontrado.
  """
  def validar_servicio(servicio, codigos_repartidores, ids_zonas) do
    with {:ok, _} <- verificar_repartidor(servicio, codigos_repartidores),
         {:ok, _} <- verificar_zona(servicio, ids_zonas),
         {:ok, _} <- verificar_dia(servicio),
         {:ok, _} <- verificar_kilometros(servicio),
         {:ok, _} <- verificar_retraso(servicio) do
      {:ok, servicio}
    end
  end

  @doc """
  Separa los servicios en válidos y rechazados.
  Devuelve `{validos, rechazados}`, donde cada rechazado es `{servicio, motivo}`.
  """
  def separar_servicios(servicios, repartidores, zonas) do
    codigos = codigos_repartidores(repartidores)
    ids = ids_zonas(zonas)

    resultados = Enum.map(servicios, fn s -> {s, validar_servicio(s, codigos, ids)} end)

    validos = for {_s, {:ok, servicio}} <- resultados, do: servicio
    rechazados = for {servicio, {:error, motivo}} <- resultados, do: {servicio, motivo}

    {validos, rechazados}
  end

  @doc "Conjunto con los códigos de los repartidores."
  def codigos_repartidores(repartidores) do
    MapSet.new(repartidores, fn r -> r.codigo end)
  end

  @doc "Conjunto con los identificadores de las zonas."
  def ids_zonas(zonas) do
    MapSet.new(zonas, fn z -> z.id end)
  end

  @doc "Regla 1: el repartidor debe existir."
  def verificar_repartidor(servicio, codigos_repartidores) do
    if MapSet.member?(codigos_repartidores, servicio.repartidor) do
      {:ok, servicio}
    else
      {:error, :repartidor_desconocido}
    end
  end

  @doc "Regla 2: la zona debe existir."
  def verificar_zona(servicio, ids_zonas) do
    if MapSet.member?(ids_zonas, servicio.zona) do
      {:ok, servicio}
    else
      {:error, :zona_desconocida}
    end
  end

  @doc "Regla 3: el día debe ser un entero entre 1 y 6."
  def verificar_dia(%{dia: dia} = servicio)
      when is_integer(dia) and dia >= @dia_minimo and dia <= @dia_maximo do
    {:ok, servicio}
  end

  def verificar_dia(_servicio), do: {:error, :dia_invalido}

  @doc "Regla 4: los kilómetros deben ser un número mayor que 0 y máximo 45."
  def verificar_kilometros(%{kilometros: km} = servicio)
      when is_number(km) and km > 0 and km <= @km_maximo do
    {:ok, servicio}
  end

  def verificar_kilometros(_servicio), do: {:error, :kilometros_fuera_de_rango}

  @doc "Regla 5: el retraso debe ser un número entre -30 y 180 minutos."
  def verificar_retraso(%{retraso: retraso} = servicio)
      when is_number(retraso) and retraso >= @retraso_minimo and retraso <= @retraso_maximo do
    {:ok, servicio}
  end

  def verificar_retraso(_servicio), do: {:error, :retraso_invalido}
end
