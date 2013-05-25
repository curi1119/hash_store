# -*- coding: utf-8 -*-
require 'spec_helper'

describe HashStore::Base do


  context "hash_store on User Model without options" do
    let!(:user){ create(:user) }

    context "class methods on User" do
      it{ User.hash_store_key.should be_instance_of(Proc) }

      describe ".get_hash" do
        it { User.get_hash("users:#{user.id}").should be_nil }

        context "After SET" do
          before { user.set_hash! }
          it{ User.get_hash("users:#{user.id}").should == user.as_json(root: false, except: [:created_at, :updated_at]) }
        end
      end
    end

    it { user.hash_store_key.should == "users:#{user.id}" }

    describe "#set_hash!" do
      before { user.set_hash! }
      subject { $redis.get("users:#{user.id}") }
      it {
        should == user.to_json(root: false, except: [:created_at, :updated_at]) }
    end

    describe "#get_hash" do
      it { user.get_hash.should be_nil }

      context "After SET" do
        before { user.set_hash! }
        it{ user.get_hash.should == user.as_json(root: false, except: [:created_at, :updated_at]) }
      end
    end

    describe "#del_hash!" do
      before {
        user.set_hash!
        user.del_hash!
      }
      it { $redis.get("users:#{user.id}").should be_nil }
    end

    describe "#exists_hash?" do
      it { user.exists_hash?.should be_false }

      context "After SET" do
        before { user.set_hash! }
        it { user.exists_hash?.should be_true }
      end
    end
  end

  context "hash_store on User Model with options" do
    let!(:user){ create(:user) }

    context "class methods on User" do
      it{ User.hash_store_key_for_name.should be_instance_of(Proc) }

      describe ".get_hash_for_name" do
        it { User.get_hash_for_name("hoge:#{user.id}").should be_nil }

        context "After SET" do
          before { user.set_hash_for_name! }
          it{ User.get_hash_for_name("hoge:#{user.id}").should == user.as_json(root: false, only:[:id, ], methods: ["name"]) }
        end
      end
    end

    it { user.hash_store_key_for_name.should == "hoge:#{user.id}" }

    describe "#set_hash_for_name!" do
      before { user.set_hash_for_name! }
      subject { $redis.get("hoge:#{user.id}") }
      it { should == user.to_json(root: false, only:[:id], methods: [:name]) }
    end

    describe "#get_hash" do
      it { user.get_hash_for_name.should be_nil }

      context "After SET" do
        before { user.set_hash_for_name! }
        it{ user.get_hash_for_name.should == user.as_json(root: false, only:[:id, ], methods: ["name"]) }
      end
    end

    describe "#del_hash!" do
      before {
        user.set_hash_for_name!
        user.del_hash_for_name!
      }
      it { $redis.get("users:#{user.id}").should be_nil }
    end

    describe "#exists_hash_for_name?" do
      it { user.exists_hash_for_name?.should be_false }

      context "After SET" do
        before { user.set_hash_for_name! }
        it { user.exists_hash_for_name?.should be_true }
      end
    end
  end

  context "hash_store on User Model with name, witout key options" do
    let!(:user){ create(:user) }

    context "when name is passed, and key option hadn't passed" do
      it { user.hash_store_key_address.should == "users:address:#{user.id}" }
    end

    context "hash option should work fine" do
      before { user.set_hash_address! }
      it{ user.get_hash_address.should == { 'address' => user.address } }
    end
  end

  context "hash_store on Player Model without options" do
    let!(:player){ Player.new }

    context "when name is nil" do
      before { player.set_hash! }
      it { player.get_hash.should == {'body' => 'hello world'} }
      it {
        player.del_hash!
        player.get_hash.should be_nil
      }
      it { player.hash_store_key.should == 'player:1' }
    end

    describe "#set_hash_for_name!" do
      before { player.set_hash_for_name! }
      it { player.get_hash_for_name.should == {'name' => 'Curi'} }
      it {
        player.del_hash_for_name!
        player.get_hash_for_name.should be_nil
      }
      it { player.hash_store_key_for_name.should == 'player:Curi:1' }
    end
  end


end
