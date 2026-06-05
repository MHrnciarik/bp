# Webová plikácia Funance

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

Použité technológie:
  Ruby on Rails
  PostgreSQL
  Tailwind CSS
  DaisyUI
  Hotwire / Turbo

