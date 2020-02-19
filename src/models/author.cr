class Shard
  include Clear::Model

  column id : UUID, primary: true, presence: false
  column name : String
  column email : String

  has_many shards : Shard, through: "shard_authors"
end
