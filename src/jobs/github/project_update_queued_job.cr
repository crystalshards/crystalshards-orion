class Job::Github::ProjectUpdateQueuedJob < Mosquito::QueuedJob
  include JobSerializers

  params(
    api_id : String,
    url : String,
    pushed_at : Time,
    name_with_owner : String,
    watcher_count : Int32 = -1,
    fork_count : Int32 = -1,
    star_count : Int32 = -1,
    pull_request_count : Int32 = -1,
    issue_count : Int32 = -1,
    tags : String = "",
    release_tags : String = "",
    default_branch : String = "HEAD"
  )

  def perform
    project = update_project

    # Create Versions
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

  def update_project
    # Find and and update by URL
    Project.query.find_or_create({provider: "github", uri: url}) { |p| set_project_attributes p }
  rescue
    # Find and update by API ID to catch renames
    Project.query.find_or_create({provider: "github", api_id: api_id}) { |p| set_project_attributes p }
  end

  private def set_project_attributes(project : Project)
    puts "Creating/Updating project: #{url}".colorize(:cyan)
    project.api_id = api_id
    project.uri = url
    project.tags = tags.split(",")
    project.pushed_at if pushed_at <= Time.utc
    project.watcher_count = watcher_count if watcher_count >= 0
    project.fork_count = fork_count if fork_count >= 0
    project.star_count = star_count if star_count >= 0
    project.pull_request_count = pull_request_count if pull_request_count >= 0
    project.issue_count = issue_count if issue_count >= 0
  end

  private def versions
    release_tags.split(",").each_with_object([] of String) do |tag, versions|
      match = tag.match(/^v(.+)/)
      version = match[1] if match
      versions << version if version
    end
  end
end
