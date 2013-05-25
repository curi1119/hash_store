# -*- coding: utf-8 -*-
require "redis"
require "multi_json"
require "hash_store/version"
require "hash_store/base"

module HashStore

  def self.included(base)
    base.send :extend, HashStore::Base::ClassMethods
  end

  module Config
    class << self

      def redis=(redis)
        @@redis = redis
        @@redis.ping
      end

      def redis
        if !defined?(@@redis) || @@redis.nil?
          raise 'no redis'
        end
        @@redis
      end
    end
  end
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, HashStore
end
