require 'helper'
require 'active_record'


class Person < OpenStruct

  attr_accessor :phone_numbers
  def initialize(*args)
    super
    @cats = []
    @phone_numbers = []
  end

  def receive_cat(cat)
    @cats << cat
  end

  def all_cats
    @cats
  end
end

class PhoneNumber
  attr_accessor :id, :code, :number
  def initialize(opts = {})
    opts.each_pair {|k, v| self.send("#{k}=", v)}
  end
end

class Cat
  attr_accessor :moniker, :color, :id
  def initialize(opts = {})
    opts.each_pair {|k, v| self.send("#{k}=", v)}
  end
end


module Persistent
  class Person < ActiveRecord::Base
    has_many :phone_numbers
    has_many :cats
  end

  class PhoneNumber < ActiveRecord::Base
    belongs_to :person
  end

  class Cat < ActiveRecord::Base
    belongs_to :person
  end
end

class PersonMapper
  include LittleMapper
  entity Person
  persistent_entity Persistent::Person
  maps :name, :age
  map :phone_numbers, :as => [PhoneNumber]
  map :all_cats, :as => [Cat], :entity_collection_adder => :receive_cat,
      :persistent_field => :cats
end

class PhoneNumber
  include LittleMapper
  entity PhoneNumber
  persistent_entity Persistent::PhoneNumber
  maps :code, :number
end

class CatMapper
  include LittleMapper
  entity Cat
  persistent_entity Persistent::Cat
  map :color
  map :moniker, :persistent_field => :name
end

class CreatePeople < ActiveRecord::Migration
  def up
    create_table :people, :force => true do |t|
      t.string :name
      t.integer :age
      t.timestamps
    end
  end
end

class CreatePhoneNumbers < ActiveRecord::Migration
  def up
    create_table :phone_numbers, :force => true do |t|
      t.references :person
      t.string :code
      t.string :number
    end
  end
end

class CreateCats < ActiveRecord::Migration
  def up
    create_table :cats, :force => true do |t|
      t.references :person
      t.string :name
      t.string :color
    end
  end
end


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


end