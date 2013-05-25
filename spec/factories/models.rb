# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :user do
    first_name "Hoge"
    last_name "Foo"
    address "Nagoya, Japan"
  end
end

FactoryGirl.define do
  factory :cat do
    name "Rock"
  end
end
