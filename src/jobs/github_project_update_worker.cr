class GithubProjectUpdateWorker < Mosquito::QueuedJob
  params(
    url : String,
    name_with_owner : String,
    watcher_count : Int32,
    fork_count : Int32,
    star_count : Int32,
    pull_request_count : Int32,
    issue_count : Int32,
    release_tags : String
  )

  def perform
    project = Project.query.find({provider: "github", uri: url}) || Project.create(
      provider: "github",
      uri: url,
      watcher_count: watcher_count,
      fork_count: fork_count,
      star_count: star_count,
      pull_request_count: pull_request_count,
      issue_count: issue_count
    )
    if versions
      versions.each do |version|
        ShardVersionUpdateWorker.new(
          shardfile_url: "https://raw.githubusercontent.com/#{name_with_owner}/v#{version.to_s}/shard.yml",
          project_id: project.id,
          version_string: version.to_s
        ).enqueue
      end
    else
      ShardVersionUpdateWorker.new(
        shardfile_url: "https://raw.githubusercontent.com/#{name_with_owner}/HEAD/shard.yml",
        project_id: project.id
      ).enqueue
    end
  end

  private def versions
    release_tags.split(",").each_with_object([] of SemanticVersion) do |tag, versions|
      begin
        match = tag.match(/^v(.*)/)
        version = SemanticVersion.parse(match[1]) if match
        versions << version if version
      rescue
      end
    end
  end
end
