# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"

puts "Limpiando base de datos…"

Question.delete_all
ChatSession.delete_all

ShowChat.delete_all
Message.delete_all
Chat.delete_all

Booking.delete_all
UsableHour.delete_all
CommonSpace.delete_all

ExpenseDetailsResident.delete_all
ExpenseDetail.delete_all
CommonExpense.delete_all

Resident.delete_all
Community.delete_all
Administrator.delete_all

User.delete_all

Time.zone = "America/Santiago"

puts "Creando usuarios y administrador…"

admin_user = User.create!(
  email: "pablo@comunidapp.cl",
  password: "123456",
  name: "Pablo Paredes Haz",
  phone: "56973732342"
)

administrator = Administrator.create!(user: admin_user)

puts "Creando comunidad…"

comunidad = Community.create!(
  administrator: administrator,
  name: "Edificio Villamagna",
  size: 50,
  address: "AV Luis Thayer 1573, Providencia, Santiago",
  latitude: -33.45,
  longitude: -70.66
)

puts "Creando vecinos…"

resident_data = [
  ["María González",     "https://randomuser.me/api/portraits/women/10.jpg"],
  ["Jorge Ramírez",      "https://randomuser.me/api/portraits/men/12.jpg"],
  ["Camila Torres",      "https://randomuser.me/api/portraits/women/22.jpg"],
  ["Sebastián Rojas",    "https://randomuser.me/api/portraits/men/45.jpg"],
  ["Valentina Herrera",  "https://randomuser.me/api/portraits/women/31.jpg"],
  ["Nicolás Fuentes",    "https://randomuser.me/api/portraits/men/38.jpg"],
  ["Daniela Álvarez",    "https://randomuser.me/api/portraits/women/28.jpg"],
  ["Tomás Castillo",     "https://randomuser.me/api/portraits/men/52.jpg"],
  ["Francisca Morales",  "https://randomuser.me/api/portraits/women/65.jpg"],
  ["Rodrigo Pérez",      "https://randomuser.me/api/portraits/men/70.jpg"]
]

# Generamos unidades 300–320, saltando 304
units = (300..320).to_a - [304]
units = units.first(10)  # Tomamos las primeras 10

residents = []

resident_data.each_with_index do |(full_name, avatar_url), i|
  first, last = full_name.downcase.split
  email = "#{first}.#{last}@comunidapp.com"

  user = User.create!(
    email: email,
    password: "123456",
    name: full_name,
    phone: "9#{rand(10000000..99999999)}",
    picture: avatar_url,
    time_zone: "America/Santiago"
  )

  residents << Resident.create!(
    user: user,
    community: comunidad,
    unit: units[i].to_s,
    common_expense_fraction: (1.0 / 10).round(4),
    is_accepted: true
  )
end


puts "Creando gastos comunes…"

4.times do |i|
  gasto = CommonExpense.create!(
    community: comunidad,
    date: (Date.today - (i+1).months),
    total: 150000 + i * 20000
  )

  # -----------------------------
  # PRIMER DETALLE
  # -----------------------------
  detail1 = ExpenseDetail.create!(
    common_expense: gasto,
    detail: "Gasto de mantención de lavandería #{i+1}",
    amount: gasto.total - 50000
  )

  random_residents_1 = residents.sample(rand(1..3))
  split_amount_1 = (detail1.amount.to_f / random_residents_1.size).round(2)

  random_residents_1.each do |res|
    ExpenseDetailsResident.create!(
      expense_detail: detail1,
      resident: res,
      amount_due: split_amount_1,
      paid: false
      # status queda como nil (válido)
    )
  end

  # -----------------------------
  # SEGUNDO DETALLE
  # -----------------------------
  detail2 = ExpenseDetail.create!(
    common_expense: gasto,
    detail: "Reparación de piscina #{i+1}",
    amount: 50000
  )

  random_residents_2 = residents.sample(rand(1..3))
  split_amount_2 = (detail2.amount.to_f / random_residents_2.size).round(2)

  random_residents_2.each do |res|
    ExpenseDetailsResident.create!(
      expense_detail: detail2,
      resident: res,
      amount_due: split_amount_2,
      paid: false
      # status queda como nil (válido)
    )
  end
end


puts "Creando espacios comunes…"

espacio1 = CommonSpace.create!(
  community: comunidad,
  name: "Quincho",
  description: "Espacio equipado para asados",
  price: 15000,
  is_available: true
)

espacio2 = CommonSpace.create!(
  community: comunidad,
  name: "Piscina",
  description: "Espacio cerrado para practicar natación",
  price: 10000,
  is_available: true
)

espacio3 = CommonSpace.create!(
  community: comunidad,
  name: "Lavandería",
  description: "Para Lavar/secar sus pertenencias",
  price: 0,
  is_available: true
)

puts "Creando horarios para los espacios…"

[espacio1, espacio2, espacio3].each do |esp|
  # Solo 7 días en vez de 15
  (1..7).each do |day|
    # Solo 4 horarios por día en vez de 6
    (0..3).each do |block|
      is_available = !(day == 3 && block == 1) # ejemplo de bloqueo pequeño

      UsableHour.create!(
        common_space: esp,
        start: Time.new(2025, 12, day, 15 + block, 0, 0),
        end:   Time.new(2025, 12, day, 15 + block + 1, 0, 0),
        is_available: is_available
      )
    end
  end
