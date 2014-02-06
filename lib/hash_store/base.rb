# -*- coding: utf-8 -*-

module HashStore::Base
  module ClassMethods
    JSON_DUMP_OPTIONS = { mode: :compat, time_format: :ruby    }.freeze
    JSON_LOAD_OPTIONS = { mode: :strict, symbolize_keys: false }.freeze

    def hash_store(name=nil, options={})
      if !defined?(ActiveRecord::Base) || !self.ancestors.include?(ActiveRecord::Base)
        begin
          raise if options[:hash].nil?
          raise if options[:key].nil?
        rescue => e
          print  <<-EOS
When using hash_store on Non-ActiveRecord class, you MUST pass name and options(:key and :hash) arguments.
ex.) hash_store :name, key: ->(ins){ "name_of_key:\#{ins.id}"}, hash: ->(ins){ {address: ins.address} }
EOS
          return
        end
      end

      method_suffix = (name.nil? || name == '') ? '' : "_#{name}"

      if !options[:hash].nil?
        hs_hash_proc = options[:hash]
      else
        hs_hash_proc = ->(model){ model.as_json(root: false, except: [:created_at, :updated_at]) }
      end

      if !options[:key].nil?
        hs_key_proc = options[:key]
      elsif method_suffix != '' && options[:key].nil?
        hs_key_proc  = ->(model){ "#{model.class.table_name}:#{name}:#{model.id}" }
      else
        hs_key_proc  = ->(model){ "#{model.class.table_name}:#{model.id}" }
      end

      class_eval do
        define_method "set_hash#{method_suffix}!" do
          json = ::Oj.dump(hs_hash_proc.call(self), JSON_DUMP_OPTIONS)
          hs_redis.set(hs_key_proc.call(self), json)
        end

        define_method "get_hash#{method_suffix}" do |options=nil|
          self.class.send("get_hash#{method_suffix}", hs_key_proc.call(self), options)
        end

        define_method "del_hash#{method_suffix}!" do
          hs_redis.del(hs_key_proc.call(self))
        end

        define_method "exists_hash#{method_suffix}?" do
          hs_redis.exists(hs_key_proc.call(self))
        end

        define_method "hash_store_key#{method_suffix}" do
          hs_key_proc.call(self)
        end

        def hs_redis
          HashStore::Config.redis
        end
        private :hs_redis

        define_singleton_method "get_hash#{method_suffix}" do |key, options=nil|
          json = HashStore::Config.redis.get(key)
          return nil if json.nil?
          return json if !options.nil? && options[:json]
          ::Oj.load(json, JSON_LOAD_OPTIONS)
        end

        define_singleton_method "hash_store_key#{method_suffix}" do
          hs_key_proc
        end
      end

    end
  end
end
