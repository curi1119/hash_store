# -*- coding: utf-8 -*-
require 'coveralls'
require 'pry'
require 'factory_girl'
require 'active_record'
require 'mock_redis'
require 'hash_store'
Coveralls.wear!

ActiveRecord::Base.configurations = YAML::load(ERB.new(IO.read(File.dirname(__FILE__) + "/db/database.yml")).result)
ActiveRecord::Base.establish_connection("sqlite3")
ActiveRecord::Migration.verbose = false
load(File.join(File.dirname(__FILE__), "db", "schema.rb"))

require 'support/models'
require 'factories/models'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  # config.filter_run :focus

  config.include FactoryGirl::Syntax::Methods
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'


  config.before(:each) { HashStore::Config.redis.flushdb }
end
$redis = MockRedis.new
HashStore::Config.redis = $redis
