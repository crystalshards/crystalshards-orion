class GithubShardUpdateWorker < Mosquito::QueuedJob
  params url : String
  params name_with_owner : String
  params watcher_count : Int32
  params fork_count : Int32
  params star_count : Int32
  params pull_request_count : Int32
  params issue_count : Int32
  params release_tags : String

  def perform
    shard = Shard.create(
      url: url,
      clone_url: "#{url}.git",
      watcher_count: watcher_count,
      fork_count: fork_count,
      star_count: star_count,
      pull_request_count: pull_request_count,
      issue_count: issue_count,
      provider: "github"
    )
    if versions
      versions.each do |version|
        ShardVersionUpdateWorker.perform(
          shardfile_url: "https://raw.githubusercontent.com/#{name_with_owner}/v#{version.to_s}/shard.yml",
          shard_id: shard_id,
          string: version.to_s
        )
      end
    else
      ShardVersionUpdateWorker.perform(
        shardfile_url: "https://raw.githubusercontent.com/#{name_with_owner}/HEAD/shard.yml",
        shard_id: shard_id
      )
    end
  end

  private def versions
    release_tags.split(",").reduce([] of SemanticVersion) do |versions, tag|
      begin
        match	= tag.match(/^v(.*)/)
        versions << SemanticVersion.parse(match[1]) if match
      rescue
      end
    end
  end
end
