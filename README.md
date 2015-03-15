# Codeland::Starter

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

## Integrations

### Heroku

```sh`
$ heroku plugins:install git@github.com:heroku/heroku-oauth.git
$ heroku authorizations:create -d "some text"
```
Paste the `Token` in

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
