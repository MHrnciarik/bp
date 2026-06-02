# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Prikladovy ucet
sample_user = User.find_or_initialize_by(email: "michalxhrnciarik@gmail.com")
sample_user.assign_attributes(
  username: "Michal",
  password: "heslo12345",
  password_confirmation: "heslo12345",
  xp: 1_250,
  login_count: 18,
  current_login_streak: 5,
  total_login_days: 14,
  last_login_on: Date.current
)
sample_user.save!

sample_company = sample_user.companies.find_or_initialize_by(ico: "31333532")
sample_company.assign_attributes(
  name: "ESET, spol. s r.o.",
  dic: "2020317068",
  ic_dph: "SK2020317068",
  street: "Einsteinova 24",
  city: "Bratislava",
  postal_code: "85101",
  country: "Slovensko"
)
sample_company.save!

sample_company.invoices.destroy_all
sample_company.expenses.destroy_all
sample_company.clients.destroy_all
sample_company.vendors.destroy_all

clients = [
  {
    key: :atlas,
    kind: "company",
    name: "Atlas Digital s.r.o.",
    ico: "51234567",
    dic: "2123456789",
    ic_dph: "SK2123456789",
    street: "Karadzicova 8",
    city: "Bratislava",
    postal_code: "82108",
    country: "Slovensko",
    email: "finance@atlasdigital.test",
    phone: "+421 900 111 222",
    website: "atlasdigital.test",
    note: "Pravidelny odberatel online sluzieb"
  },
  {
    key: :nova,
    kind: "company",
    name: "Nova Retail s.r.o.",
    ico: "52345678",
    dic: "2124567890",
    ic_dph: "SK2124567890",
    street: "Mlynske nivy 12",
    city: "Bratislava",
    postal_code: "82109",
    country: "Slovensko",
    email: "uctaren@novaretail.test",
    phone: "+421 900 222 333",
    website: "novaretail.test",
    note: "Odberatel licencii a konzultacii"
  },
  {
    key: :tatra,
    kind: "company",
    name: "Tatra Labs s.r.o.",
    ico: "53456789",
    dic: "2125678901",
    ic_dph: "SK2125678901",
    street: "Hlavna 15",
    city: "Kosice",
    postal_code: "04001",
    country: "Slovensko",
    email: "office@tatralabs.test",
    phone: "+421 900 333 444",
    website: "tatralabs.test",
    note: "Odberatel bezpecnostnych auditov"
  },
  {
    key: :daniel,
    kind: "person",
    first_name: "Daniel",
    last_name: "Kovac",
    street: "Namestie SNP 6",
    city: "Banska Bystrica",
    postal_code: "97401",
    country: "Slovensko",
    email: "daniel.kovac@example.test",
    phone: "+421 900 444 555",
    note: "Fyzicka osoba s individualnymi konzultaciami"
  },
  {
    key: :urban,
    kind: "company",
    name: "Urban Systems s.r.o.",
    ico: "54567890",
    dic: "2126789012",
    ic_dph: "SK2126789012",
    street: "Stefanikova 21",
    city: "Trnava",
    postal_code: "91701",
    country: "Slovensko",
    email: "billing@urbansystems.test",
    phone: "+421 900 555 666",
    website: "urbansystems.test",
    note: "Odberatel podpory infrastruktury"
  },
  {
    key: :bluebird,
    kind: "company",
    name: "Bluebird Apps s.r.o.",
    ico: "55678901",
    dic: "2127890123",
    ic_dph: "SK2127890123",
    street: "Mostova 2",
    city: "Zilina",
    postal_code: "01001",
    country: "Slovensko",
    email: "billing@bluebirdapps.test",
    phone: "+421 900 666 777",
    website: "bluebirdapps.test",
    note: "Odberatel skoleni a onboardingu"
  }
].each_with_object({}) do |attributes, records|
  key = attributes.delete(:key)
  records[key] = sample_company.clients.create!(attributes)
end

