# Kalda

This is the Kalda app, a web application with a back-end written in Elixir
using a PostgresQL database, and a front-end written in Svelte and
TypeScript.

It is deployed to <https://kalda.co> using <https://render.com>.

## Quick reference

```shell
# Install deps
npm run setup

# Run the test watchers
cd frontend && npm test
cd backend && mix test.watch

# Start all components locally
npm start
```

## Useful links

- [Local developer setup](docs/developer-setup.md) documentation.

## Deployment

Production is automatically deployed from the main branch.

To deploy to [staging](https://staging.kalda.co) run `bin/deploy-to-staging` and then wait for the build to complete. View progress [here](https://dashboard.render.com/web/srv-c1evsabjbvm0e3g1gvj0).
