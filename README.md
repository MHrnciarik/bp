# Webová aplikácia Funance

Webová aplikácia vytvorená v Ruby on Rails. Aplikácia slúži na správu používateľského profilu, firiem, faktúr, výdavkov a zároveň obsahuje gamifikačné prvky ako XP, úrovne, odznaky, denné misie a sériu prihlásení.
Aplikácia je určená najmä pre menších podnikateľov alebo používateľov, ktorí chcú mať prehľad o svojich firmách, faktúrach a výdavkoch. Okrem základnej správy obsahuje aj motivačný systém, kde používateľ získava XP, odznaky a odmeny za pravidelné používanie aplikácie.

## Požiadavky

Na spustenie aplikácie je potrebné mať nainštalované:

- Ruby
- Ruby on Rails
- PostgreSQL
- Node.js / npm

## Spustenie aplikácie

Najprv je potrebné nainštalovať závislosti:

```bash
bundle install
npm install
```

Potom pripraviť databázu:

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```
Databázu seedujeme len ak chceme demo ukážkový profil.

Server sa spúšťa s príkazom
```bash
bin/dev
```

## Súborová štruktúra aplikácie

```bash
.
├── app/
│   ├── assets/              # štýly a statické assety aplikácie
│   ├── controllers/         # Ruby controllery
│   ├── helpers/             # pomocné metódy pre views
│   ├── javascript/          # JavaScript a Stimulus controllery
│   ├── mailers/             # e-mailová komunikácia
│   ├── models/              # modely a aplikačná logika
│   └── views/               # ERB šablóny používateľského rozhrania
│
├── bin/                     # spúšťacie skripty Rails aplikácie
├── config/                  # konfigurácia aplikácie, routy, prostredia
├── db/
│   ├── migrate/             # databázové migrácie
│   └── schema.rb            # aktuálna schéma databázy
│
├── lib/                     # doplnkové úlohy a pomocné súbory
├── public/                  # verejne dostupné súbory
├── storage/                 # lokálne úložisko súborov
├── test/                    # automatizované testy aplikácie
├── vendor/                  # externé JavaScript knižnice
│
├── Dockerfile               # konfigurácia kontajnera
├── Gemfile                  # Ruby závislosti projektu
├── Gemfile.lock             # uzamknuté verzie závislostí
├── Procfile.dev             # spustenie vývojového prostredia
├── Rakefile                 # definícia Rake úloh
├── README.md                # základný opis projektu
└── config.ru                # Rack konfigurácia aplikácie
```
