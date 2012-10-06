module LittleMapper
  module Mappers
    module AR
      class OneToMany < Base
        attr_accessor :entity_field, :persistent_field, :persistent_klass
        def initialize(entity_field, persistent_klass, persistent_field = nil)
          @entity_field = entity_field
          @persistent_klass = persistent_klass
          @persistent_field = persistent_field || entity_field
        end

        def to_persistent(target)
          source.__send__(entity_field).each do |associated|
            target.__send__(persistent_field).__send__(:<<, Mapper[persistent_klass].to_persistent(associated))
          end
        end
        def to_entity(target)
          source.__send__(persistent_field).each do |associated|
            target.__send__(entity_field).__send__(:<<, Mapper[persistent_klass].to_entity(associated))
          end
        end
      end
    end
  end
end
