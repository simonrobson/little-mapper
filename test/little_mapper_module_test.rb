require 'helper'

class LittleMapperModuleTest < MiniTest::Unit::TestCase

  class A; end
  class B; end

  def test_it_registers_mappers
    LittleMapper.register(A, B)
    assert LittleMapper[A].is_a? B
  end

end