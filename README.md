# HashStore

[![Gem Version](https://badge.fury.io/rb/hash_store.png)](http://badge.fury.io/rb/hash_store)
[![Build Status](https://travis-ci.org/curi1119/hash_store.png?branch=master)](https://travis-ci.org/curi1119/hash_store)
[![Coverage Status](https://coveralls.io/repos/curi1119/hash_store/badge.png)](https://coveralls.io/r/curi1119/hash_store)
[![Code Climate](https://codeclimate.com/github/curi1119/hash_store.png)](https://codeclimate.com/github/curi1119/hash_store)
[![Dependency Status](https://gemnasium.com/curi1119/hash_store.png)](https://gemnasium.com/curi1119/hash_store)

HashStore store RubyHash into Redis as JSON.

Automatically add redis command(GET,SET,DEL,EXITS) methods to your class.
HashStore was designed to work with ActiveRecord, but also work with Non-ActiveRecord Class.

-

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
see more detail
[schema](https://github.com/curi1119/hash_store/blob/master/spec/db/schema.rb)
[model](https://github.com/curi1119/hash_store/blob/master/spec/support/models.rb)
[sample data](https://github.com/curi1119/hash_store/blob/master/spec/factories/models.rb)

#### Default Behavior
```ruby
  hash_store
```
This is default behavior.
Redis key will be "{table_name}:#{record id}" .
Hash will contain all columns except created_at, updated_at.
```
User#hash_store_key   # => "users:1"
User#set_hash!        # => SET command for this instance.
User#get_hash         # => GET command for this instance.
                           nil if key not found.
                           return hash(like {"address"=>"Nagoya, Japan", "first_name"=>"Hoge", "id"=>7, "last_name"=>"Foo"})
User#get_hash(json: true)  # => If you pass {json: true}, get_hash don't convert json to hash.
                                Its return json string("{\"address\":\"Nagoya, Japan\",\"first_name\":\"Hoge\",\"id\":8,\"last_name\":\"Foo\"}")
User#del_hash!        # => DEL command for this instance.
User#exists_hash?     # => true if key present on redis, false otherwise.

User.hash_store_key       # => returns key proc object.
User.get_hash("users:1")  # => returns same hash as User#get_hash
```

#### Customize Hash
```ruby
   hash_store :address, hash: ->(model){ {address: model.address} }
```
You can customize hash.
```
User#hash_store_key_address   # => "users:address:8"
User#set_hash_address!
User#get_hash_address         # => GET command for this instance.
                                   nil if key not found.
                                   return hash(like {"address"=>"Nagoya, Japan"}
User#del_hash_address!
User#exists_hash_address?

User.hash_store_key_address
User.get_hash_address("users:address:8")  # => returns same hash as User#get_hash_address

```

#### Customize Key and Hash
```ruby
hash_store :for_name,  key: ->(model){ "hoge:#{model.id}" },  hash: ->(model){ {id: model.id, name: model.name } }`
```

And you can specify key for redis.
```
User#hash_store_key_for_name   # => "hoge:10"
User#set_hash_for_name!
User#get_hash_for_name         # => GET command for this instance.
                                    nil if key not found.
                                    return hash(like {"id"=>16, "name"=>"Hoge Foo"})
User#del_hash_for_name!
User#exists_hash_for_name?

User.hash_store_key_for_name
User.get_hash_for_name("hoge:10")  # => returns same hash as User#get_hash_for_name
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

But, you must pass name, options(:key and :hash) arguments to hash_store.
