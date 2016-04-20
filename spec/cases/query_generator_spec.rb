require 'spec_helper'

describe "Cartomodel::QueryGenerator" do
  it "can generate simple inserts" do
    colors = {
        'red' => '0xff0000',
        'blue' => '0x0000ff'
    }

    expect(Cartomodel::QueryGenerator.new('foo').insert(colors)).to eq('INSERT INTO "foo" ("red", "blue") VALUES (\'0xff0000\', \'0x0000ff\')')
  end

  it "can generate simple updates" do
    colors = {
        'red' => 'abc',
        'blue' => 'def'
    }

    expect(Cartomodel::QueryGenerator.new('foo').update(colors, 'id', 1)).to eq('UPDATE "foo" SET "red" = \'abc\', "blue" = \'def\' WHERE "foo"."id" = 1')
  end

  it "can generate simple deletes" do
    expect(Cartomodel::QueryGenerator.new('foo').delete('id', 90)).to eq('DELETE FROM "foo" WHERE "foo"."id" = 90')
  end
end

