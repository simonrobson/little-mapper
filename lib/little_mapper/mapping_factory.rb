module LittleMapper
  class MappingFactory

    def initialize(strategy = :activerecord)
      @_strategy = strategy
    end

    def strategy
      @_strategy
    end

    def map(field, opts = {})
      as = opts.delete(:as)
      if as && as.is_a?(Array)
        one_to_many.new(field, as[0], opts)
      else
        one_to_one.new(field, opts)
      end
    end

    def strategy_module
      case strategy
      when :activerecord
        ::LittleMapper::Mappers::AR
      end
    end

    def one_to_one
      strategy_module.const_get('OneToOne')
    end

    def one_to_many
      strategy_module.const_get('OneToMany')
    end
  end
end
