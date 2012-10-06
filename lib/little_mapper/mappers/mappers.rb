module LittleMapper
  module Mappers
    class Base
      attr_accessor :source
      def from(source)
        @source = source
        self
      end
    end
  end
end