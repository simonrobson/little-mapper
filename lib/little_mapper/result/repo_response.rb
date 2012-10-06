module SimpleMapper
  module Result
  	class RepoResult
      attr_reader :messages, :object
        def initialize(object = nil)
          @messages = []
          @object = object
          after_initialize
        end
        def success?; false; end
        def after_initialize; end
      end
    end
  end
end