end

puts "Creando chats…"

chat_anuncios = Chat.create!(
  community: comunidad,
  name: "Anuncios Generales",
  category: "General"
)

chat_seguridad = Chat.create!(
  community: comunidad,
  name: "Seguridad",
  category: "Seguridad"
)

chat_compras = Chat.create!(
  community: comunidad,
  name: "Compras Compartidas",
  category: "Otros"
)

chat_mascotas = Chat.create!(
  community: comunidad,
  name: "Mascotas",
  category: "Otros"
)

chats = [chat_anuncios, chat_seguridad, chat_compras, chat_mascotas]

puts "Creando mensajes en chats…"

# Identificar chats por nombre
chat_anuncios   = chats.find { |c| c.name == "Anuncios Generales" }
chat_seguridad  = chats.find { |c| c.name == "Seguridad" }
chat_compras    = chats.find { |c| c.name == "Compras Compartidas" }
chat_mascotas   = chats.find { |c| c.name == "Mascotas" }

# Helper para obtener usuarios rápidamente
def find_user_by_name(residents, name)
  residents.find { |r| r.user.name == name }.user
end

# Vecinos por nombre
maria     = find_user_by_name(residents, "María González")
tomas     = find_user_by_name(residents, "Tomás Castillo")
sebastian = find_user_by_name(residents, "Sebastián Rojas")
rodrigo   = find_user_by_name(residents, "Rodrigo Pérez")
francisca = find_user_by_name(residents, "Francisca Morales")
nicolas   = find_user_by_name(residents, "Nicolás Fuentes")
daniela   = find_user_by_name(residents, "Daniela Álvarez")
valentina = find_user_by_name(residents, "Valentina Herrera")

now = Time.zone.now

# ---------------------------
# 🟦 ANUNCIOS GENERALES
# ---------------------------
Message.create!(
  chat: chat_anuncios,
  user: maria,
  content: "Recordatorio: pagar gastos comunes.",
  created_at: now - 4.hours
)

Message.create!(
  chat: chat_anuncios,
  user: tomas,
  content: "Mañana habrá corte de agua entre las 9:00 y las 11:00.",
  created_at: now - 3.hours
)

# ---------------------------
# 🟧 SEGURIDAD
# ---------------------------
Message.create!(
  chat: chat_seguridad,
  user: sebastian,
  content: "¿Pueden revisar el portón? Está fallando.",
  created_at: now - 2.hours
)

Message.create!(
  chat: chat_seguridad,
  user: rodrigo,
  content: "Anoche se escucharon ruidos en el estacionamiento, ¿alguien más los oyó?",
  created_at: now - 90.minutes
)

# ---------------------------
# 🟩 COMPRAS COMPARTIDAS
# ---------------------------
Message.create!(
  chat: chat_compras,
  user: francisca,
  content: "Organizamos compras al por mayor, ¿quién se suma?",
  created_at: now - 2.hours
)

Message.create!(
  chat: chat_compras,
  user: nicolas,
  content: "Voy al súper el sábado, puedo traer productos de limpieza para dividir.",
  created_at: now - 80.minutes
)

# ---------------------------
# 🐾 MASCOTAS (hilo especial)
# ---------------------------

# 1) Daniela: mi gato se perdió
msg1 = Message.create!(
  chat: chat_mascotas,
  user: daniela,
  content: "¡Vecinos, mi gato se escapó! ¿Alguien lo vio?",
  created_at: now - 110.minutes
)

# 2) Valentina pregunta
msg2 = Message.create!(
  chat: chat_mascotas,
  user: valentina,
  content: "Uy, qué mal. ¿Cómo es tu gato?",
  created_at: now - 100.minutes
)

# 3) Daniela responde + adjunta foto
msg3 = Message.create!(
  chat: chat_mascotas,
  user: daniela,
  content: "Es un gatito atigrado café con blanco, ojos verdes. Se llama Milo. Lo busqué por el estacionamiento pero no aparece. Les dejo una foto por si lo ven ❤️",
  created_at: now - 95.minutes
)

file = URI.open("https://cdn2.thecatapi.com/images/MTY3ODIyMQ.jpg")
msg3.files.attach(
  io: file,
  filename: "gato_milo.jpg",
  content_type: "image/jpeg"
)

puts "Asignando show_chats a todos los vecinos…"

residents.each do |resident|
  chats.each do |chat|
    ShowChat.create!(
      user: resident.user,
      chat: chat,
      is_hidden: false  # todo visible para el vivo
    )
  end
end


puts "Creando reservas (bookings)…"

days = 0
7.times do
  resident = residents.sample
  espacio = [espacio1, espacio2, espacio3].sample

  Booking.create!(
    resident: resident,
    common_space: espacio,
    start: Time.new(2025,12,7 + days,16,0,0),
    end: Time.new(2025,12,7 + days,16+1,0,0)
  )

  days += 1
end

puts "Seed completado con éxito 🎉"
