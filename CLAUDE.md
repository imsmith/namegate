# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Namegate is a Phoenix web application built with Elixir. This is an early-stage project following standard Phoenix 1.7+ conventions with LiveView support.

## Development Commands

### Initial Setup
```bash
mix setup
```
Installs dependencies, creates database, runs migrations, and builds assets.

### Running the Application
```bash
mix phx.server
```
Starts server at http://localhost:4000

For interactive development with IEx:
```bash
iex -S mix phx.server
```

### Testing
```bash
# Run all tests
mix test

# Run specific test file
mix test test/path/to/test_file.exs

# Run specific test by line number
mix test test/path/to/test_file.exs:42

# Run tests with coverage
mix test --cover
```

Tests use Ecto.Adapters.SQL.Sandbox for database isolation. The test database is automatically created and migrated when running tests (see mix.exs aliases).

### Database Operations
```bash
# Create database
mix ecto.create

# Run migrations
mix ecto.migrate

# Rollback last migration
mix ecto.rollback

# Reset database (drop, create, migrate, seed)
mix ecto.reset

# Generate a new migration
mix ecto.gen.migration migration_name
```

### Code Quality
```bash
# Format code
mix format

# Check if code is formatted
mix format --check-formatted
```

### Asset Management
```bash
# Install asset tools (Tailwind, esbuild)
mix assets.setup

# Build assets for development
mix assets.build

# Build assets for production (minified)
mix assets.deploy
```

## Project Architecture

### Application Structure

**Core Application (`lib/namegate/`)**
- `application.ex` - OTP application supervisor tree that starts:
  - Telemetry for metrics
  - Ecto Repo for database
  - DNSCluster for distributed deployments
  - Phoenix.PubSub for real-time messaging
  - Finch HTTP client (for email sending)
  - Phoenix Endpoint (must be last)
- `repo.ex` - Ecto repository for database operations
- `mailer.ex` - Email delivery module (uses Swoosh)
- Business contexts will be added here as the application grows

**Web Interface (`lib/namegate_web/`)**
- `endpoint.ex` - Phoenix endpoint (entry point for all HTTP requests)
- `router.ex` - Route definitions with `:browser` and `:api` pipelines
- `telemetry.ex` - Application metrics and monitoring
- `gettext.ex` - Internationalization support
- `components/` - Reusable UI components
  - `core_components.ex` - Standard Phoenix UI components (buttons, forms, tables, etc.)
  - `layouts.ex` - Application layouts (root, app)
- `controllers/` - Traditional Phoenix controllers
- LiveViews will be added in `lib/namegate_web/live/` as features are developed

### Web Module Pattern

The `NamegateWeb` module (lib/namegate_web.ex) provides `use` macros that inject common functionality:
- `use NamegateWeb, :controller` - For controllers
- `use NamegateWeb, :live_view` - For LiveViews
- `use NamegateWeb, :live_component` - For LiveComponents
- `use NamegateWeb, :html` - For HTML helpers and components
- `use NamegateWeb, :router` - For router definitions

These macros automatically import appropriate modules, aliases, and helpers.

### Configuration

Phoenix uses environment-specific configuration:
- `config/config.exs` - Base configuration (Ecto repos, endpoint, assets)
- `config/dev.exs` - Development (database, live reload, dev routes)
- `config/test.exs` - Test environment (test database, logging)
- `config/prod.exs` - Production base config
- `config/runtime.exs` - Runtime configuration (loaded at startup, good for environment variables)

Database configuration:
- Dev: `namegate_dev` database on localhost
- Test: `namegate_test` database with connection pooling via SQL.Sandbox
- Credentials default to `postgres:postgres`

### Frontend Stack

- **Tailwind CSS** - Utility-first CSS framework (configured in assets/tailwind.config.js)
- **esbuild** - JavaScript bundler (entry point: assets/js/app.js)
- **Phoenix LiveView** - Real-time server-rendered HTML
- **Heroicons** - Icon library (v2.1.1, included as sparse git dependency)

Asset compilation watches for changes in development and auto-reloads the browser.

### Phoenix Generators

Phoenix provides generators to scaffold code. Common ones:
```bash
# Generate a context with schema and migrations
mix phx.gen.context Accounts User users email:string

# Generate LiveView CRUD interface
mix phx.gen.live Accounts User users email:string name:string

# Generate JSON API
mix phx.gen.json Accounts User users email:string

# Generate HTML controllers and views
mix phx.gen.html Accounts User users email:string
```

### Development Tools Available

- **Phoenix LiveDashboard** - Available at http://localhost:4000/dev/dashboard in development
- **Swoosh Mailbox** - Email preview at http://localhost:4000/dev/mailbox in development
- **Live Reload** - Automatic browser refresh on file changes
- **HEEx Debug Annotations** - HTML comments showing template source in development

## Important Conventions

### Phoenix Context Pattern
Business logic should be organized into contexts (modules that group related functionality). Each context typically:
- Lives in `lib/namegate/context_name.ex`
- Provides a public API for the domain
- Encapsulates Ecto queries and changesets
- Is used by web controllers/LiveViews (which should NOT directly call Repo)

### Route Helpers
Phoenix 1.7+ uses verified routes with the `~p` sigil instead of traditional route helpers:
```elixir
~p"/users/#{user}"  # Good
user_path(@conn, :show, user)  # Old style, not used
```

### LiveView Lifecycle
When creating LiveViews:
- `mount/3` is called on initial page load and LiveView connection
- `handle_params/3` handles URL parameters and updates
- `handle_event/3` handles client events
- `handle_info/2` handles async messages

### Testing Patterns
- `test/support/conn_case.ex` - Test case for controllers
- `test/support/data_case.ex` - Test case for schemas and contexts
- Use `Ecto.Adapters.SQL.Sandbox` for test isolation (already configured)

### Code Formatting
The project uses Elixir's formatter with Phoenix-specific plugins. The `.formatter.exs` includes:
- `Phoenix.LiveView.HTMLFormatter` for HEEx templates
- Import dependencies from `:ecto`, `:ecto_sql`, `:phoenix`
- Formats `.heex`, `.ex`, `.exs` files

Always run `mix format` before committing code.
