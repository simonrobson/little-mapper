require "little_mapper/version"
require "little_mapper/dsl_class_methods"
require "little_mapper/mapper_instance_methods"
require "little_mapper/mapping_factory"
require "little_mapper/mappers/mappers"
require "little_mapper/mappers/active_record"
require "little_mapper/result/repo_response"
require "little_mapper/result/repo_success"
require "little_mapper/result/repo_failure"

module LittleMapper

  # Registers a mapper under a key.
  #
  # Will generally be called by Little Mapper itself during inclusion of the
  # LittleMapper module in your class.
  #
  # entity - The key under which the mapper will be held. Generally the
  #          the non-persistent entity class name.
  # mapper - The class of the mapper.
  #
  # Returns the mapper
  def self.register(entity, mapper)
    @mappers ||= {}
    @mappers[entity] = mapper
  end

  # Returns an instantiated mapper for the given key.
  #
  # The primary way of interacting with LittleMapper having set up one or more
  # mappers.
  #
  # key - The key under which the mapper was stored. Generally the non-
  #       persistent entity class name.
  #
  # Returns a mapper instance for the key
  def self.[](key)
    @mappers[key].new
  end

  # Private: kicks off the action when this module is included
  def self.included(klass)
    klass.extend DslClassMethods
    klass.module_eval { include MapperInstanceMethods}
  end
end
