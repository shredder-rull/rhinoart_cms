# Rhinoart

Rhinoart is a admin engine system. This a CMS backend

## Installation:

``` ruby
# Gemfile for Rails 4
gem 'rhinoart', git: 'https://github.com/kostyakch/rhinoart_cms.git'
```

## Basic rhinoart use

### Add in Your Gemfile line like this:
``` ruby
gem 'rhinoart', git: 'https://github.com/kostyakch/rhinoart_cms.git'
```

### In routes.rb add:
``` ruby
# Admin URLs
mount Rhinoart::Engine, at: "/admin"
```

After it:

``` ruby
$ rake rhinoart:install:migrations

#and
$ rake db:populate
```
Now You cat login: http://0.0.0.0:3000/admin
login: admin@test.com
password: admin