$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'cartomodel'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                        :database => ":memory:")

require 'utils/ar_test_class'
