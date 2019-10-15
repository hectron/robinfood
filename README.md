# Robinfood

This application is mostly a backend for scraping data in a cron,
and posting the choices on a cron.

**It currently does not have a UI, so this is all managed via** `rails_console`.

## Development

You'll need to set the following environment variables:

- `FOODA_USERNAME`
- `FOODA_PASSWORD`

To open up a rails console, you can:

- Copy `docker-compose.override.yml.example` into `docker-compose.override.yml`.
- `./run rails c`

## Scraping

In order to invoke the scraper, you'll need to run the `Scraper::Actions::Scrape`  action.

The scrape action is done on a schedule (see: `config/schedule.yml`).

```ruby
require 'scraper/actions/scrape'

Scraper::Actions::Scrape.new.execute
```

##