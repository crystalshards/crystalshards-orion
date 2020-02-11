class Shard
  include Clear::Model

  column id : UUID, primary: true, presence: false
  column watcher_count : Int32
  column fork_count : Int32
  column star_count : Int32
  column pull_request_count : Int32
  column issue_count : Int32
  column repo_url : String
  column clone_url : String
  column provider : String
end
