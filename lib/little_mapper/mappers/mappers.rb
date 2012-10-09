module LittleMapper
  module Mappers
    class Base
      attr_accessor :source
      def from(source)
        @source = source
        self
      end

      def camel_to_snake(cc)
        cc.gsub(/(.)([A-Z])/,'\1_\2').downcase
      end
    end
  end
end