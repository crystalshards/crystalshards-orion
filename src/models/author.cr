class Author
  include Clear::Model

  column id : UUID, primary: true, presence: false
  column name : String
  column email : String

  has_many shards : Shard, through: "shard_authors", foreign_key_type: UUID
end
