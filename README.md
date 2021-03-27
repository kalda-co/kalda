# Kalda

This is the Kalda app, a web application with a back-end written in Elixir
using a PostgresQL database, and a front-end written in Svelte and
TypeScript.

It is deployed to <https://kalda.co> using <https://render.com>.

## Quick reference

```shell
# Install deps
npm install
mix deps.get

# Prepare the database
mix ecto.setup

# Run the test watchers
npm test
mix test.watch

# Start all components locally
npm start
```

## Useful links

- [Local developer setup](docs/developer-setup.md) documentation.
