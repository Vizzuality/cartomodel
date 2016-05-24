module Cartomodel
  module Model
    module Synchronizable
      extend ActiveSupport::Concern
      extend ActiveSupport::DescendantsTracker

      STATE_UNSYNCED = 0
      STATE_SYNCED = 1
      STATE_FAILED = 2

      def initialize(*args, &block)
        @api_endpoint = Cartowrap::API.new()
        super
      end

      def create_on_cartodb
        prepare_dependencies

        self.sync_state == STATE_UNSYNCED

        attributes = prepare_attributes

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
        prepare_dependencies

        self.sync_state == STATE_UNSYNCED

        attributes = prepare_attributes

        query = @query_generator.update(attributes, :cartodb_id, self.cartodb_id)
        begin
          response = @api_endpoint.send_query(query)
          json = ActiveSupport::JSON.decode(response)
          self.cartodb_id = json['rows'].first['cartodb_id']
          self.sync_state = STATE_SYNCED
        rescue
          self.sync_state = STATE_FAILED
        end
      end

      def delete_on_cartodb
        prepare_dependencies

        query = @query_generator.delete(:cartodb_id, self.cartodb_id)
        @api_endpoint.send_query(query)
      end

      def self.included(base)
        unless base.ancestors.include? ActiveRecord::Base
          raise RuntimeError.new('Cartomodel::Synchronizable can only extend ActiveRecord instances')
        end

        unless base.column_names.include? 'cartodb_id' and base.column_names.include? 'sync_state'
          raise RuntimeError.new('Cartomodel::Synchronizable requires \'cartodb_id\' and \'sync_state\' attributes')
        end

        base.before_create :create_on_cartodb
        base.before_update :update_on_cartodb
        base.before_destroy :delete_on_cartodb
      end

      private

      def prepare_dependencies
        unless self.respond_to? :cartodb_table
          raise RuntimeError.new('CartoDB table name not defined')
        end

        if cartodb_table.nil?
          raise RuntimeError.new('CartoDB table name not defined')
        end

        if @query_generator.nil?
          @query_generator = Cartomodel::QueryGenerator.new(cartodb_table)
        end

        if @api_endpoint.nil?
          @api_endpoint = Cartowrap::API.new()
        end
      end

      def prepare_attributes
        attributes = self.attributes.dup
        attributes.delete('id')
        attributes.delete('sync_state')
        attributes.delete('cartodb_id')
        attributes
      end
    end
  end
end