vendors = [
  {
    key: :cloudway,
    kind: "company",
    name: "Cloudway Services s.r.o.",
    ico: "60123456",
    dic: "2129012345",
    ic_dph: "SK2129012345",
    street: "Pribinova 4",
    city: "Bratislava",
    postal_code: "81109",
    country: "Slovensko",
    email: "billing@cloudway.test",
    phone: "+421 901 111 222",
    website: "cloudway.test",
    note: "Dodavatel cloudovych sluzieb"
  },
  {
    key: :officepro,
    kind: "company",
    name: "OfficePro Market s.r.o.",
    ico: "61234567",
    dic: "2120123456",
    ic_dph: "SK2120123456",
    street: "Racianska 44",
    city: "Bratislava",
    postal_code: "83102",
    country: "Slovensko",
    email: "faktury@officepro.test",
    phone: "+421 901 222 333",
    website: "officepro.test",
    note: "Dodavatel kancelarskych potrieb"
  },
  {
    key: :renthub,
    kind: "company",
    name: "RentHub Offices s.r.o.",
    ico: "62345678",
    dic: "2121234567",
    ic_dph: "SK2121234567",
    street: "Grosslingova 10",
    city: "Bratislava",
    postal_code: "81109",
    country: "Slovensko",
    email: "accounts@renthub.test",
    phone: "+421 901 333 444",
    website: "renthub.test",
    note: "Dodavatel prenajmu kancelarii"
  },
  {
    key: :travelgo,
    kind: "company",
    name: "TravelGo s.r.o.",
    ico: "63456789",
    dic: "2122345678",
    ic_dph: "SK2122345678",
    street: "Letiskova 18",
    city: "Bratislava",
    postal_code: "82104",
    country: "Slovensko",
    email: "invoice@travelgo.test",
    phone: "+421 901 444 555",
    website: "travelgo.test",
    note: "Dodavatel cestovnych sluzieb"
  },
  {
    key: :legalis,
    kind: "company",
    name: "Legalis Advisory s.r.o.",
    ico: "64567890",
    dic: "2123456701",
    ic_dph: "SK2123456701",
    street: "Dunajska 7",
    city: "Bratislava",
    postal_code: "81108",
    country: "Slovensko",
    email: "office@legalis.test",
    phone: "+421 901 555 666",
    website: "legalis.test",
    note: "Dodavatel pravnych sluzieb"
  },
  {
    key: :eva,
    kind: "person",
    first_name: "Eva",
    last_name: "Hruskova",
    street: "Palisady 31",
    city: "Bratislava",
    postal_code: "81106",
    country: "Slovensko",
    email: "eva.hruskova@example.test",
    phone: "+421 901 666 777",
    note: "Dodavatel ako fyzicka osoba"
  }
].each_with_object({}) do |attributes, records|
  key = attributes.delete(:key)
  records[key] = sample_company.vendors.create!(attributes)
end

invoice_rows = [
  {
    client: clients[:atlas],
    issued_on: 50.days.ago.to_date,
    due_on: 36.days.ago.to_date,
    status: "paid",
    note: "Implementacia centralnej konzoly",
    items: [
      [ "Implementacny workshop", 1, 900, 23 ],
      [ "Konfiguracia pravidiel", 6, 120, 23 ]
    ]
  },
  {
    client: clients[:nova],
    issued_on: 43.days.ago.to_date,
    due_on: 29.days.ago.to_date,
    status: "paid",
    note: "Licencie a technicka podpora",
    items: [
      [ "Rocne predplatne", 25, 38, 23 ],
      [ "Technicka podpora", 4, 95, 23 ]
    ]
  },
  {
    client: clients[:tatra],
    issued_on: 35.days.ago.to_date,
    due_on: 21.days.ago.to_date,
    status: "paid",
    note: "Bezpecnostny audit aplikacie",
    items: [
      [ "Audit zdrojoveho kodu", 12, 110, 23 ],
      [ "Zaverecna sprava", 1, 240, 23 ]
    ]
  },
  {
    client: clients[:daniel],
    issued_on: 24.days.ago.to_date,
    due_on: 10.days.ago.to_date,
    status: "overdue",
    note: "Individualne konzultacie",
    items: [
      [ "Konzultacia", 5, 80, 23 ],
      [ "Priprava materialov", 1, 120, 23 ]
    ]
  },
  {
    client: clients[:urban],
    issued_on: 16.days.ago.to_date,
    due_on: 14.days.from_now.to_date,
    status: "unpaid",
    note: "Monitoring a reporting",
    items: [
      [ "Mesacny monitoring", 1, 640, 23 ],
      [ "Reportovanie", 2, 75, 23 ]
    ]
  },
  {
    client: clients[:bluebird],
    issued_on: 12.days.ago.to_date,
    due_on: 18.days.from_now.to_date,
    status: "unpaid",
    note: "Skolenie administratorov",
    items: [
      [ "Skolenie timu", 1, 780, 23 ],
      [ "Onboarding dokumentacia", 1, 180, 23 ]
    ]
  },
  {
    client: clients[:atlas],
    issued_on: 8.days.ago.to_date,
    due_on: 22.days.from_now.to_date,
    status: "unpaid",
    note: "Rozsirenie integracie",
    items: [
      [ "API integracia", 8, 115, 23 ],
      [ "Testovanie", 3, 90, 23 ]
    ]
  },
  {
    client: clients[:nova],
    issued_on: Date.current,
    due_on: 14.days.from_now.to_date,
    status: "unpaid",
    note: "Doplnkove licencie",
    items: [
      [ "Doplnkova licencia", 10, 42, 23 ],
      [ "Nastavenie uctov", 2, 65, 23 ]
    ]
  }
]

