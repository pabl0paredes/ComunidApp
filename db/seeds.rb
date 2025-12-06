# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Limpiando base de datos…"

ShowChat.delete_all
Message.delete_all
Chat.delete_all
Booking.delete_all
UsableHour.delete_all
CommonSpace.delete_all
ExpenseDetail.delete_all
CommonExpense.delete_all
Resident.delete_all
Community.delete_all
Administrator.delete_all
User.delete_all

puts "Creando usuarios y administrador…"

admin_user = User.create!(
  email: "admin@gmail.com",
  password: "123456",
  name: "Administrador General",
  phone: "987654321"
)

administrator = Administrator.create!(user: admin_user)

puts "Creando comunidad…"

comunidad = Community.create!(
  administrator: administrator,
  name: "Comunidad Las Palmas",
  size: 60,
  address: "Av. Los Álamos 1234, Santiago",
  latitude: -33.45,
  longitude: -70.66
)

puts "Creando vecinos…"

residents = []
15.times do |i|
  user = User.create!(
    email: "vecino#{i+1}@gmail.com",
    password: "123456",
    name: "Vecino #{i+1}",
    phone: "#{900000000 + i}",
    picture: "https://example.com/profile#{i+1}.jpg"
  )

  residents << Resident.create!(
    user: user,
    community: comunidad,
    unit: "A#{i+1}",
    common_expense_fraction: (1.0 / 15).round(4),
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

  ExpenseDetail.create!(
    common_expense: gasto,
    detail: "Gasto de mantención #{i+1}",
    amount: gasto.total - 50000
  )

  ExpenseDetail.create!(
    common_expense: gasto,
    detail: "Servicios básicos #{i+1}",
    amount: 50000
  )
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
  name: "Sala Multiuso",
  description: "Espacio cerrado para reuniones",
  price: 10000,
  is_available: true
)

espacio3 = CommonSpace.create!(
  community: comunidad,
  name: "Cancha",
  description: "Cancha deportiva de uso libre",
  price: 0,
  is_available: true
)

puts "Creando horarios para los espacios…"
[espacio1, espacio2, espacio3].each do |esp|
  (1..15).each do |i|
    (0..5).each do |j|
      puts 15+j
      UsableHour.create!(
        common_space: esp,
        start: Time.new(2025,12,i,15+j,0,0),
        end: Time.new(2025,12,i,15+j+1,0,0),
        is_available: [true, true, false].sample
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

10.times do
  chat = chats.sample
  resident = residents.sample

  Message.create!(
    chat: chat,
    user: resident.user,
    content: [
      "Hola a todos, ¿cómo están?",
      "¿Alguien tiene información de esto?",
      "Recordatorio: pagar gastos comunes.",
      "¿Pueden revisar el portón? Está fallando.",
      "Organizamos compras al por mayor, ¿quién se suma?",
      "Mi gato se escapó, ¿alguien lo vio?",
      "Vecinos, hoy hay mantención del agua."
    ].sample
  )
end

puts "Asignando show_chats a todos los vecinos…"

residents.each do |resident|
  chats.each do |chat|
    ShowChat.create!(
      user: resident.user,
      chat: chat,
      is_hidden: [true, false, false].sample  # baja probabilidad de oculto
    )
  end
end

puts "Creando reservas (bookings)…"

days = rand(1..10).days
7.times do
  resident = residents.sample
  espacio = [espacio1, espacio2, espacio3].sample

  days += 1.days

  Booking.create!(
    resident: resident,
    common_space: espacio,
    start: DateTime.now + days,
    end: DateTime.now + days + 2.hours
  )
end

puts "Seed completado con éxito 🎉"
