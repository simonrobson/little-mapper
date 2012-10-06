module SimpleMapper
  module Result
    class RepoFailure < RepositoryResult
      def after_initialize
        if object && object.respond_to?(:errors)
          @messages = object.errors.full_messages
        end
      end
    end
  end
end