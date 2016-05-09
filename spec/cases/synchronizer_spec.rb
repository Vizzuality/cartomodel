require 'spec_helper'

describe 'Synchronizer' do
  def gen_query_arguments(query)
    query_arguments = OpenStruct.new
    query_arguments.endpoint = 'sql'
    query_arguments.query_string = true
    query_arguments.q = query
    query_arguments
  end

  before(:each) do
    correct_body = {rows: [{cartodb_id: 1}]}
    @correct_response = Cartowrap::HTTPService::Response.new(200, ActiveSupport::JSON.encode(correct_body), "")
  end
  
  it 'can sync broken create' do
    query_arguments = gen_query_arguments 'INSERT INTO "foo" ("f_binary", "f_boolean", "f_date", "f_datetime", "f_decimal", "f_float", "f_integer", "f_references_id", "f_string", "f_text", "f_time", "f_timestamp") VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) RETURNING cartodb_id'
    credentials = {"api_key"=>nil, "account"=>nil}

    expect(Cartowrap).to receive(:make_request).once.with(query_arguments, credentials).and_return(Cartowrap::HTTPService::Response.new(500, "", ""))
    expect(Cartowrap).to receive(:make_request).once.with(query_arguments, credentials).and_return(@correct_response)
    expect(Cartowrap).to receive(:make_request).once.and_return(@correct_response)

    instance = ArTestClass.new()
    instance.instance_variable_set(:@cartodb_table, 'foo')
    instance.save

    expect(instance.sync_state).to eq(Cartomodel::Model::Synchronizable::STATE_FAILED)

    Cartomodel::Synchronizer.sync_all

    instance = ArTestClass.first

    expect(instance.sync_state).to eq(Cartomodel::Model::Synchronizable::STATE_SYNCED)

    instance.destroy
  end
  it 'can sync broken update' do
    insert_query_arguments = gen_query_arguments 'INSERT INTO "foo" ("f_binary", "f_boolean", "f_date", "f_datetime", "f_decimal", "f_float", "f_integer", "f_references_id", "f_string", "f_text", "f_time", "f_timestamp") VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) RETURNING cartodb_id'
    update_query_arguments = gen_query_arguments 'UPDATE "foo" SET "f_binary" = NULL, "f_boolean" = NULL, "f_date" = NULL, "f_datetime" = NULL, "f_decimal" = NULL, "f_float" = NULL, "f_integer" = NULL, "f_references_id" = NULL, "f_string" = NULL, "f_text" = NULL, "f_time" = NULL, "f_timestamp" = NULL WHERE "foo"."cartodb_id" = 5'
    credentials = {"api_key"=>nil, "account"=>nil}

    expect(Cartowrap).to receive(:make_request).once.with(insert_query_arguments, credentials).and_return(Cartowrap::HTTPService::Response.new(500, "", ""))
    expect(Cartowrap).to receive(:make_request).once.with(update_query_arguments, credentials).and_return(@correct_response)
    expect(Cartowrap).to receive(:make_request).once.and_return(@correct_response)

    instance = ArTestClass.new()
    instance.instance_variable_set(:@cartodb_table, 'foo')
    instance.cartodb_id = 5
    instance.save

    expect(instance.sync_state).to eq(Cartomodel::Model::Synchronizable::STATE_FAILED)

    Cartomodel::Synchronizer.sync_all

    instance = ArTestClass.first

    expect(instance.sync_state).to eq(Cartomodel::Model::Synchronizable::STATE_SYNCED)

    instance.destroy
  end
end