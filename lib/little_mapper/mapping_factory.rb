module LittleMapper
  class MappingFactory

    def initialize(strategy = :activerecord)
      @_strategy = strategy
    end

    def strategy
      @_strategy
    end

    def map(field, opts = {})
      if opts[:as] && opts[:as].is_a?(Array)
        as = opts.delete(:as)
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
