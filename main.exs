# Integrantes: Jerson David Ballesteros, Juan David Baena, Sebastian Cortes
# Programación III - Parcial 1 - Empresa de mensajería

Code.require_file("datos.exs", __DIR__)
Code.require_file("entrada.exs", __DIR__)
Code.require_file("validacion.exs", __DIR__)
Code.require_file("liquidacion.exs", __DIR__)
Code.require_file("reportes.exs", __DIR__)
Code.require_file("impresion.exs", __DIR__)
Code.require_file("investigacion.exs", __DIR__)

defmodule Main do
  @moduledoc """
  Punto de entrada del programa. Pide el servicio adicional, imprime los
  reportes R1 a R8, el comprobante de un repartidor y la investigación.
  """

  @doc "Ejecuta el programa completo."
  def ejecutar do
    repartidores = Datos.repartidores()
    zonas = Datos.zonas()

    servicios = pedir_servicio_adicional(Datos.servicios(), repartidores, zonas)

    {validos, rechazados} = Validacion.separar_servicios(servicios, repartidores, zonas)
    liquidaciones = Liquidacion.liquidar_todos(repartidores, validos)
    nombres = Map.new(repartidores, fn r -> {r.codigo, r.nombre} end)
    km_dia = Reportes.km_por_dia(validos)
    lideres = Reportes.lideres_por_dia(validos)
    candidatos = Reportes.puntualidad(validos)

    Impresion.imprimir_r1(Reportes.rechazos(rechazados))
    Impresion.imprimir_r2(Reportes.km_por_zona(validos, zonas))
    Impresion.imprimir_r3(km_dia, Reportes.metas(km_dia))
    Impresion.imprimir_r4(Reportes.liquidacion_ordenada(liquidaciones))
    Impresion.imprimir_r5(lideres, Reportes.mas_dias_lider(lideres), nombres)
    Impresion.imprimir_r6(candidatos, Reportes.mejor_puntualidad(candidatos), nombres)
    Impresion.imprimir_r7(Reportes.totales(liquidaciones))
    Impresion.imprimir_r8(Reportes.todas_las_zonas(validos, zonas), nombres)

    pedir_comprobante(liquidaciones)

    aliada = Investigacion.empresa_aliada()

    Impresion.imprimir_investigacion(
      km_dia,
      aliada,
      Investigacion.combinar_con_aliada(km_dia, aliada),
      Investigacion.combinar_sin_funcion(km_dia, aliada),
      Investigacion.mediciones(servicios, repartidores, zonas)
    )
  end

  @doc """
  Pide un servicio por teclado e informa el resultado. Si el formato es correcto,
  el servicio se agrega a la lista (si no cumple una regla, aparecerá en R1).
  """
  def pedir_servicio_adicional(servicios, repartidores, zonas) do
    texto =
      leer_linea("Ingrese un servicio adicional\n(repartidor;zona;dia;kilometros;retraso)\no Enter para omitir: ")

    case Entrada.parsear_servicio(texto) do
      {:ok, servicio} ->
        resultado =
          Validacion.validar_servicio(
            servicio,
            Validacion.codigos_repartidores(repartidores),
            Validacion.ids_zonas(zonas)
          )

        Impresion.imprimir_resultado_adicional(resultado)
        servicios ++ [servicio]

      otro ->
        Impresion.imprimir_resultado_adicional(otro)
        servicios
    end
  end

  @doc "Pide el código de un repartidor e imprime su comprobante si existe."
  def pedir_comprobante(liquidaciones) do
    por_codigo = Map.new(liquidaciones, fn l -> {l.codigo, l} end)

    IO.puts("")
    codigo = String.upcase(String.trim(leer_linea("Ingrese el código de un repartidor: ")))

    case Map.fetch(por_codigo, codigo) do
      {:ok, liquidacion} -> Impresion.imprimir_comprobante(liquidacion)
      :error -> IO.puts("No existe un repartidor con el código \"#{codigo}\".")
    end
  end

  defp leer_linea(mensaje) do
    case IO.gets(mensaje) do
      texto when is_binary(texto) -> texto
      _ -> ""
    end
  end
end

Main.ejecutar()
