module SimpleMapper
  module Result
    class RepoSuccess < RepositoryResult
      def success?; true; end
    end
  end
end
