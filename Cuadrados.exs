Code.require_file("util2.ex", __DIR__)

defmodule CuadradosConcentricos do
  @colores ["#2b6cb0", "#3182ce", "#319795", "#38a169", "#d69e2e", "#dd6b20", "#e53e3e"]

  def main do
    IO.puts("=== GENERADOR DE CUADRADOS CONCÉNTRICOS (SVG) ===")

    # Utilizando las funciones de lectura segura del módulo Util2
    cantidad_cuadrados = Util2.ingresar("Ingrese la cantidad de cuadrados (por defecto 7): ", :entero)
    reduccion_lado = Util2.ingresar("Ingrese la reducción del lado (por defecto 40): ", :entero)
    lado_inicial = Util2.ingresar("Ingrese el tamaño inicial del lado (por defecto 400): ", :entero)
    posicion_x = Util2.ingresar("Ingrese la coordenada X inicial (por defecto 50): ", :entero)
    posicion_y = Util2.ingresar("Ingrese la coordenada Y inicial (por defecto 50): ", :entero)

    generar_svg("cuadrados.svg", posicion_x, posicion_y, lado_inicial, cantidad_cuadrados, reduccion_lado)
  end

  def generar_svg(nombre_archivo, x, y, lado, cantidad, reduccion) do
    ancho_lienzo = x * 2 + lado
    alto_lienzo = y * 2 + lado

    svg_header = """
    <svg xmlns="http://www.w3.org/2000/svg" width="#{ancho_lienzo}" height="#{alto_lienzo}" viewBox="0 0 #{ancho_lienzo} #{alto_lienzo}">
      <rect width="100%" height="100%" fill="white"/>
    """

    svg_footer = "\n</svg>"

    # Llamada a la función recursiva acumulando los rectángulos
    svg_cuerpo = construir_cuadrados_recursivo(x, y, lado, cantidad, reduccion, 0, "")

    svg_contenido_total = svg_header <> svg_cuerpo <> svg_footer
    File.write!(nombre_archivo, svg_contenido_total)

    Util2.mostrar("¡Archivo '#{nombre_archivo}' generado exitosamente con #{cantidad} cuadrados!", :mensaje)
  end

  # ==========================================
  # FUNCIONES RECURSIVAS (Requisito del taller)
  # ==========================================

  # Caso Base
  defp construir_cuadrados_recursivo(_x, _y, _lado, 0, _reduccion, _indice, acumulador_svg), do: acumulador_svg

  # Caso Recursivo
  defp construir_cuadrados_recursivo(x, y, lado, cantidad, reduccion, indice, acumulador_svg) do
    color_actual = Enum.at(@colores, rem(indice, length(@colores)))

    rectangulo_svg = """
      <rect x="#{x}" y="#{y}" width="#{lado}" height="#{lado}" fill="none" stroke="#{color_actual}" stroke-width="4" />
    """

    # Cálculo estricto para conservar el mismo centro geométrico
    nuevo_x = x + (reduccion / 2)
    nuevo_y = y + (reduccion / 2)
    nuevo_lado = lado - reduccion

    construir_cuadrados_recursivo(
      nuevo_x,
      nuevo_y,
      nuevo_lado,
      cantidad - 1,
      reduccion,
      indice + 1,
      acumulador_svg <> rectangulo_svg
    )
  end
end

# Ejecución del programa principal
CuadradosConcentricos.main()
