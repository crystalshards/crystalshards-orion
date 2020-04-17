class Shard
  include Clear::Model

  # Columns
  primary_key name: "id", type: :uuid
  column manifest : Manifest::Shard
  column name : String
  column version : SemanticVersion?
  column license : String?
  column description : String?
  column crystal : SemanticVersion?
  column tags : Array(String)?

  # Associations
  belongs_to project : Project, key_type: UUID
  has_many dependencies : ShardDependency, foreign_key: "parent_id", foreign_key_type: UUID
  has_many authors : Author, through: "shard_authors", foreign_key_type: UUID

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
end
