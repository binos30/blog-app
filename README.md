# InstaBlog

[![CI/CD](https://github.com/binos30/blog-app/actions/workflows/ci.yml/badge.svg)](https://github.com/binos30/blog-app/actions/workflows/ci.yml)
[![Dependabot Status](https://badgen.net/github/dependabot/binos30/blog-app?icon=dependabot)](https://dependabot.com)

## Setup

Prerequisites

- [Ruby 3.3.5](https://github.com/rbenv/rbenv)
- [PostgreSQL](https://www.postgresql.org/download/)
- [Node.js ^20.15.1](https://github.com/nvm-sh/nvm)

Create `.env` file at the root of the project directory. Copy the content of `.env.template.erb` to `.env` then update the `username` and `password` based on your database credentials. To send a post feedback email to the blog post author, request `SENDGRID_API_KEY` from admin/owner or [create your own SENDGRID_API_KEY](https://docs.sendgrid.com/ui/account-and-settings/api-keys) and [add single sender verification](https://docs.sendgrid.com/ui/sending-email/sender-verification) then update `SENDGRID_FROM_EMAIL` and `SENDGRID_FROM_NAME`

Install dependencies and setup database

```bash
bin/setup
```

Populate database with sample data

```bash
rake db:populate_sample_data
```

Start local web server

```bash
bin/dev
```

Go to [http://localhost:3000](http://localhost:3000)

## Testing

Setup test database

```bash
bin/rails db:test:prepare
```

Default: Run all spec files (i.e., those matching spec/\*\*/\*\_spec.rb)

```bash
bin/rspec
```

Run all spec files in a single directory (recursively)

```bash
bin/rspec spec/models
```

Run a single spec file

```bash
bin/rspec spec/models/post_spec.rb
```

Use the plain-English descriptions to generate a report of where the application conforms to (or fails to meet) the spec

```bash
bin/rspec --format documentation spec/models/post_spec.rb
```

Run a single example from a spec file (by line number)

```bash
bin/rspec spec/models/post_spec.rb:6
```

See all options for running specs

```bash
bin/rspec --help
```
