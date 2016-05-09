require 'spec_helper'

describe "Cartomodel::Model::Synchronizable" do
  it "cannot extend non ActiveRecord models" do
    expect { Class.new.include(Cartomodel::Model::Synchronizable) }.to raise_error(RuntimeError, 'Cartomodel::Synchronizable can only extend ActiveRecord instances')
  end
  it "can extend ActiveRecord models" do
    expect { ArTestClass.new }.to_not raise_error
  end

  it "has cartodb_id and sync_state attributes" do
    expect {
      class NoAttrArTestClass < ActiveRecord::Base
        include Cartomodel::Model::Synchronizable
      end
    }.to raise_error(RuntimeError, 'Cartomodel::Synchronizable requires \'cartodb_id\' and \'sync_state\' attributes')

    expect {
      @attr_instance = ArTestClass.new()
    }.to_not raise_error
    expect(@attr_instance.attributes).to include('cartodb_id')
    expect(@attr_instance.attributes).to include('sync_state')
  end

  it "has cartowrap endpoint" do
    instance = ArTestClass.new()
    expect(instance.instance_variable_get :@api_endpoint).to be_a Cartowrap::API
  end

  it "requires CartoDB table name" do
    class TablelessTestClass < ActiveRecord::Base
      include Cartomodel::Model::Synchronizable
    end

    instance = TablelessTestClass.new()
    expect { instance.save }.to raise_error(RuntimeError, 'CartoDB table name not defined')

    expect(Cartowrap).to receive(:make_request)

    instance.define_singleton_method(:cartodb_table) do
      "foo"
    end
    expect { instance.save }.to_not raise_error()

    TablelessTestClass.reset_callbacks(:destroy)
    instance.destroy
  end
end

