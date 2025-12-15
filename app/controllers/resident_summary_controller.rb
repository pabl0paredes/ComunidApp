class ResidentSummaryController < ApplicationController

  def index
    @resident = current_user.resident
    authorize @resident
  # residente_actual = residente asociado al usuario
  # comunidad_actual = comunidad del residente

  #obtener todas las participaciones del residente (esto representa todo lo que le genera un cargo)

  # agrupar participaciones por ítem principal (ej: por gasto común, por reserva, etc.)


  #   calcular monto total asignado al residente en este ítem
  # calcular monto total aprobado/pagado
  # determinar estado personal del residente en este ítem

  # crear objeto_resumen_item con:
  #   - id del ítem
  #   - tipo de ítem (gasto, reserva, etc.)
  #   - título / descripción
  #   - fecha o período
  #   - monto asignado
  #   - monto pagado
  #   - estado personal

  #   total_asignado = suma de todos los montos asignados
  # total_pagado   = suma de todos los montos pagados
  # total_pendiente = total_asignado - total_pagado

  # determinar estado_general del residente
  # (según reglas de negocio)

  # entregar a la vista:
  # - comunidad_actual
  # - resumen_global:
  #     - total_asignado
  #     - total_pagado
  #     - total_pendiente
  #     - estado_general
  # - lista_de_items_resumen

end

  def show
    @resident = current_user.resident
    authorize @resident
#     recibir identificador del ítem
# (no del residente, del ítem del resumen)

# verificar que el ítem pertenece al residente
# si no pertenece
#   acceso denegado
# fin

# obtener solo las participaciones del residente en ese ítem

# para cada participación:
#   preparar:
#     - descripción
#     - monto
#     - estado


#     calcular:
#   - total asignado en este ítem
#   - total pagado
#   - estado personal final

#   entregar a la vista:
#   - información básica del ítem
#   - lista de detalles del residente
#   - totales
#   - estado personal

  end


end
