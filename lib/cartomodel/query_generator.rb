module Cartomodel
  class QueryGenerator
    def initialize(table_name)
      @table_name = table_name
      @table = Arel::Table.new(@table_name)
    end

    def insert(raw_values)
      manager = Arel::InsertManager.new()
      manager.into @table
      values = []

      raw_values.each do |key, value|
        values << [@table[key], value]
      end

      manager.insert(values)
      manager.to_sql + ' RETURNING cartodb_id'
    end

    def update(raw_values, id_column, id_value)
      values = []

      raw_values.each do |key, value|
        values << [@table[key], value]
      end

      manager = Arel::UpdateManager.new
      manager.table @table
      manager.where @table[id_column].eq(id_value)
      manager.set values
      return manager.to_sql
    end

    def delete(id_column, id_value)
      manager = Arel::DeleteManager.new
      manager.from @table

      manager.where @table[id_column].eq(id_value)

      return manager.to_sql
    end

  end
end
