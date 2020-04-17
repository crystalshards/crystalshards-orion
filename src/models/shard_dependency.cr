class ShardDependency
  include Clear::Model

  primary_key name: "id", type: :uuid
  column name : String
  column type : RefType
  column requirement_operator : RequirementOperator
  column requirement_version : SemanticVersion?
  column development : Bool

  belongs_to shard : Shard, foreign_key: "parent_id", key_type: UUID
  has_many dependencies : Project, foreign_key: "dependency_id", foreign_key_type: UUID
end