invoice_rows.each do |row|
  items = row.delete(:items)
  sample_company.invoices.create!(
    row.merge(
      currency: "EUR",
      invoice_items_attributes: items.map do |name, quantity, unit_price, tax_rate|
        { name: name, quantity: quantity, unit_price: unit_price, tax_rate: tax_rate }
      end
    )
  )
end

expense_rows = [
  {
    vendor_record: vendors[:cloudway],
    date: 48.days.ago.to_date,
    category: "Subscriptions",
    payment_method: "Credit Card",
    note: "Cloudova infrastruktura",
    items: [
      [ "Serverove zdroje", 1, 260, 23 ],
      [ "Zalohovanie", 1, 65, 23 ]
    ]
  },
  {
    vendor_record: vendors[:officepro],
    date: 41.days.ago.to_date,
    category: "Shopping",
    payment_method: "Bank Transfer",
    note: "Kancelarske vybavenie",
    items: [
      [ "Ergonomicka stolicka", 2, 180, 23 ],
      [ "Kancelarske potreby", 1, 75, 23 ]
    ]
  },
  {
    vendor_record: vendors[:renthub],
    date: 32.days.ago.to_date,
    category: "Housing",
    payment_method: "Bank Transfer",
    note: "Prenajom kancelarie",
    items: [
      [ "Coworking mesacny pausal", 1, 520, 23 ]
    ]
  },
  {
    vendor_record: vendors[:travelgo],
    date: 25.days.ago.to_date,
    category: "Transportation",
    payment_method: "Debit Card",
    note: "Cesta za klientom",
    items: [
      [ "Vlakove listky", 2, 38, 23 ],
      [ "Taxi", 1, 24, 23 ]
    ]
  },
  {
    vendor_record: vendors[:legalis],
    date: 20.days.ago.to_date,
    category: "Other",
    payment_method: "Bank Transfer",
    note: "Pravna kontrola zmluv",
    items: [
      [ "Pravne poradenstvo", 3, 120, 23 ]
    ]
  },
  {
    vendor_record: vendors[:eva],
    date: 14.days.ago.to_date,
    category: "Education",
    payment_method: "Bank Transfer",
    note: "Interny workshop",
    items: [
      [ "Facilitacia workshopu", 1, 350, 23 ]
    ]
  },
  {
    vendor_record: vendors[:cloudway],
    date: 7.days.ago.to_date,
    category: "Utilities",
    payment_method: "Credit Card",
    note: "Monitoring a notifikacie",
    items: [
      [ "Monitoring", 1, 95, 23 ],
      [ "SMS notifikacie", 250, 0.08, 23 ]
    ]
  },
  {
    vendor_record: vendors[:officepro],
    date: Date.current,
    category: "Food",
    payment_method: "Cash",
    note: "Obcerstvenie na stretnutie",
    items: [
      [ "Obcerstvenie", 1, 46, 23 ]
    ]
  }
]

expense_rows.each do |row|
  items = row.delete(:items)
  sample_company.expenses.create!(
    row.merge(
      currency: "EUR",
      expense_items_attributes: items.map do |name, quantity, unit_price, tax_rate|
        { name: name, quantity: quantity, unit_price: unit_price, tax_rate: tax_rate }
      end
    )
  )
end
