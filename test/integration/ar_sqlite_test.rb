require 'helper'
require 'active_record'
require 'integration/helper'



class ArSqliteTest < MiniTest::Unit::TestCase
  DBNAME = 'lmapper.sqlite'

  def init_db
    if File.directory?('tmp')
      File.unlink('tmp/#{DBNAME}') if File.exists?('tmp/#{DBNAME}')
    else
      Dir.mkdir('tmp')
    end
    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'tmp/test.sqlite')
    create_tables
    @_db_initialized = true
  end

  def create_tables
    CreatePeople.new.up
    CreatePhoneNumbers.new.up
    CreateCats.new.up
  end

  def clear_tables
    Persistent::Person.delete_all
  end

  def setup
    init_db unless @_db_initialized
    clear_tables
  end


  def test_round_trip
    p = Person.new(:name => 'John', :age => 27)
    LittleMapper[Person] << p
    assert_equal 1, LittleMapper[Person].find_all.length
    found = LittleMapper[Person].last
    assert_equal p.name, found.name
    assert_equal p.age, found.age
    refute_nil found.id
    assert_equal p.id, found.id
  end

  def test_find_all
    LittleMapper[Person] << Person.new(:name => 'John', :age => 27)
    LittleMapper[Person] << Person.new(:name => 'Jane', :age => 67)
    assert_equal 2, LittleMapper[Person].find_all.length
  end

  def test_simple_one_to_many_association
    p = Person.new(:name => 'John', :age => 27)
    p.phone_numbers << PhoneNumber.new(:code => '099', :number => '987654321')
    p.phone_numbers << PhoneNumber.new(:code => '123', :number => '123456789')
    LittleMapper[Person] << p
    found = LittleMapper[Person].find_by_id(p.id)
    assert_equal 2, found.phone_numbers.length
  end

  def test_one_to_many_with_custom_setters_getters
    p = Person.new(:name => 'John', :age => 27)
    p.receive_cat(Cat.new(:moniker => 'Meaw', :color => 'Tabby'))
    LittleMapper[Person] << p
    found = LittleMapper[Person].find_by_id(p.id)
    assert_equal 1, found.all_cats.length
  end

  def test_one_to_one_with_another_entity
    o = Person.new(:name => 'Jane', :age => 28)
    LittleMapper[Person] << o
    p = Person.new(:name => 'John', :age => 27, :spouse => o)
    LittleMapper[Person] << p
    found = LittleMapper[Person].find_by_id(p.id)
    assert_equal found.spouse, o
  end



end