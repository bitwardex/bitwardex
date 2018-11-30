# Bitwardex
[![CircleCI](https://circleci.com/gh/bitwardex/bitwardex.svg?style=svg)](https://circleci.com/gh/bitwardex/bitwardex)

*(This project is not associated with the
[Bitwarden](https://bitwarden.com/)
project nor 8bit Solutions LLC.)*

Elixir version of the Bitwarden server

## Set up

First of all, fetch all dependencies in the usual way:

```
$ mix deps.get
```

And you have to create you own secrets using the example files:

```
$ cp apps/bitwardex/config/dev.secret.example.exs apps/bitwardex/config/dev.secret.exs
$ cp apps/bitwardex/config/test.secret.example.exs apps/bitwardex/config/test.secret.exs
```

These files include, among other things, the credentials to access your local
development and test database. Default configuration should be enough in most
cases.

Now you can create the database and run migrations:

```
$ mix ecto.create
$ mix ecto.migrate
```

### Web Vault

If you want to use the web vault, you should the the script that downloads and
builds it:

```
$ cd apps/bitwardex_web
$ bash download_web_client.sh
```

The code downloaded is from official web vault repository, so they are open
source contributions of 8bit Solutions LLC. and their collaborators, not being
included or distributed directly with this project.

Any logo or trademark included in the web vault remains property of their
legal owner and serving them from this projects means no attribution from
Bitwardex.

## Start the project

If you have followed the setup instructions, you can start the server running:

```
mix phx.server
```

and access [http://localhost:4000](http://localhost:4000).

## Data storage

This projects stores the data ina PostgreSQL database in the same format as
specified by Bitwarden official documentation, which means that *neither the
master password or the clear data* is transmitted or stored on the server.

All encoding operations happen at the client, so if you lose the master password
your data will be lost, as it happens in the official servers.
