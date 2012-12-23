# Context.IO

* [Homepage](https://github.com/contextio/contextio-ruby#contextio)
* [API Documentation](http://context.io/docs/2.0/)
* [Sign Up](http://context.io)

## Description

Provides a Ruby interface to [Context.IO](http://context.io). The general design
was inspired by the wonderful [aws-sdk](https://github.com/aws/aws-sdk-ruby)
gem. You start with an object that represents your account with Context.IO and
then you deal with collections within that going forward. Check out the example.

If you're looking at the Context.IO docs, it is important to note that there are
some attributes that've been renamed to be a bit more Ruby-friendly. In general,
if the API returns a number meant to be seconds-from-epoch, then it's been
converted to return a `Time` (e.g. `updated` has changed to `updated_at`) and a
boolean has converted to something with a `?` at the end (e.g. `HasChildren` and
`initial_import_finished` are `has_children?` and `initial_import_finished?`,
respectively).

## Example

```ruby
require 'contextio'

contextio = ContextIO.new('your_api_key', 'your_api_secret')

account = contextio.accounts.where(email: 'some@email.com').first

account.email_addresses # ['some@email.com', 'another@email.com']
account.first_name # 'Bruno'
account.suspended? # False

account.messages.where(folder: '\Drafts').each do |m|
  puts m.subject
end
```

## Install

    $ gem install contextio

Or, of course, put this in your Gemfile:

    gem contextio

## Version Numbers

This gem adheres to [SemVer](http://semver.org/). So you should be pretty safe
upgrading from 1.0.0 to 1.9.9. Whatever as long as the major version doesn't
bump. When the major version bumps, be warned; upgrading will take some kind of
effort.

## Contributing

Help is gladly welcomed. If you have a feature you'd like to add, it's much more
likely to get in (or get in faster) the closer you stick to these steps:

1. Open an Issue to talk about it. We can discuss whether it's the right
  direction or maybe help track down a bug, etc.
1. Fork the project, and make a branch to work on your feature/fix. Master is
  where you'll want to start from.
1. Turn the Issue into a Pull Request. There are several ways to do this, but
  [hub](https://github.com/defunkt/hub) is probably the easiest.
1. Make sure your Pull Request includes tests.

If you don't know how to fix something, even just a Pull Request that includes a
failing test can be helpful. If in doubt, make an Issue to discuss.

## Copyright

Copyright (c) 2012 Context.IO

See LICENSE.md for details.
