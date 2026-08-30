# Features

Each feature is a self-contained vertical slice with its own three layers.
Dependencies only point inward: `presentation -> domain <- data`. Domain
never imports from `data` or `presentation`.

```
features/
  <feature_name>/
    data/
      datasources/     # remote (Dio) / local (SharedPreferences) sources
      models/           # DTOs, extend domain entities, (de)serialization
      repositories/     # implements the domain repository contract
    domain/
      entities/         # plain Dart classes (Equatable), no framework deps
      repositories/      # abstract contracts, implemented in data/
      usecases/          # one class per action, extends UseCase (core/usecase)
    presentation/
      providers/         # Riverpod providers/notifiers for this feature
      pages/              # screens (routed to from core/router)
      widgets/            # feature-local widgets
```

Shared, feature-agnostic code (theme, router, error types, network client,
base use case, DI helpers) lives in `lib/core/` instead.
