# -*- coding: utf-8 -*-
require 'spec_helper'

describe HashStore do

  context "ActiveRecord Model with hash_store" do
    let!(:user){ create(:user) }

    subject{ user }
    it{ should respond_to(:set_hash!) }
    it{ should respond_to(:get_hash) }
    it{ should respond_to(:del_hash!) }
    it{ should respond_to(:exists_hash?) }

    it{ should respond_to(:set_hash_for_name!) }
    it{ should respond_to(:get_hash_for_name) }
    it{ should respond_to(:del_hash_for_name!) }
    it{ should respond_to(:exists_hash_for_name?) }
  end

  context "ActiveRecord Model without hash_store" do
    let!(:cat){ create(:cat) }

    subject{ cat }
    it{ should_not respond_to(:set_hash!) }
    it{ should_not respond_to(:get_hash) }
    it{ should_not respond_to(:del_hash!) }
    it{ should_not respond_to(:exists_hash?) }
  end

  context "Regular Class with hash_store" do
    let!(:player){ Player.new }

    subject{ player }
    it{ should respond_to(:set_hash!) }
    it{ should respond_to(:get_hash) }
    it{ should respond_to(:del_hash!) }
    it{ should respond_to(:exists_hash?) }

    it{ should respond_to(:set_hash_for_name!) }
    it{ should respond_to(:get_hash_for_name) }
    it{ should respond_to(:del_hash_for_name!) }
    it{ should respond_to(:exists_hash_for_name?) }
  end

  context "Regular Class with invalid hash_store arguments" do
    [ThisIsErrro1, ThisIsErrro2, ThisIsErrro3, ThisIsErrro4].each do |klass|
      subject{ klass.new }
      it{ should_not respond_to(:set_hash!) }
      it{ should_not respond_to(:get_hash) }
      it{ should_not respond_to(:del_hash!) }
      it{ should_not respond_to(:exists_hash?) }
    end
  end

end
