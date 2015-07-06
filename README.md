# Codeland::Starter

[![Gem Version](https://badge.fury.io/rb/codeland-starter.svg)](http://badge.fury.io/rb/codeland-starter)
[![Code Climate](https://codeclimate.com/github/codelandev/codeland-starter/badges/gpa.svg)](https://codeclimate.com/github/codelandev/codeland-starter) [![Build Status](https://travis-ci.org/codelandev/codeland-starter.svg?branch=master)](https://travis-ci.org/codelandev/codeland-starter) [![Test Coverage](https://codeclimate.com/github/codelandev/codeland-starter/badges/coverage.svg)](https://codeclimate.com/github/codelandev/codeland-starter)

Create [Ruby on Rails](http://rubyonrails.org/) projects based on [Codeland's](http://codeland.com.br) template with [integrations](#integrations).

## Installation

```sh
$ gem install codeland-starter
```

## Usage

### Setup

```sh
$ codeland-starter install # Will create ~/codeland-starter.yml
$ vi ~/codeland-starter.yml
```

The `integrations` section in YAML is an array of the services. Eg:
```yaml
integrations:
  - heroku
  - another-service
```

### Create projects

```sh
$ codeland-starter create ProjectName
```

## What do you (can) get?

- PostgreSQL
- Ruby version in Gemfile
- [Slim](http://slim-lang.com/)
- Skip Rails generators (javascripts, stylesheets, helpers)
- Brazilian time and locale
- Front-end setup
- [Heroku](https://www.heroku.com/) setup
- Gems:
  - [RSpec](http://rspec.info/)
  - [Factory girl](https://github.com/thoughtbot/factory_girl_rails)
  - [Simplecov](https://github.com/colszowka/simplecov)
  - [Database cleaner](https://github.com/DatabaseCleaner/database_cleaner)
  - [Shoulda matchers](https://github.com/thoughtbot/shoulda-matchers)
  - [Cabybara](http://jnicklas.github.io/capybara/)
  - [Selenium](https://rubygems.org/gems/selenium-webdriver)
  - [Initjs](https://github.com/josemarluedke/initjs)
  - [Rails-i18n](https://github.com/svenfuchs/rails-i18n)
  - [Devise](https://github.com/plataformatec/devise)
  - [ActiveAdmin](https://github.com/gregbell/active_admin)
  - [Simpleform](https://github.com/plataformatec/simple_form)
  - [Pundit](https://github.com/elabs/pundit)
  - [Autoprefixer-rails](https://github.com/ai/autoprefixer-rails)
  - [Bootstrap](https://github.com/twbs/bootstrap-sass)
  - [Font-awesome](https://github.com/bokmann/font-awesome-rails)
  - [NProgress](https://github.com/caarlos0/nprogress-rails)
  - [Draper](https://github.com/drapergem/draper)
  - [Rails 12factor](https://github.com/heroku/rails_12factor)
  - [Thin](http://code.macournoyer.com/thin/) (development)
  - [Rack Profiler](https://github.com/MiniProfiler/rack-mini-profiler) (development)
  - [Passenger](https://www.phusionpassenger.com/) (production)

## Integrations

### Heroku

```sh`
$ heroku plugins:install git@github.com:heroku/heroku-oauth.git
$ heroku authorizations:create -d "some text"
```
Paste the `Token` in `codeland-starter.yml`

```yaml
heroku:
  oauth_token: PASTE-YOUR-TOKEN-HERE
```

## Contributing

1. Fork it ( https://github.com/codelandev/codeland-starter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
