require 'helper'

module LittleMapper
  class DslClassMethodsTest < MiniTest::Unit::TestCase

    class TestClass
      extend DslClassMethods
    end

    class TheEntity; end

    def test_enables_setting_and_getting_entity
      TestClass.entity TheEntity
      assert_equal TheEntity, TestClass.entity
    end

    def test_setting_the_entity_registers_the_mapper
      TestClass.entity TheEntity
      assert LittleMapper[TheEntity].is_a? TestClass
    end

    def test_enables_setting_and_getting_persistent_entity
      TestClass.persistent_entity TheEntity
      assert_equal TheEntity, TestClass.persistent_entity
    end

    def test_provides_mappings_array
      assert TestClass.mappings.respond_to?(:each)
    end

    def test_enables_setting_and_getting_a_mapping_factory_instance
      factory = Object.new
      TestClass.mapping_factory = factory
      assert_equal factory, TestClass.mapping_factory
    end

    def test_defaults_mapping_factory
      TestClass.mapping_factory = nil
      assert TestClass.mapping_factory.is_a? LittleMapper::MappingFactory
    end

    def test_maps_delegates_to_map_and_so_to_mapping_factory
      factory = MiniTest::Mock.new
      TestClass.mapping_factory = factory
      args = [:a, :b, :c]
      factory.expect(:map, true, [:a, {}])
      factory.expect(:map, true, [:b, {}])
      factory.expect(:map, true, [:c, {}])
      TestClass.maps(*args)
      factory.verify
    end

    def test_delegates_map_to_mapping_factory
      factory = MiniTest::Mock.new
      TestClass.mapping_factory = factory
      args = [:field, :opt1 => :val, :opt2 => :val]
      factory.expect(:map, true, args)
      TestClass.map(*args)
      factory.verify
    end




  end
end