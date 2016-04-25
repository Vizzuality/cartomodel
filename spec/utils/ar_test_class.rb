ActiveRecord::Schema.define do
  self.verbose = false

  create_table :ar_test_classes, :force => true do |t|
    t.integer :cartodb_id
    t.integer :sync_state

    t.binary      :f_binary
    t.boolean     :f_boolean
    t.date        :f_date
    t.datetime    :f_datetime
    t.decimal     :f_decimal
    t.float       :f_float
    t.integer     :f_integer
    t.references  :f_references
    t.string      :f_string
    t.text        :f_text
    t.time        :f_time
    t.timestamp   :f_timestamp
  end

  create_table :no_attr_ar_test_classes, :force => true do |t| end
  create_table :tableless_test_classes, :force => true do |t|
    t.integer :cartodb_id
    t.integer :sync_state
  end
end

class ArTestClass < ActiveRecord::Base
  include Cartomodel::Model::Synchronizable

  def cartodb_table
    'foo'
  end
end