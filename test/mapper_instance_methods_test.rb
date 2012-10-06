require 'helper'

module LittleMapper
  class MapperInstanceMethodsTest < MiniTest::Unit::TestCase
    class InstanceTestClass
      include MapperInstanceMethods
    end

    def test_implements_repo_interface
      @repo = InstanceTestClass.new
      assert @repo.respond_to?(:<<), "should respond to <<"
      assert @repo.respond_to?(:find_by_id), "should respond to find_by_id"
      assert @repo.respond_to?(:find_all), "should respond to find_by_all"
      assert @repo.respond_to?(:last), "should respond to last"

      assert @repo.respond_to?(:to_entity), "provides to_entity"
      assert @repo.respond_to?(:to_persistent), "provides to_persistent"
    end


  end
end