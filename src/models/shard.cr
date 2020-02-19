class Shard
  include Clear::Model

  column id : UUID, primary: true, presence: false
  column ref_type : RefType
  column ref_name : String
  column version : SemanticVersion
  column license : String
  column description : String
  column crystal : SemanticVersion
  column executables : Array(String)
  column tags : Array(String)

  belongs_to project : Project
  has_many dependencies : ShardDependency, foreign_key: "parent_id"
  has_many authors : Author, through: "shard_authors"

  full_text_searchable
end
