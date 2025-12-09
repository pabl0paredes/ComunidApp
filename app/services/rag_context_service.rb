class RagContextService
  # ============================================================
  # 🔍 Modelos incluidos en el RAG
  # ============================================================
  MODELS = {
    "Comunidades"        => Community,
    "Gastos Comunes"     => CommonExpense,
    "Detalles de Gasto"  => ExpenseDetail,
    "Espacios Comunes"   => CommonSpace,
    "Residentes"         => Resident
  }.freeze

  # ============================================================
  # PUBLIC — método principal para generar contexto
  # ============================================================
  def self.context_for(question)
    return "" unless question.question_embedding.present?

    user = question.user

    # === DETECCIÓN DE COMUNIDAD (RESIDENTE O ADMIN) ===
    community = user.community

    # Si no es residente pero sí es administrador, buscamos la comunidad que administra
    if community.nil? && user.administrator.present?
      community = Community.find_by(administrator_id: user.id)
    end
    # === FIN DE LA DETECCIÓN DE COMUNIDAD ===

    # Si no hay comunidad → no devolvemos contexto
    return "" if community.nil?

    context_sections = []

    MODELS.each do |label, model|
      next unless model.respond_to?(:nearest_neighbors)

      filtered_scope = filtered_records_for(model, community)
      next if filtered_scope.none?

      neighbors =
        filtered_scope.nearest_neighbors(
          :embedding,
          question.question_embedding,
          distance: "cosine"
        ).limit(3)

      next if neighbors.blank?

      formatted_records = neighbors.map { |r| format_record(r) }.join("\n")
      context_sections << "### #{label}\n#{formatted_records}"
    end

    context_sections.join("\n\n")
  end


  # ============================================================
  # 🔥 Filtros inteligentes por modelo + comunidad del usuario
  # ============================================================
  def self.filtered_records_for(model, community)
    case model.to_s
    when "Community"
      # SOLO la comunidad del usuario
      model.where(id: community.id)

    when "Resident"
      model.where(community_id: community.id, is_accepted: true)

    when "CommonExpense"
      model.where(community_id: community.id)
           .where("date >= ?", 1.year.ago)

    when "ExpenseDetail"
      valid_expense_ids =
        CommonExpense.where(community_id: community.id)
                     .where("date >= ?", 1.year.ago)
                     .pluck(:id)

      model.where(common_expense_id: valid_expense_ids)

    when "CommonSpace"
      model.where(community_id: community.id, is_available: true)

    when "Booking"
      today = Time.zone.now
      model.joins(:common_space)
           .where(common_spaces: { community_id: community.id })
           .where("start >= ? OR end >= ?", today, today)

    else
      model.none
    end
  end

  # ============================================================
  # 🔎 Formateo por modelo
  # ============================================================
    def self.format_record(record)
    case record

    # ============================================================
    # 🏢 COMMUNITY — agrega admin + links útiles
    # ============================================================
    when Community
      admin = record.administrator&.user&.name || "Administrador no asignado"

      <<~TEXT.chomp
      - Comunidad: #{record.name}
        • Administrador: #{admin}
        • Dirección: #{record.address}
        • Unidades: #{record.size}

        • Links útiles:
          - Información general: /communities/#{record.id}
          - Gastos comunes: /communities/#{record.id}/common_expenses
          - Espacios comunes: /communities/#{record.id}/common_spaces
          - Residentes: /communities/#{record.id}/residents
      TEXT

    # ============================================================
    # 👤 RESIDENT — link directo a su comunidad
    # ============================================================
    when Resident
      vecino    = record.user&.name || "Nombre no cargado"
      unidad    = record.unit.presence || "sin unidad"
      estado    = record.is_accepted ? "Aceptado" : "Pendiente"
      comunidad = record.community&.id

      <<~TEXT.chomp
      - Residente: #{vecino}
        • Unidad: #{unidad}
        • Estado: #{estado}
        • Comunidad: #{record.community&.name}

        • Link del perfil comunitario:
          /communities/#{comunidad}/residents
      TEXT

    # ============================================================
    # 💵 COMMON EXPENSE — agrega links de acceso al gasto
    # ============================================================
    when CommonExpense
      fecha = record.date&.strftime("%d/%m/%Y") || "sin fecha"

      <<~TEXT.chomp
      - Gasto común
        • Fecha: #{fecha}
        • Total: #{record.total}

        • Ver en la app:
          /communities/#{record.community_id}/common_expenses/#{record.id}
      TEXT

    # ============================================================
    # 💰 EXPENSE DETAIL — añadimos link al gasto padre
    # ============================================================
    when ExpenseDetail
      <<~TEXT.chomp
      - Detalle del gasto:
        • Descripción: #{record.detail}
        • Monto: #{record.amount}

        • Gasto relacionado:
          /communities/#{record.common_expense.community_id}/common_expenses/#{record.common_expense_id}
      TEXT

    # ============================================================
    # 🏛️ COMMON SPACE — con links a sus reservas
    # ============================================================
    when CommonSpace
      disp = record.is_available ? "Disponible" : "No disponible"
      precio = record.price.present? ? record.price : "sin precio"

      <<~TEXT.chomp
      - Espacio Común: #{record.name}
        • Descripción: #{record.description}
        • Precio: #{precio}
        • Estado: #{disp}

        • Links:
          - Información del espacio: /common_spaces/#{record.id}
          - Reservas: /common_spaces/#{record.id}/bookings
      TEXT

    # ============================================================
    # 📅 BOOKING — mantener información estructurada
    # ============================================================
    when Booking
      vecino   = record.resident&.user&.name || "Vecino desconocido"
      espacio  = record.common_space&.name || "Espacio desconocido"
      inicio   = record.start&.strftime("%d/%m/%Y %H:%M") || "sin inicio"
      fin      = record.end&.strftime("%d/%m/%Y %H:%M") || "sin fin"

      <<~TEXT.chomp
      - Reserva:
        • Vecino: #{vecino}
        • Espacio: #{espacio}
        • Desde: #{inicio}
        • Hasta: #{fin}

        • Ver en la app:
          /common_spaces/#{record.common_space_id}/bookings/#{record.id}
      TEXT

    # ============================================================
    # 🌀 FALLBACK
    # ============================================================
    else
      "- Registro desconocido #{record.class} ##{record.id}"
    end
  end

end
