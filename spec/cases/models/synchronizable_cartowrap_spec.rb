require 'spec_helper'

describe "Cartomodel::Model::Synchronizable" do
  before(:each) do
    @api_endpoint = spy(Cartowrap::API)

    @instance = ArTestClass.new()
    @instance.instance_variable_set(:@cartodb_table, 'foo')
    @instance.instance_variable_set(:@api_endpoint, @api_endpoint)
    @instance.save
  end
  after(:each) do
    @instance.destroy
  end
  it "sends INSERT query for CartoDB" do
    expected_insert_query = "INSERT INTO \"foo\" (\"f_binary\", \"f_boolean\", \"f_date\", \"f_datetime\", \"f_decimal\", \"f_float\", \"f_integer\", \"f_references_id\", \"f_string\", \"f_text\", \"f_time\", \"f_timestamp\") VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) RETURNING cartodb_id"

    expect(@api_endpoint).to have_received(:send_query).with(expected_insert_query)
  end
  it "sends UPDATE query for CartoDB" do
    @instance.save

    expected_update_query = "UPDATE \"foo\" SET \"f_binary\" = NULL, \"f_boolean\" = NULL, \"f_date\" = NULL, \"f_datetime\" = NULL, \"f_decimal\" = NULL, \"f_float\" = NULL, \"f_integer\" = NULL, \"f_references_id\" = NULL, \"f_string\" = NULL, \"f_text\" = NULL, \"f_time\" = NULL, \"f_timestamp\" = NULL WHERE \"foo\".\"cartodb_id\" IS NULL"

    expect(@api_endpoint).to have_received(:send_query).with(expected_update_query)
  end
  it "sends DELETE query for CartoDB" do
    @instance.destroy

    expected_delete_query = "DELETE FROM \"foo\" WHERE \"foo\".\"cartodb_id\" IS NULL"

    expect(@api_endpoint).to have_received(:send_query).with(expected_delete_query)
  end
end

