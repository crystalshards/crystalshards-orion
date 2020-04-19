class Job::Github::ProjectUpdateQueuedJob < Mosquito::QueuedJob
  params(
    api_id : String,
    url : String,
    name_with_owner : String,
    watcher_count : Int32 = 0,
    fork_count : Int32 = 0,
    star_count : Int32 = 0,
    pull_request_count : Int32 = 0,
    issue_count : Int32 = 0,
    release_tags : String = "",
    default_branch : String = "HEAD"
  )

  def perform
    project = update_project || create_project
    unless versions.empty?
      versions.each do |version|
        Shard::VersionUpdateQueuedJob.new(
          shardfile_url: "https://raw.githubusercontent.com/#{name_with_owner}/v#{version.to_s}/shard.yml",
          project_id: project.id,
          git_tag: version.to_s
        ).enqueue
      end
    else
      Shard::VersionUpdateQueuedJob.new(
        shardfile_url: "https://raw.githubusercontent.com/#{name_with_owner}/#{default_branch}/shard.yml",
        project_id: project.id
      ).enqueue
    end
  end

  private def update_project
    if (project = Project.query.find({provider: "github", api_id: api_id}))
      puts "Updating project: #{url}"
      project.update(
        watcher_count: watcher_count,
        fork_count: fork_count,
        star_count: star_count,
        pull_request_count: pull_request_count,
        issue_count: issue_count
      )
      return project
    end
  end

  private def create_project
    puts "Creating project: #{url}"
    Project.create!(
      provider: "github",
      api_id: api_id,
      uri: url,
      watcher_count: watcher_count,
      fork_count: fork_count,
      star_count: star_count,
      pull_request_count: pull_request_count,
      issue_count: issue_count
    )
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
