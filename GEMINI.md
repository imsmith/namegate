# Project Overview

This is a new Phoenix project called `namegate`. It appears to be in the early stages of development, as it currently only contains the default Phoenix welcome page.

**Technologies:**

*   **Backend:** Elixir, Phoenix
*   **Database:** PostgreSQL (using Ecto)
*   **Frontend:** JavaScript (with esbuild) and CSS (with Tailwind CSS)
*   **Testing:** ExUnit

**Architecture:**

The project follows the standard Phoenix project structure.

*   `lib/namegate`: The core application logic.
*   `lib/namegate_web`: The web interface, including controllers, views, and templates.
*   `priv`: Private data, including database migrations and seeds.
*   `config`: Configuration for different environments.
*   `test`: Tests for the application.

# Building and Running

**Setup:**

To set up the project for the first time, run:

```bash
mix setup
```

This will install dependencies, create the database, and run migrations.

**Running the application:**

To start the Phoenix server, run:

```bash
mix phx.server
```

The application will be available at `http://localhost:4000`.

**Testing:**

To run the test suite, use the following command:

```bash
mix test
```

# Development Conventions

The project uses the default Phoenix conventions.

*   **Code Formatting:** The project uses the Elixir formatter. You can format the code by running `mix format`.
*   **Testing:** Tests are located in the `test` directory and follow the standard ExUnit conventions.
*   **Contributions:** There are no explicit contribution guidelines yet.
