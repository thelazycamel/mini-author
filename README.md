# Local Author

A Rails 7 learning object and structure management tool for the Magnet platform. Allows uploading learning objects to external content delivery sites and structure XML files to the importer service.

## Setup

```bash
docker compose build local_author
docker compose run --rm local_author bundle exec rails db:migrate db:seed
docker compose up local_author
```

Available at: https://local-author.magnet.test

## Running Tests

```bash
docker compose run --rm local_author bundle exec rspec
```

## Features

- **Sites** — Configure external content delivery endpoints
- **Learning Objects** — Upload LO files (SCORM packages) to external sites
- **Structures** — Upload structure XML files to the importer service

## Generating a Bearer Token for the Importer

The importer's structures API requires JWT authentication. To generate a long-lived token for local development:

1. Open a Rails console in the **platform** service:

```bash
docker compose run --rm platform bundle exec rails console
```

2. Generate a token:

```ruby
user = Unity::Core::User.find_by(email: "operator@default") # use your admin user
app = Unity::Core::ExternalApplicationsRepository.new.find_by_id_or_name("importer")
token = Magnet::Core::Shared::JwtTokensService.new.encode_token(
  app.application_id,
  user: user,
  expires_in_seconds: 1.year.to_i
)
puts token
```

3. Copy the output token and paste it into the **API Token** field when editing a Site in Local Author.

> **Note:** Tokens expire. If you get 401 errors after a while, regenerate the token using the steps above.

### Alternative: Extract from Browser

If you're already logged into the platform frontend:

1. Open browser DevTools (Network tab)
2. Make any API request in the platform UI
3. Find the request's `Authorization` header
4. Copy the Bearer token value (everything after "Bearer ")
5. Paste it into the Site's API Token field

These tokens are short-lived (15 minutes by default), so the Rails console method above is preferred for local dev.

## Environment

- Ruby 3.3, Rails 7.2
- PostgreSQL, Redis
- Runs on port 8084 within the docker-compose stack
