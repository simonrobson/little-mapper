module LittleMapper
  module Mappers
    module AR
      class OneToMany < Base
        attr_accessor :mapper, :entity_field, :persistent_field, :persistent_klass
        attr_accessor :entity_collection_adder, :reflexive, :reflexive_setter
        def initialize(mapper, entity_field, persistent_klass, opts = {})
          @mapper = mapper
          @entity_field = entity_field
          @persistent_klass = persistent_klass
          @persistent_field = opts[:to] || entity_field
          @entity_collection_adder = opts[:entity_collection_adder]
          @reflexive = opts.fetch(:reflexive, true)
          @reflexive_setter = opts[:reflexive_setter] || "#{camel_to_snake(mapper.entity.to_s)}="
        end

        def to_persistent(target)
          source.__send__(entity_field).each do |associated|
            target.__send__(persistent_field).__send__(:<<, LittleMapper[persistent_klass].to_persistent(associated))
          end
        end
        def to_entity(target)
          source.__send__(persistent_field).each do |associated|
            assoc_entity = LittleMapper[persistent_klass].to_entity(associated)
            if reflexive
              assoc_entity.__send__(reflexive_setter, target)
            end
            target.__send__(entity_field).__send__(:<<, assoc_entity)
          end
        end
      end
    end
  end
end
