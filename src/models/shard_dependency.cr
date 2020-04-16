class ShardDependency
  include Clear::Model

  column id : UUID, primary: true, presence: false
  column requirement : String

  belongs_to shard : Shard, foreign_key: "parent_id", key_type: UUID
  has_many dependencies : Project, foreign_key: "dependency_id", foreign_key_type: UUID
end
