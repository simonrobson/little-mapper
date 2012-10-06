module LittleMapper
  module Mappers
    module AR
      class OneToOne < Mappers::Base
        attr_accessor :field, :entity_setter, :persistent_entity_setter
        def initialize(field, opts = {})
          @field = field
          @entity_setter = opts[:entity_setter] || "#{field}=".to_sym
          @persistent_entity_setter = opts[:persistent_entity_setter] || "#{field}=".to_sym
        end

        def to_persistent(target)
          target.__send__(persistent_entity_setter, source.__send__(field))
        end

        def to_entity(target)
          target.__send__(entity_setter, source.__send__(field))
        end
      end
    end
  end
end