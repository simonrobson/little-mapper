module LittleMapper
  module MapperInstanceMethods
    def to_persistent(entity)
      pe = self.class.persistent_entity.new
      self.class.mappings.each do |m|
        m.from(entity).to_persistent(pe)
      end
      pe
    end

    def to_entity(persistent)
      e = self.class.entity.new
      e.id = persistent.id # probably set this only if configured & see duplication below
      self.class.mappings.each do |m|
        m.from(persistent).to_entity(e)
      end
      e
    end

    def <<(entity)
      pe = to_persistent(entity)
      if pe.save
        entity.id = pe.id # set this only if configured
        LittleMapper::Result::RepoSuccess.new
      else
        LittleMapper::Result::RepoFailure.new(pe)
      end
    end

    def find_by_id(id)
      pe = self.class.persistent_entity.find_by_id(id)
      return nil unless pe
      to_entity(pe)
    end

    def find_all
      self.class.persistent_entity.all.collect { |e| to_entity(e) }
    end

    def last
      to_entity(self.class.persistent_entity.last)
    end
  end
end