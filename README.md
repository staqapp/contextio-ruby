# Context.IO

* [Homepage](https://github.com/contextio/contextio-ruby#readme)
* [API Documentation](http://context.io/docs/2.0/)
* [Gem Documentation](http://rubydoc.info/gems/contextio/frames)
* [Sign Up](http://context.io)


## Description

Provides a Ruby interface to [Context.IO](http://context.io). The general design
was inspired by the wonderful [aws-sdk](https://github.com/aws/aws-sdk-ruby)
gem. You start with an object that represents your account with Context.IO and
then you deal with collections within that going forward (see the [Usage
section](#usage)).


## Install

    $ gem install contextio

Or, of course, put this in your Gemfile:

    gem 'contextio'


## A Note On Method Names

If you're looking at the [Context.IO docs](http://context.io/docs/2.0/), it is
important to note that there are some attributes that've been renamed to be a
bit more Ruby-friendly. In general, if the API returns a number meant to be
seconds-from-epoch, then it's been converted to return a `Time` (e.g. `updated`
has changed to `updated_at`) and a boolean has converted to something with a `?`
at the end (e.g. `HasChildren` and `initial_import_finished` are `has_children?`
and `initial_import_finished?`, respectively). See the [gem
docs](http://rubydoc.info/gems/contextio/frames) for a specific class when in
doubt.


## Version Numbers

This gem adheres to [SemVer](http://semver.org/). So you should be pretty safe
upgrading from 1.0.0 to 1.9.9. Whatever as long as the major version doesn't
bump. When the major version bumps, be warned; upgrading will take some kind of
effort.


## Examples

### Quick Start

Print the subject of the first five messages in the some@email.com account.

```ruby
require 'contextio'

contextio = ContextIO.new('your_api_key', 'your_api_secret')

account = contextio.accounts.where(email: 'some@email.com').first

account.messages.where(limit: 5).each do |message|
  puts message.subject
end
```

### Primary Key Queries

To grab some object you already know the primary key for, you'll use the `[]` method like you would for a `Hash` or `Array`. 

This is most helpful for accounts, but works for any resource collection.

```ruby
require 'contextio'

contextio = ContextIO.new('your_api_key', 'your_api_secret')

some_account_id = "513b6b103z697g3148000021"
some_account_id.class # => String

account = contextio.accounts[some_account_id]
message = account.messages[some_message_id]
```

#### Message By Key

```ruby
message = account.messages[some_message_id]

message.message_id # => "513b6b103z697g3148000021"
message.subject # => "My Email's Subject"
message.from.class # => Hash
message.from['email'] # => "from@domain.com"
message.from['name'] # => "John Doe"

message.delete # => true
```

Body content must be accessed through each body part (eg: html, text, etc.). Context.io does not store body content and so each call will source it directly from the mail box associated with the account. This will be slow relative to the context.io API. 

```ruby

message = account.messages[some_message_id]

message.body_parts.class # => ContextIO::BodyPartCollection
message.body_parts.count # => 2

message.body_parts.each do |part|
	puts part.type # => text/plain
	puts part.content # => body content of text/plain body_part 
end
```

#### Account By Key

You may have multiple email addresses associated with a given context.io account. As a result, you need specify which email address or addresses you are referencing ahead of querying for message collections. 

```ruby
account = contextio.accounts[some_account_id]

account.email_addresses # ['some@email.com', 'another@email.com']
account.id # => 512433023f757e5860000111
account.first_name # => 'Bruno'
account.suspended? # => False
```

### Message Collections

#### Query Basics

Queries to Messages return ContextIO::MessageCollection objects which can be iterated on. 

The where method allows you to refine search results based on [available filters](http://context.io/docs/2.0/accounts/messages#get). 

```ruby
account.messages #the 25 most recent messages by default, you can specify a higher limit

account.messages.where(limit: 50) #the 50 most recent messages

account.messages.where(from: 'another@email.com') #recent messages sent to the account by another@email.com

account.messages.where(from: 'third@email.com', subject: 'hello') #multiple parameters accepted in hash format

account.messages.where(from: 'third@email.com', subject: '/h.llo/') #regexp accepted as a string like '/regexp/'

account.messages.where(from: 'third@email.com', subject: '/h.llo/i') #regexp options are supported, the /i case insensitive is often useful
```

#### Querying Dates

Ruby Time objects are supported by this gem and work like so:

```ruby
require 'active_support/all'

date_before = Time.now.utc
date_after = Time.now.utc - 10.days

date_before.class # => Time
date_after.class # => Time

account.messages.where(date_before: date_before.to_i, date_after: date_after.to_i).each do |message|
	puts "#{message.subject} #{message.date}"
end
```

Here is an example using Unix Epoch integers:

```ruby
require 'date'

before_date_epoc = Date.parse('2013-02-23').to_time.to_i # => 1361599200
after_date_epoc = Date.parse('2013-02-21').to_time.to_i # => 1361426400

before_date_epoc.class # => Fixnum
after_date_epoc.class # => Fixnum

account.messages.where(date_before: before_date_epoc, date_after: after_date_epoc).each do |message|
	puts "#{message.subject} #{message.date}"
end
```

You can mix date and non-date parameters.

```ruby
account.messages.where(date_before: before_date_epoc, date_after: after_date_epoc, subject: 'subject of email', from: 'foo@email.com').each do |message|
		puts "#{message.subject} #{message.date}"
end
```

### Individual Messages

#### Message Basics

```ruby
account.messages.where(limit: 1).class # ContextIO::MessageCollection 

message = account.messages.where(limit: 1).first 

message.class # => ContextIO::Message
message.subject # => "subject of message"
message.date # => 1361828599
Time.at(message.date).strftime('%m-%d-%Y') # => 02-25-2013
```

#### Messages with Body Data

By default, context.io's API does not return message queries with body data. 

You can include the body attribute in each individual message returned and access it by doing this...

```ruby
account.messages.where(include_body: 1, limit: 1).each do |message|
	puts "#{message.subject} #{message.date} #{message.body[0]['content']}"
end
```

If you are working with multipart messages, you will likely want to check each body part's content in turn...

```ruby
account.messages.where(include_body: 1, limit: 1).each do |message|
	message.body_parts.each do |body_part|
		puts body_part.content
	end
end
```

include_body calls query the IMAP box directly and result in slower return times. 

### Files 

#### Files Per Message ID

```ruby
message = account.messages[message_id]

if message.api_attributes['files'].count > 0
  
  message.api_attributes['files'].each do |file|
  
    p file
    
    # {"size"=>10812, 
    #  "type"=>"application/pdf", 
    #  "file_name"=>"My_File.pdf", 
    #  "file_name_structure"=>[["My_File", "main"], [".pdf", "ext"]], 
    #  "body_section"=>"2", 
    #  "content_disposition"=>"attachment", 
    #  "file_id"=>"61ea094526358abe24000005", 
    #  "is_tnef_part"=>false, 
    #  "supports_preview"=>true, 
    #  "main_file_name"=>"Nadine_Henson", 
    #  "is_embedded"=>false, 
    #  "resource_url"=>"https://api.context.io/2.0/accounts/5135fd6af89c484f4c040106/files/62ea0935c6358abe24030004"}
        
    puts file['file_id'] # => 61ea094526358abe24000005
    puts file['file_name'] # => My_File.pdf
    puts file['resource_url'] # => https://api.context.io/2.0/accounts/5135fd6af89c484f4c040106/files/61ea094526358abe24000005
  end
end
```

The file['resource_url'] url is a S3 backed temporary link. It is intended to be used promptly after being called. Do not store off this link. Instead, store off the message_id and request on demand.


### On Laziness

This gem is architected to be as lazy as possible. It won't make an HTTP request
until you ask it for some data that it knows it needs to fetch. An example might
be illustrative:

```ruby
require 'contextio'

contextio = ContextIO.new('your_api_key', 'your_api_secret')

account = contextio.accounts['1234'] # No request made here.
account.last_name # Request made here.
account.first_name # No request made here.
```

Note that when it made the request, it stored the data it got back, which
included the first name, so it didn't need to make a second request. Asking for
the value of any attribute listed in the [gem
docs](http://rubydoc.info/gems/contextio/frames) will trigger the request.


### On Requests and Methods

There are some consistent mappings between the requests documented in the [API
docs](http://context.io/docs/2.0/) and the methods implemented in the gem.

**For collections of resources:**

* the object its self sort of represents the collection-level `GET` (treat it
  like any other `Enumerable`).
* `#where` is how you set up the filters on the collection-level `GET`.
* `#create` maps to the collection-level `POST` or `PUT`, as appropriate.
* `#[]` maps to the individual-level `GET`, but (as mentioned above) is lazy.

**For individual resources**

* the object its self sort of represents the individual-level `GET` (but see
  `#[]` above).
* `#delete` maps to the individual-level `DELETE`.
* `#update` maps to the individual-level `POST` (except in a few cases like
  `Message#copy_to` and `Message#move_to`).


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

Copyright (c) 2012-2013 Context.IO

This gem is distributed under the MIT License. See LICENSE.md for details.
