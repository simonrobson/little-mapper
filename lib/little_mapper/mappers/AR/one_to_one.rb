module LittleMapper
  module Mappers
    module AR
      class OneToOne < Mappers::Base
        attr_accessor :field, :persistent_klass, :persistent_field, :entity_setter, :persistent_entity_setter
        def initialize(field, opts = {})
          @field = field
          @persistent_klass = opts[:as]
          @persistent_field = opts[:to] || field
          @entity_setter = opts[:entity_setter] || "#{field}=".to_sym
          @persistent_entity_setter = opts[:persistent_entity_setter] || "#{persistent_field}=".to_sym
        end

        def to_persistent(target)
          if persistent_klass
            val = source.__send__(field)
            if val
              target.__send__(persistent_entity_setter, LittleMapper[persistent_klass].to_persistent(source.__send__(field)))
            end
          else
            target.__send__(persistent_entity_setter, source.__send__(field))
          end
        end

        def to_entity(target)
          if persistent_klass
            val = source.__send__(persistent_field)
            if val
              target.__send__(entity_setter, LittleMapper[persistent_klass].to_entity(val))
            end
          else
            target.__send__(entity_setter, source.__send__(persistent_field))
          end
        end
      end
    end
  end
end
