class Shard
  include Clear::Model

  class Author
    include Clear::Model

    belongs_to post : ::Shard, key_type: UUID
    belongs_to tag : ::Author, key_type: UUID

    self.table = "shard_authors"
  end

  # Columns
  primary_key name: "id", type: :uuid
  column manifest : Manifest::Shard
  column name : String
  column version : SemanticVersion
  column git_tag : SemanticVersion?
  column license : String?
  column description : String?
  column crystal : SemanticVersion?
  column tags : Array(String)?

  # Associations
  belongs_to project : Project, key_type: UUID
  has_many dependencies : ShardDependency, foreign_key: "parent_id", foreign_key_type: UUID
  has_many authors : Author, through: Shard::Author, foreign_key_type: UUID

  # Copy spec data to shard
  before :validate do |model|
    shard = model.as(Shard)
    shard.name = shard.manifest.name
    shard.version = SemanticVersion.parse(shard.manifest.version)
    shard.license = shard.manifest.license
    shard.description = shard.manifest.description
    shard.crystal = (crystal = shard.manifest.crystal) ? SemanticVersion.parse(crystal) : nil
    shard.tags = shard.manifest.tags
  end

  after :save do |model|
    shard = model.as(Shard)
    (shard.manifest.authors || [] of Manifest::Shard::Author).each do |manifest_author|
      author = ::Author.query.find_or_create({ name: manifest_author.name, email: manifest_author.email }){}
      ::Shard::Author.query.find_or_create({ shard_id: shard.id.to_s, author_id: author.id.to_s }){}
    end
  end
end
