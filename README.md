# LittleMapper

Early stage simple datamapper/repository backed by ActiveRecord (only, for the moment). Still working out the best DSL. Currently in use on an internal project.

## Installation

Add this line to your application's Gemfile:

    gem 'little_mapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install little_mapper

## Usage

Define one or more plain ruby classes:

	class Person < OpenStruct
	  attr_accessor :phone_numbers
	  def initialize(*args)
        super
		@phone_numbers = []
	  end
	end

	class PhoneNumber
	  attr_accessor :id, :code, :number
	  def initialize(opts = {})
	    opts.each_pair {|k, v| self.send("#{k}=", v)}
	  end
	end


Define the mappers:

	class PersonMapper
	  include LittleMapper
	  entity Person
	  persistent_entity Persistent::Person
	  maps :name, :age
	  map :phone_numbers, :as => [PhoneNumber]
	  # see integration test for more complex example
	  # map :all_cats, :as => [Cat], :entity_collection_adder => :receive_cat,
	  #    :to => :cats
	  map :spouse, :as => Person
	end

	class PhoneNumberMapper
	  include LittleMapper
	  entity PhoneNumber
	  persistent_entity Persistent::PhoneNumber
	  maps :code, :number
	end

Define the ActiveRecord classes (and their migrations, not shown):

	module Persistent
	  class Person < ActiveRecord::Base
	    has_many :phone_numbers
	    belongs_to :spouse, :class_name => 'Person'
	  end

	  class PhoneNumber < ActiveRecord::Base
	    belongs_to :person
	  end
	end

Exercise the code:

	jane = Person.new(:name => 'Jane', :age => 28)
    LittleMapper[Person] << jane # stores jane
    john = Person.new(:name => 'John', :age => 27, :spouse => o)
    LittleMapper[Person] << john
    found = LittleMapper[Person].find_by_id(john.id)
    puts found.spouse.name # Jane - found and spouse are plain Ruby objects

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
