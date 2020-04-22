class Shard
  include Clear::Model

  # Columns
  primary_key
  column manifest : Manifest::Shard
  column name : String
  column version : String
  column git_tag : String?
  column license : String?
  column description : String?
  column crystal : String?
  column tags : Array(String)?

  # Associations
  belongs_to project : Project
  has_many dependencies : ShardDependency, foreign_key: "parent_id"
  has_many authors : Author, through: "shard_authors"

  # Copy spec data to shard
  before :validate do |model|
    model.as(self).update_from_manifest!
  end

  after :save do |model|
    model.as(self).associate_authors!
    model.as(self).associate_dependencies!
  end

  after :create do |model|
    model.as(self).associate_authors!
    model.as(self).associate_dependencies!
  end

  protected def update_from_manifest!
    self.name = manifest.name
    self.version = manifest.version
    self.license = manifest.license
    self.description = manifest.description
    self.crystal = manifest.crystal
    self.tags = manifest.tags
  end

  protected def associate_dependencies!
    # Associate release deps
    (manifest.dependencies || {} of String => Manifest::Shard::Dependency::Provider).each do |name, dependency|
      if (dep = ShardDependency.associate(self, name, dependency))
        self.dependencies << dep
      end
    end

    # Associate development deps
    (manifest.development_dependencies || {} of String => Manifest::Shard::Dependency::Provider).each do |name, dependency|
      if (dep = ShardDependency.associate(self, name, dependency, true))
        self.dependencies << dep
      end
    end
  end

  protected def associate_authors!
    (manifest.authors || [] of Manifest::Shard::Author).each do |manifest_author|
      self.authors << Author.query.find_or_create({name: manifest_author.name, email: manifest_author.email}) { }
    end
  end
end
