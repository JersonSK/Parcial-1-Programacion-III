# Integrantes: Jerson David Ballesteros, Juan David Baena, Sebastian Cortes
# Programación III - Parcial 1 - Empresa de mensajería

defmodule Impresion do
  @moduledoc """
  Todo lo que se muestra en pantalla. Las funciones `imprimir_*` usan `IO.puts`;
  las de `formatear_*` son puras y solo convierten valores en texto.
  """

  @doc "Convierte un valor en pesos con separador de miles. Ej: 309250.0 -> \"$309.250\"."
  def formatear_dinero(valor) do
    entero = round(valor)
    signo = if entero < 0, do: "-", else: ""

    con_puntos =
      entero
      |> abs()
      |> Integer.to_string()
      |> String.reverse()
      |> String.graphemes()
      |> Enum.chunk_every(3)
      |> Enum.map(fn grupo -> Enum.join(grupo) end)
      |> Enum.join(".")
      |> String.reverse()

    "#{signo}$#{con_puntos}"
  end

  @doc "Convierte un número en texto con dos decimales."
  def formatear_decimal(valor) do
    :erlang.float_to_binary(valor / 1, decimals: 2)
  end

  @doc "Convierte un booleano en \"Sí\" o \"No\"."
  def si_no(valor) do
    if valor, do: "Sí", else: "No"
  end

  @doc "Texto con el código y el nombre de un repartidor."
  def repartidor_con_nombre(codigo, nombres) do
    "#{codigo} #{Map.get(nombres, codigo, "")}"
  end

  @doc "Imprime el título de una sección."
  def imprimir_titulo(texto) do
    IO.puts("")
    IO.puts(String.duplicate("=", 78))
    IO.puts(texto)
    IO.puts(String.duplicate("=", 78))
  end

  @doc "Informa qué pasó con el servicio adicional."
  def imprimir_resultado_adicional(resultado) do
    case resultado do
      :omitido ->
        IO.puts("No se ingresó servicio adicional.")

      {:error, :formato_invalido} ->
        IO.puts("Servicio rechazado por formato: formato_invalido")

      {:error, motivo} ->
        IO.puts("Servicio rechazado por validación: #{motivo}")

      {:ok, _servicio} ->
        IO.puts("Servicio agregado correctamente.")
    end
  end

  @doc "R1: servicios rechazados y cantidad por motivo."
  def imprimir_r1(r1) do
    imprimir_titulo("R1. Servicios rechazados")

    r1.detalle
    |> Enum.with_index(1)
    |> Enum.each(fn {{s, motivo}, numero} ->
      IO.puts(
        "#{numero}. repartidor: #{inspect(s.repartidor)}, zona: #{inspect(s.zona)}, " <>
          "día: #{inspect(s.dia)}, km: #{inspect(s.kilometros)}, " <>
          "retraso: #{inspect(s.retraso)} -> #{motivo}"
      )
    end)

    IO.puts("")
    IO.puts("Cantidad de rechazos por motivo:")
    Enum.each(r1.conteo, fn {motivo, cantidad} -> IO.puts("  #{motivo}: #{cantidad}") end)
    IO.puts("Total de rechazados: #{r1.total}")
  end

  @doc "R2: kilómetros y densidad por zona."
  def imprimir_r2(zonas) do
    imprimir_titulo("R2. Kilómetros y densidad por zona (de mayor a menor densidad)")

    IO.puts(
      String.pad_trailing("Zona", 6) <>
        String.pad_trailing("Nombre", 12) <>
        String.pad_leading("Km", 10) <>
        String.pad_leading("Área km²", 12) <> String.pad_leading("Densidad", 12)
    )

    Enum.each(zonas, fn z ->
      IO.puts(
        String.pad_trailing(z.id, 6) <>
          String.pad_trailing(z.nombre, 12) <>
          String.pad_leading(formatear_decimal(z.km), 10) <>
          String.pad_leading(formatear_decimal(z.area), 12) <>
          String.pad_leading(formatear_decimal(z.densidad), 12)
      )
    end)
  end

  @doc "R3: kilómetros por día y cumplimiento de la meta."
  def imprimir_r3(km_por_dia, metas) do
    imprimir_titulo("R3. Kilómetros de la empresa por día (meta: #{metas.meta} km)")

    for {dia, km} <- Enum.sort(km_por_dia) do
      IO.puts(
        "Día #{dia}: " <>
          String.pad_leading(formatear_decimal(km), 8) <>
          " km  ->  meta alcanzada: #{si_no(metas.por_dia[dia])}"
      )
    end

    IO.puts("")
    IO.puts("¿Se alcanzó la meta todos los días? #{si_no(metas.todos)}")
    IO.puts("¿Se alcanzó la meta al menos un día? #{si_no(metas.alguno)}")
  end

  @doc "R4: liquidación numerada de todos los repartidores."
  def imprimir_r4(liquidaciones) do
    imprimir_titulo("R4. Liquidación de repartidores (por neto, de mayor a menor)")

    IO.puts(
      String.pad_trailing("#", 4) <>
        String.pad_trailing("Repartidor", 22) <>
        String.pad_leading("Km", 8) <>
        String.pad_leading("Servicios", 12) <>
        String.pad_leading("Bonific.", 10) <>
        String.pad_leading("Alquiler", 10) <> String.pad_leading("Neto", 12)
    )

    liquidaciones
    |> Enum.with_index(1)
    |> Enum.each(fn {l, numero} ->
      IO.puts(
        String.pad_trailing("#{numero}.", 4) <>
          String.pad_trailing("#{l.codigo} #{l.nombre}", 22) <>
          String.pad_leading(formatear_decimal(l.kilometros), 8) <>
          String.pad_leading(formatear_dinero(l.valor_servicios), 12) <>
          String.pad_leading(formatear_dinero(l.bonificaciones), 10) <>
          String.pad_leading(formatear_dinero(l.alquiler), 10) <>
          String.pad_leading(formatear_dinero(l.neto), 12)
      )
    end)
  end

  @doc "R5: repartidor con más kilómetros cada día."
  def imprimir_r5(lideres, mas_dias, nombres) do
    imprimir_titulo("R5. Repartidor con más kilómetros por día")

    Enum.each(lideres, fn l ->
      if l.lideres == [] do
        IO.puts("Día #{l.dia}: sin servicios válidos")
      else
        texto = Enum.map_join(l.lideres, ", ", fn c -> repartidor_con_nombre(c, nombres) end)
        IO.puts("Día #{l.dia}: #{texto} (#{formatear_decimal(l.km)} km)")
      end
    end)

    texto = Enum.map_join(mas_dias.codigos, ", ", fn c -> repartidor_con_nombre(c, nombres) end)
    IO.puts("")
    IO.puts("Primer lugar en más días: #{texto} (#{mas_dias.dias} días)")
  end

  @doc "R6: candidatos y repartidor con mejor puntualidad."
  def imprimir_r6(candidatos, mejores, nombres) do
    imprimir_titulo("R6. Mejor puntualidad (mínimo 3 servicios válidos)")

    IO.puts(
      String.pad_trailing("Repartidor", 24) <>
        String.pad_leading("Servicios", 10) <>
        String.pad_leading("Ponderado", 12) <> String.pad_leading("Simple", 10)
    )

    Enum.each(candidatos, fn c ->
      IO.puts(
        String.pad_trailing(repartidor_con_nombre(c.codigo, nombres), 24) <>
          String.pad_leading("#{c.servicios}", 10) <>
          String.pad_leading(formatear_decimal(c.retraso_ponderado), 12) <>
          String.pad_leading(formatear_decimal(c.promedio_simple), 10)
      )
    end)

    IO.puts("")

    if mejores == [] do
      IO.puts("Ningún repartidor tiene al menos 3 servicios válidos.")
    else
      Enum.each(mejores, fn m ->
        IO.puts(
          "Mejor puntualidad: #{repartidor_con_nombre(m.codigo, nombres)} " <>
            "con retraso ponderado de #{formatear_decimal(m.retraso_ponderado)} min"
        )
      end)
    end
  end

  @doc "R7: total pagado y costo promedio por kilómetro."
  def imprimir_r7(totales) do
    imprimir_titulo("R7. Total pagado en la semana")
    IO.puts("Total pagado a los repartidores: #{formatear_dinero(totales.total_pagado)}")
    IO.puts("Kilómetros válidos recorridos: #{formatear_decimal(totales.total_km)} km")
    IO.puts("Costo promedio por kilómetro: #{formatear_dinero(totales.costo_por_km)}")
  end

  @doc "R8: repartidores con servicios válidos en todas las zonas."
  def imprimir_r8(codigos, nombres) do
    imprimir_titulo("R8. Repartidores con servicios en todas las zonas")

    if codigos == [] do
      IO.puts("Ningún repartidor trabajó en todas las zonas.")
    else
      Enum.each(codigos, fn c -> IO.puts("- #{repartidor_con_nombre(c, nombres)}") end)
    end
  end

  @doc "Comprobante de pago de un repartidor."
  def imprimir_comprobante(l) do
    imprimir_titulo("Comprobante de pago")
    IO.puts("Repartidor: #{l.nombre}")
    IO.puts("Código: #{l.codigo}")
    IO.puts("")

    if l.dias == %{} do
      IO.puts("No tiene días trabajados en la semana.")
    else
      IO.puts(
        String.pad_trailing("Día", 6) <>
          String.pad_leading("Km", 10) <>
          String.pad_leading("Servicios", 14) <> String.pad_leading("Bonificación", 14)
      )

      for {dia, resumen} <- Enum.sort(l.dias) do
        IO.puts(
          String.pad_trailing("#{dia}", 6) <>
            String.pad_leading(formatear_decimal(resumen.km), 10) <>
            String.pad_leading(formatear_dinero(resumen.valor), 14) <>
            String.pad_leading(formatear_dinero(resumen.bonificacion), 14)
        )
      end
    end

    IO.puts("")
    IO.puts("Valor de servicios:            #{formatear_dinero(l.valor_servicios)}")
    IO.puts("Bonificaciones:                #{formatear_dinero(l.bonificaciones)}")
    IO.puts("Descuento alquiler bicicleta:  #{formatear_dinero(l.alquiler)}")
    IO.puts("Neto a pagar:                  #{formatear_dinero(l.neto)}")
  end

  @doc "Muestra un mapa `%{dia => km}` ordenado por día."
  def imprimir_mapa_dias(titulo, mapa) do
    IO.puts(titulo)

    for {dia, km} <- Enum.sort(mapa) do
      IO.puts("  Día #{dia}: #{formatear_decimal(km)} km")
    end
  end

  @doc "Parte de investigación: combinación con la empresa aliada y mediciones."
  def imprimir_investigacion(km_por_dia, aliada, combinado, sin_funcion, mediciones) do
    imprimir_titulo("Investigación: combinación con la empresa aliada")
    imprimir_mapa_dias("Kilómetros de la empresa (R3):", km_por_dia)
    imprimir_mapa_dias("Kilómetros de la empresa aliada:", aliada)
    imprimir_mapa_dias("Combinación con Map.merge/3 (se suman los días repetidos):", combinado)
    imprimir_mapa_dias("Resultado con Map.merge/2 (se queda el valor de la aliada):", sin_funcion)

    imprimir_titulo("Investigación: mediciones con :timer.tc/1")

    Enum.each(mediciones, fn m ->
      IO.puts(String.pad_trailing(m.descripcion, 68) <> String.pad_leading("#{m.microsegundos} us", 12))
    end)
  end
end
