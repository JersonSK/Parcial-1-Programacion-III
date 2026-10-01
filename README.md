# Parcial 1 — Liquidación semanal de una empresa de mensajería

**Programación III — Universidad del Quindío**
Docente: Julián E. Gutiérrez Posada

Integrantes:
- Juan David Baena
- Jerson David Ballesteros
- Sebastian Cortes

## Descripción

Una empresa de mensajería registra durante 6 días los servicios de sus repartidores (zona, día,
kilómetros y retraso). El programa:

1. Pide un servicio adicional por teclado (o Enter para omitir).
2. Valida todos los servicios con las cinco reglas del enunciado y separa válidos de rechazados.
3. Liquida a cada repartidor: valor de servicios + bonificaciones − alquiler de bicicleta.
4. Imprime los reportes R1 a R8.
5. Pide el código de un repartidor e imprime su comprobante de pago.
6. Muestra la investigación: combinación con la empresa aliada (`Map.merge/3`) y mediciones con `:timer.tc/1`.

## Ejecución

```
elixir main.exs
```

Ejemplo de servicio adicional: `M03;Z2;4;22.5;-3`

## Archivos

| Archivo | Módulo | Contenido |
|---|---|---|
| `main.exs` | `Main` | Carga los demás archivos y ejecuta el programa |
| `datos.exs` | `Datos` | Repartidores, zonas y servicios |
| `entrada.exs` | `Entrada` | Convierte el texto ingresado en un servicio |
| `validacion.exs` | `Validacion` | Cinco reglas de validación encadenadas con `with` |
| `liquidacion.exs` | `Liquidacion` | Valor de servicios, bonificaciones, alquiler y neto |
| `reportes.exs` | `Reportes` | Cálculos de R1 a R8 y `ranking/2` |
| `impresion.exs` | `Impresion` | Salida en pantalla de reportes y comprobante |
| `investigacion.exs` | `Investigacion` | `Map.merge/3` y mediciones con `:timer.tc/1` |
