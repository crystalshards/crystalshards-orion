class Author
  include Clear::Model

  primary_key name: "id", type: :uuid
  column name : String
  column email : String

  has_many shards : Shard, through: "shard_authors", foreign_key_type: UUID
end
