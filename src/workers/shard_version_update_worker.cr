class GithubShardVersionUpdateWorker < Mosquito::QueuedJob
  params shardfile_url : String
  params version_string : String

  def perform
    shard_version = ShardVersion.create(
      shard_id
    )
  end

  private def version(string = version_string)
    SemanticVersion.parse(string)
  end
end
