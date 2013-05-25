# HashStore

HashStore store RubyHash on Redis as JSON.
HashStore was designed to work with ActiveRecord, but also work with Non-ActiveRecord Class.

## Installation

Add this line to your application's Gemfile:

    gem 'hash_store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_store

## Getting Start

Create redis connection, and pass it to HashStore.

For Rails apps example:

config/initializers/redis.rb
```ruby
redis = Redis.new(host: "192.168.1.1", port: 6380)
HashStore::Config.redis = redis
```

## Usage

### For Rails example:

```ruby
class User < ActiveRecord::Base
  hash_store
  hash_store :address,
             hash: ->(model){ {address: model.address} }

  hash_store :for_name,
             key: ->(model){ "hoge:#{model.id}" },
             hash: ->(model){ {id: model.id, name: model.name } }
```

User instance will gain theses methods:
* hash_store
```
User#hash_store_key   # => "users:1"
User#set_hash!        # => SET command for this instance.
User#get_hash!        # => GET command for this instance.
                           nil if key not found.
                           return hash(like {"address"=>"Nagoya, Japan", "first_name"=>"Hoge", "id"=>7, "last_name"=>"Foo"})
User#del_hash!        # => DEL command for this instance.
User#exists_hash?     # => true if key present on redis, false otherwise.
```
* hash_store :address
```
User#hash_store_key_address   # => "users:address:8"
User#set_hash_address!
User#get_hash_address!        # => GET command for this instance.
                                   nil if key not found.
                                   return hash(like {"address"=>"Nagoya, Japan"}
User#del_hash_address!
User#exists_hash_address?
```
* hash_store :for_name
```
User#hash_store_key_for_name   # => "hoge:10"
User#set_hash_for_name!
User#get_hash_for_name!        # => GET command for this instance.
                                    nil if key not found.
                                    return hash(like {"id"=>16, "name"=>"Hoge Foo"})
User#del_hash_for_name!
User#exists_hash_for_name?
```


### For Non-ActiveRecord class example:

```ruby
class Player
  include HashStore
  hash_store nil,
             key: ->(ins){ "player:#{ins.id}" },
             hash: ->(ins){ {body: ins.body} }
  hash_store :for_name,
             key: ->(ins){ "player:#{ins.name}:#{ins.id}" },
             hash: ->(ins){ {name: ins.name} }
```
(same as above)
