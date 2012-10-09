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
    belongs_to :spouse, :class_name => 'Person'
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
      :to => :cats
  map :spouse, :as => Person
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
  map :moniker, :to => :name
end

class CreatePeople < ActiveRecord::Migration
  def up
    create_table :people, :force => true do |t|
      t.string :name
      t.integer :age
      t.integer :spouse_id
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

