class RagContextService
  MODELS = {
    "Comunidades"        => Community,
    "Gastos Comunes"     => CommonExpense,
    "Detalles de Gasto"  => ExpenseDetail,
    "Espacios Comunes"   => CommonSpace,
    "Reservas"           => Booking,
    "Horarios Disponibles" => UsableHour,
    "Residentes"         => Resident
  }.freeze

  # ✅ Método de clase (importante para que RagContextService.context_for funcione)
  def self.context_for(question)
    return "" unless question.question_embedding.present?

    context_sections = []

    MODELS.each do |label, model|
      # Solo los modelos con has_neighbors definido
      next unless model.respond_to?(:nearest_neighbors)

      neighbors = model.nearest_neighbors(
        :embedding,
        question.question_embedding,
        distance: "cosine"
      ).limit(3)

      next if neighbors.blank?

      formatted_records = neighbors.map { |record| format_record(record) }.join("\n")
      context_sections << "### #{label}\n#{formatted_records}"
    end

    context_sections.join("\n\n")
  end

  # ✅ Este método SOLO usa columnas y asociaciones que existen en tu schema
  def self.format_record(record)
    case record
    when Community
      # name, address, size
      "- Comunidad: #{record.name} — Dirección: #{record.address} — Unidades: #{record.size}"

    when CommonExpense
      # date (datetime), total (integer), community.name
      fecha = record.date&.strftime("%d/%m/%Y") || "sin fecha"
      comunidad = record.community&.name || "sin comunidad"
      "- Gasto común (#{comunidad}) — Fecha: #{fecha} — Total: #{record.total}"

    when ExpenseDetail
      # detail, amount
      "- Detalle de gasto: #{record.detail} — Monto: #{record.amount}"

    when CommonSpace
      # name, description, price, is_available
      disponible = record.is_available ? "Disponible" : "No disponible"
      precio = record.price.present? ? "#{record.price}" : "sin precio definido"
      "- Espacio común: #{record.name} — #{record.description} — Precio: #{precio} — #{disponible}"

    when Booking
      # resident.user.name, common_space.name, start/end
      vecino   = record.resident&.user&.name || "Vecino desconocido"
      espacio  = record.common_space&.name || "Espacio desconocido"
      inicio   = record.start&.strftime("%d/%m/%Y %H:%M") || "sin inicio"
      fin      = record.end&.strftime("%d/%m/%Y %H:%M") || "sin fin"

      <<~TEXT.chomp
      - Reserva:
        - Vecino: #{vecino}
        - Espacio: #{espacio}
        - Desde: #{inicio}
        - Hasta: #{fin}
      TEXT

    when UsableHour
      # start, end, is_available, common_space.name
      espacio  = record.common_space&.name || "Espacio desconocido"
      inicio   = record.start&.strftime("%d/%m/%Y %H:%M") || record.start&.to_s || "sin inicio"
      fin      = record.end&.strftime("%d/%m/%Y %H:%M") || record.end&.to_s || "sin fin"
      disponible = record.is_available ? "disponible" : "no disponible"

      "- Horario #{disponible} en #{espacio}: #{inicio} → #{fin}"

    when Resident
      # unit, is_accepted, user.name, community.name
      vecino    = record.user&.name || "Nombre no cargado"
      unidad    = record.unit.presence || "Unidad no especificada"
      comunidad = record.community&.name || "Comunidad desconocida"
      estado    = record.is_accepted ? "Aceptado" : "Pendiente de aprobación"

      "- Residente: #{vecino} — Unidad: #{unidad} — Comunidad: #{comunidad} — Estado: #{estado}"

    else
      # Fallback genérico por si se cuela algo raro
      "- Registro: #{record.class.name} ##{record.id}"
    end
  end
end
