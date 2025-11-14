# Repository Guidelines

## Project Structure & Module Organization
Phoenix domain code lives in `lib/namegate`, while the web boundary (controllers, LiveViews, plugs, components) lives in `lib/namegate_web`. Front-end assets sit in `assets/` (Tailwind config, JS entry points, esbuild bundling) and feed the digests produced via `mix assets.deploy`. Database migrations reside in `priv/repo/migrations`, seed data in `priv/repo/seeds.exs`, and tests mirror the lib layout under `test/` with helpers in `test/support`.

## Build, Test, and Development Commands
- `mix setup` installs dependencies, builds assets, creates/migrates the dev database, and seeds baseline data.
- `mix phx.server` (or `iex -S mix phx.server`) boots the Bandit-backed endpoint on `localhost:4000`.
- `mix ecto.setup`, `mix ecto.migrate`, and `mix ecto.reset` manage the Postgres schema; run them before touching data models.
- `mix assets.build` compiles Tailwind and esbuild pipelines; `mix assets.deploy` runs the minified build plus `phx.digest` for releases.

## Coding Style & Naming Conventions
Follow idiomatic Elixir: two-space indentation, snake_case module files, PascalCase module names, and descriptive function names. Keep contexts focused and colocate schemas, changesets, and related logic within their context directory. Run `mix format` before commits; the repo relies on the default `.formatter.exs`. Client assets should follow Tailwind conventions and keep shared styles under `assets/css`.

## Testing Guidelines
ExUnit is the default; tests live beside their target module using the `*_test.exs` suffix. Database tests rely on the SQL sandbox established in `test/test_helper.exs`, so wrap async: true only when no DB access occurs. Run `mix test` for the full suite, or scope by file path (e.g., `mix test test/namegate_web/controllers/user_controller_test.exs`).

## Commit & Pull Request Guidelines
The repository has no recorded history yet, so begin with concise, imperative commit subjects such as `Add customer context` or `Fix LiveView form validation`, followed by a blank line and wrapped body text where needed. Each pull request should describe the change, reference Mix tasks or scripts run, link any tracking issue, and include screenshots for LiveView/UI updates. Highlight database or config migrations explicitly so reviewers know when to run `mix ecto.migrate`.

## Security & Configuration Tips
Runtime secrets (database credentials, mailers, external API keys) should be injected via environment variables consumed in `config/runtime.exs`. Never commit `.env` files or personal secrets. Use `config/dev.exs` for per-developer overrides (e.g., watchers, dashboards) and call out any required OS services such as Postgres in the PR description.
