# -*- coding: utf-8 -*-
ActiveRecord::Schema.define(version: 0) do

  create_table :users do |t|
    t.string :first_name, null: false
    t.string :last_name,  null: false
    t.text   :address
    t.timestamps
  end

  create_table :cats do |t|
    t.string :name, null: false
    t.timestamps
  end
end
