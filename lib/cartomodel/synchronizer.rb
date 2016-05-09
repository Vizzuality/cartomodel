module Cartomodel
  class Synchronizer
    def self.sync_all
      self.get_failed_synced_instances.each do |object|
        object.class.skip_callback(:create, :before, :create_on_cartodb)
        object.class.skip_callback(:update, :before, :update_on_cartodb)

        begin
          if object.cartodb_id then
            object.update_on_cartodb
          else
            object.create_on_cartodb
          end
          object.save
        ensure
          object.class.set_callback(:create, :before, :create_on_cartodb)
          object.class.set_callback(:update, :before, :update_on_cartodb)
        end
      end
    end

    def self.get_failed_synced_instances
      result = []
      ActiveRecord::Base.descendants.each do |active_record_descendant|
        next if active_record_descendant.included_modules.exclude? Cartomodel::Model::Synchronizable or !ActiveRecord::Base.connection.column_exists? active_record_descendant.table_name, :sync_state
        result.concat active_record_descendant.where(sync_state: Cartomodel::Model::Synchronizable::STATE_FAILED)
      end
      result
    end
  end
end

