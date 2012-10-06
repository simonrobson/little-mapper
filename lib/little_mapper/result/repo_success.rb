module LittleMapper
  module Result
    class RepoSuccess < RepoResult
      def success?; true; end
    end
  end
end
