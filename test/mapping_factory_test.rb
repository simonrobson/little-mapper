require 'helper'

module LittleMapper
  class MappingFactoryTest < MiniTest::Unit::TestCase
    def test_defaults_to_activerecord_strategy
      assert MappingFactory.new.strategy == :activerecord
    end

    def test_one_to_one_constant
      assert_equal LittleMapper::Mappers::AR::OneToOne, MappingFactory.new.one_to_one
    end

  end
end