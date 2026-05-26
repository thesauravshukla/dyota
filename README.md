# Dyota

Textile fabric commerce app (Flutter, mobile-first) for discovering and ordering fabrics across categories such as Ethnic, Ladies Wear, Shirting, and Suiting.

V1 supports browse, search, design/color variants, sample and length-based orders, cart, addresses, and order history. In-app payment is out of scope; orders are confirmed offline.

## Repo layout

```
dyota/
  pubspec.yaml              Flutter project manifest
  analysis_options.yaml     Lints
  .gitignore
  assets/
    images/                 Product imagery, banners
    icons/                  App icons, custom glyphs
    fonts/                  Bundled fonts
  lib/
    main.dart               Entry point
    app.dart                MaterialApp shell
    core/                   Cross-cutting infra (no UI)
      config/               Build/env config, flags
      network/              HTTP client, interceptors
      routing/              Router setup, route guards
      storage/              Secure storage, prefs
      theme/                Colors, typography, spacing
      utils/                Generic helpers
    data/                   Data layer (shared)
      models/               DTOs / entities
      repositories/         Data-access abstractions
      sources/              Remote and local sources
    features/               Feature-first modules
      auth/                 Sign up, login, logout
      home/                 Hero, featured, quick links
      search/               Keyword search + results
      catalog/              Categories, listing, filters, sort
      product/              PDP (design + color variant)
      cart/                 Cart items (sample / length)
      checkout/             Address select, place order
      addresses/            CRUD shipping addresses
      orders/               Order history, details, status
    shared/
      widgets/              Reusable UI components
  test/                     Unit + widget tests
  integration_test/         End-to-end flows
  docs/                     PRD, ADRs, API specs
```

Each `features/<name>/` follows the same shape:

```
<feature>/
  screens/        Route-level pages
  widgets/        Feature-scoped widgets
  controllers/    Riverpod providers / notifiers
```

State management: **Riverpod** (`flutter_riverpod`). The app is wrapped in a `ProviderScope` in `lib/main.dart`. Feature-local providers live under `lib/features/<feature>/controllers/`; cross-cutting providers (e.g. HTTP client, auth session) belong in `lib/core/`.

## Conventions

- Feature-first: a feature owns its screens, widgets, and state. Cross-feature code lives in `core/`, `data/`, or `shared/`.
- `core/` has no UI; `shared/widgets/` has UI but no business logic.
- Models and repositories that span features live in `lib/data/`. Feature-only types stay inside the feature.

## Status

Skeleton only. Platform folders (`android/`, `ios/`, `web/`) are not yet generated. Run `flutter create .` from the repo root once Flutter is installed to add them, then `flutter pub get`.
