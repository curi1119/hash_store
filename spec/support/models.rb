# -*- coding: utf-8 -*-

class User < ActiveRecord::Base
  hash_store
  hash_store :address,
             hash: ->(model){ {address: model.address} }

  hash_store :for_name,
             key: ->(model){ "hoge:#{model.id}" },
             hash: ->(model){ {id: model.id, name: model.name } }
  def name
    "#{self.first_name} #{self.last_name}"
  end

end

class Cat < ActiveRecord::Base
end

class Player
  include HashStore
  hash_store nil,
             key: ->(ins){ "player:#{ins.id}" },
             hash: ->(ins){ {body: ins.body} }
  hash_store :for_name,
             key: ->(ins){ "player:#{ins.name}:#{ins.id}" },
             hash: ->(ins){ {name: ins.name} }

  def id
    1
  end

  def name
    "Curi"
  end

  def body
    "hello world"
  end
end

class ThisIsErrro1
  include HashStore
  hash_store
end
class ThisIsErrro2
  include HashStore
  hash_store :name
end
class ThisIsErrro3
  include HashStore
  hash_store :address, hash: ->(ins){ ins.address }
  def address
    "Tokyo, Japan"
  end
end
class ThisIsErrro4
  include HashStore
  hash_store :address, key: ->(ins){ "error:#{ins.id}" }
  def id
    1
  end
end
