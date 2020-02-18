class ShardRefDependency
  include Clear::Model

  column id : UUID, primary: true, presence: false
  column ref_requirement : String

  belongs_to shard : Shard
  has_many dependencies : ShardRefDependency

  full_text_searchable

end
