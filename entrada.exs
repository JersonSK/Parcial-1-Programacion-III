# Integrantes: Jerson David Ballesteros, Juan David Baena, Sebastian Cortes
# Programación III - Parcial 1 - Empresa de mensajería

defmodule Entrada do
  @moduledoc """
  Convierte el texto que escribe el usuario en un servicio.
  Solo revisa el formato; las reglas de negocio las aplica `Validacion`.
  """

  @separador ";"

  @doc """
  Recibe una línea como `"M03;Z2;4;22.5;-3"` y devuelve:
  `{:ok, servicio}`, `{:error, :formato_invalido}` o `:omitido` si la línea está vacía.
  """
  def parsear_servicio(texto) do
    limpio = String.trim(texto)

    if limpio == "" do
      :omitido
    else
      convertir_campos(String.split(limpio, @separador))
    end
  end

  defp convertir_campos([repartidor, zona, dia, kilometros, retraso]) do
    with {:ok, dia} <- convertir_entero(dia),
         {:ok, kilometros} <- convertir_numero(kilometros),
         {:ok, retraso} <- convertir_numero(retraso) do
      {:ok,
       %{
         repartidor: String.trim(repartidor),
         zona: String.trim(zona),
         dia: dia,
         kilometros: kilometros,
         retraso: retraso
       }}
    end
  end

  defp convertir_campos(_campos), do: {:error, :formato_invalido}

  defp convertir_entero(texto) do
    case Integer.parse(String.trim(texto)) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :formato_invalido}
    end
  end

  defp convertir_numero(texto) do
    limpio = String.trim(texto)

    case Integer.parse(limpio) do
      {numero, ""} ->
        {:ok, numero}

      _ ->
        case Float.parse(limpio) do
          {numero, ""} -> {:ok, numero}
          _ -> {:error, :formato_invalido}
        end
    end
  end
end
