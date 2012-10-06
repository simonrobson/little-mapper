module LittleMapper
  module DslClassMethods

    # Getter/Setter for the Domain Entity to persist.
    def entity(klass = nil)
      if klass.nil?
        @_entity
      else
        @_entity = klass
        LittleMapper.register(klass, self)
      end
    end

    # Getter/Setter for the (Currently ActiveRecord only) class to use for
    # persistence.
    def persistent_entity(klass = nil)
      klass.nil? ? @_persistent_entity :  @_persistent_entity = klass
    end

    def mappings
      @_mappings ||= []
    end

    def add_mapping(m)
      mappings << m
    end

    def mapping_factory=(mf)
      @_mapping_factory = mf
    end

    def mapping_factory
      @_mapping_factory ||= LittleMapper::MappingFactory.new
    end

    # Add one or more simple one-to-one mappings.
    #
    # args - one or more Symbols. The names of the fields to map.
    #
    # Examples
    #
    #   maps :first_name, :last_name
    def maps(*args)
       args.each {|f| map(f)}
    end


    # Add a single mapping.
    #
    # field - A Symbol, the name of the field to map.
    # opts  - A Hash of options to configure the mapper (default: {}):
    #         :as            - The Class of Mapper to use to map an entity
    #                          value. Can be enclosed in Array notation to
    #                          signify a one to many relationship
    #         :to            - Name of the field on the persistent entity
    #                          to which we will map (default: field)
    #         :entity_setter - a Symbol representing the name of a function
    #                          to use when setting the value on the entity
    #                          (default: field=)
    #         :entity_collection_adder - in a one-to-many relationship, the name of
    #                          of a method to use when adding associated objetcs
    #                          (default: to#<<)
    # Examples
    #
    #   map :metrics, :as => [Metric]
    #   map :owner, :entity_setter => :assign_owner
    def map(field, opts = {})
      add_mapping(mapping_factory.map(field, opts))
    end

  end
end