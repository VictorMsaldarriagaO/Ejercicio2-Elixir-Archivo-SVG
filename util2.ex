defmodule Util2 do
  @moduledoc """
  Funciones auxiliares de propósito general para entrada y salida de datos,
  procesamiento de colecciones y conversión de sus elementos a texto.

  El módulo incluye funciones para:
  - leer datos desde teclado;
  - validar valores enteros, reales y booleanos;
  - ingresar colecciones de elementos;
  - mostrar mensajes y errores;
  - ordenar y filtrar colecciones;
  - convertir colecciones a una representación textual.

  ## Información
  - **Versión:** 2.0
  - **Autores:** Emiliano Arboleda Londoño, Jhon Deivid Ruan Velasco y Víctor Manuel Saldarriaga Ocampo
  - **Fecha:** septiembre de 2026
  - **Licencia:** GNU GPL v3
  """

  # -----------------------------------
  # Salida de datos
  # -----------------------------------

  @doc """
  Muestra un mensaje en la salida indicada.
  """
  def mostrar(mensaje, :mensaje), do: IO.puts(mensaje)
  def mostrar(mensaje, :error), do: IO.puts(:standard_error, mensaje)

  # -----------------------------------
  # Entrada de datos
  # -----------------------------------

  def ingresar(pregunta, :coleccion_reales) do
    ingresar(fn -> ingresar(pregunta, :real) end, :coleccion)
  end

  def ingresar(pregunta, :coleccion_enteros) do
    ingresar(fn -> ingresar(pregunta, :entero) end, :coleccion)
  end

  def ingresar(pregunta, :coleccion_textos) do
    ingresar(fn -> ingresar(pregunta, :texto) end, :coleccion)
  end

  def ingresar(ingresar_elemento, :coleccion) do
    ingresar_coleccion(ingresar_elemento, [])
  end

  def ingresar(pregunta, :boolean) do
    ingresar(
      pregunta,
      fn texto ->
        case String.downcase(texto) do
          "s" -> {true, ""}
          "n" -> {false, ""}
          _ -> :error
        end
      end,
      :boolean
    )
  end

  def ingresar(pregunta, :real) do
    ingresar(pregunta, &Float.parse/1, :real)
  end

  def ingresar(pregunta, :entero) do
    ingresar(pregunta, &Integer.parse/1, :entero)
  end

  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end

  # -----------------------------------
  # Operaciones sobre colecciones
  # -----------------------------------

  def ordenar(coleccion, sentido \\ :asc, obtener_campo \\ & &1) do
    Enum.sort_by(coleccion, obtener_campo, sentido)
  end

  def aplicar_filtro_longitud(coleccion, longitud) do
    aplicar_filtro(coleccion, &(String.length(&1) <= longitud))
  end

  def aplicar_filtro_inicial(coleccion, inicia) do
    aplicar_filtro(coleccion, &String.starts_with?(&1, inicia))
  end

  def aplicar_filtro(coleccion, filtro) do
    Enum.filter(coleccion, filtro)
  end

  def convertir_coleccion_mensaje(
        coleccion,
        formato \\ fn elemento -> " - #{elemento}\n" end
      ) do
    Enum.map(coleccion, formato)
  end

  # -----------------------------------
  # Funciones auxiliares privadas
  # -----------------------------------

  defp ingresar_coleccion(ingresar_elemento, lista_actual) do
    elemento = ingresar_elemento.()
    nueva_lista = [elemento | lista_actual]

    case ingresar("\n¿Hay más datos (s/n)? ", :boolean) do
      true ->
        ingresar_coleccion(ingresar_elemento, nueva_lista)

      false ->
        Enum.reverse(nueva_lista)
    end
  end

  defp ingresar(pregunta, parser, tipo_dato) do
    resultado =
      pregunta
      |> ingresar(:texto)
      |> parser.()

    case resultado do
      {valor, ""} ->
        valor

      _ ->
        mostrar(
          "El valor ingresado no es válido para el tipo #{tipo_dato}. Intente nuevamente.\n",
          :error
        )

        ingresar(pregunta, tipo_dato)
    end
  end
end
