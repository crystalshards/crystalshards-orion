class ShardRef
  include Clear::Model

  column id : UUID, primary: true, presence: false
  column ref_type : RefType
  column ref_id : String
  column license : String
  column description : String
  column crystal : String
  column executables : Array(String)
  column tags : Array(String)

  belongs_to shard : Shard
  has_many dependencies : ShardRefDependency

  full_text_searchable

end
