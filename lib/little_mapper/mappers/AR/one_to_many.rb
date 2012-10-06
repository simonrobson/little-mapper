module LittleMapper
  module Mappers
    module AR
      class OneToMany < Base
        attr_accessor :entity_field, :persistent_field, :persistent_klass
        attr_accessor :entity_collection_adder
        def initialize(entity_field, persistent_klass, opts = {})
          @entity_field = entity_field
          @persistent_klass = persistent_klass
          @persistent_field = opts[:persistent_field] || entity_field
          @entity_collection_adder = opts[:entity_collection_adder]
        end

        def to_persistent(target)
          source.__send__(entity_field).each do |associated|
            target.__send__(persistent_field).__send__(:<<, LittleMapper[persistent_klass].to_persistent(associated))
          end
        end
        def to_entity(target)
          source.__send__(persistent_field).each do |associated|
            target.__send__(entity_field).__send__(:<<, LittleMapper[persistent_klass].to_entity(associated))
          end
        end
      end
    end
  end
end
