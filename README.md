# Context.IO

* [Homepage](https://github.com/benhamill/contextio#readme)
* [API Documentation](http://context.io/docs/2.0/)
* [Sign Up](http://context.io)

## Description

Provides a Ruby interface to [Context.IO](http://context.io). The general design
was inspired by the wonderful [aws-sdk](https://github.com/aws/aws-sdk-ruby)
gem. You start with an object that represents your account with Context.IO and
then you deal with collections within that going forward. See the example, for
more detail.

## Example

```ruby
require 'contextio'

contextio = ContextIO.new('your_api_key', 'your_api_secret')

account = contextio.accounts.where(email: 'some@email.com').first

account.email_addresses # ['some@email.com', 'another@email.com']
account.first_name # 'Bruno'

account.messages.where(folder: '\Drafts').each do |m|
  puts m.subject
end
```

## Install

    $ gem install contextio

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
