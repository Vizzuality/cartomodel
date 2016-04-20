module Cartomodel
  module Model
    module Synchronizable
      extend ActiveSupport::Concern

      STATE_UNSYNCED = 0
      STATE_SYNCED = 1
      STATE_FAILED = 2

      def initialize(*args, &block)
        @api_endpoint = Cartowrap::API.new()
        super
      end

      def create_on_cartodb

        if @cartodb_table.nil?
          raise RuntimeError.new('CartoDB table name not defined')
        end

        self.sync_state == STATE_UNSYNCED

        if @query_generator.nil?
          @query_generator = Cartomodel::QueryGenerator.new(@cartodb_table)
        end

        attributes = self.attributes.dup
        attributes.delete('id')
        attributes.delete('sync_state')
        attributes.delete('cartodb_id')

        query = @query_generator.insert(attributes)
        begin
          response = @api_endpoint.send_query(query)
          json = ActiveSupport::JSON.decode(response)
          self.cartodb_id = json['rows'].first['cartodb_id']
          self.sync_state = STATE_SYNCED
        rescue
          self.sync_state = STATE_FAILED
        end
      end

      def update_on_cartodb
        if @cartodb_table.nil?
          raise RuntimeError.new('CartoDB table name not defined')
        end

        self.sync_state == STATE_UNSYNCED

        if @query_generator.nil?
          @query_generator = Cartomodel::QueryGenerator.new(@cartodb_table)
        end

        attributes = self.attributes.dup
        attributes.delete('id')
        attributes.delete('sync_state')
        attributes.delete('cartodb_id')

        query = @query_generator.update(attributes, :cartodb_id, self.attributes[:cartodb_id])
        begin
          @api_endpoint.send_query(query)
          self.sync_state = STATE_SYNCED
        rescue
          self.sync_state = STATE_FAILED
        end
      end

      def delete_on_cartodb
        if @cartodb_table.nil?
          raise RuntimeError.new('CartoDB table name not defined')
        end

        if @query_generator.nil?
          @query_generator = Cartomodel::QueryGenerator.new(@cartodb_table)
        end

        query = @query_generator.delete(:cartodb_id, self.attributes[:cartodb_id])
        @api_endpoint.send_query(query)
      end

      # def @cartodb_table=(new_@cartodb_table)
      #   @@cartodb_table = new_@cartodb_table
      # end

      def self.included(base)
        unless base.ancestors.include? ActiveRecord::Base
          raise RuntimeError.new('Cartomodel::Synchronizable can only extend ActiveRecord instances')
        end

        unless base.new.attributes.include? 'cartodb_id' and base.new.attributes.include? 'sync_state'
          raise RuntimeError.new('Cartomodel::Synchronizable requires \'cartodb_id\' and \'sync_state\' attributes')
        end

        base.before_create :create_on_cartodb
        base.before_update :update_on_cartodb
        base.before_destroy :delete_on_cartodb
      end
    end
  end
end