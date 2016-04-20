require 'spec_helper'

describe "Cartomodel::Model::Synchronizable" do
  before(:each) do
    @query_generator = spy(Cartomodel::QueryGenerator)

    @instance = ArTestClass.new()
    @instance.cartodb_table = 'foo'
    @instance.instance_variable_set(:@query_generator, @query_generator)
    @instance.save
  end
  it "generates INSERT query for CartoDB" do
    expected_insert_args = {
        "id" => nil,
        "cartodb_id" => nil,
        "sync_state" => nil,
        "f_binary" => nil,
        "f_boolean" => nil,
        "f_date" => nil,
        "f_datetime" => nil,
        "f_decimal" => nil,
        "f_float" => nil,
        "f_integer" => nil,
        "f_references_id" => nil,
        "f_string" => nil,
        "f_text" => nil,
        "f_time" => nil,
        "f_timestamp" => nil
    }

    expect(@query_generator).to have_received(:insert).with(expected_insert_args)
  end
  it "generates UPDATE query for CartoDB" do
    @instance.save

    expected_update_args = {
        "id" => 2,
        "cartodb_id" => nil,
        "sync_state" => nil,
        "f_binary" => nil,
        "f_boolean" => nil,
        "f_date" => nil,
        "f_datetime" => nil,
        "f_decimal" => nil,
        "f_float" => nil,
        "f_integer" => nil,
        "f_references_id" => nil,
        "f_string" => nil,
        "f_text" => nil,
        "f_time" => nil,
        "f_timestamp" => nil
    }

    expect(@query_generator).to have_received(:update).with(expected_update_args, :cartodb_id, nil)
  end
  it "generates DELETE query for CartoDB" do
    @instance.destroy

    expect(@query_generator).to have_received(:delete).with(:cartodb_id, nil)
  end
end

