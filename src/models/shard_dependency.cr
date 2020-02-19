class ShardDependency
  include Clear::Model

  column id : UUID, primary: true, presence: false
  column requirement : String

  belongs_to shard : Shard, foreign_key: "parent_id"
  has_many dependencies : Project, foreign_key: "dependency_id"
end
