class Job::Github::ProjectUpdateQueuedJob < Mosquito::QueuedJob
  class Payload
    include JSON::Serializable

    getter uri
    getter api_id
    getter pushed_at
    getter description
    getter homepage
    getter watcher_count
    getter star_count
    getter pull_request_count
    getter issue_count
    getter tags
    getter release_tags
    getter default_branch
    getter parent

    def self.new(repo : Service::Github::GraphQL::Repository)
      new(
        uri: repo.name_with_owner,
        api_id: repo.id,
        description: repo.description,
        watcher_count: repo.watchers.total_count,
        homepage: repo.homepage_url,
        star_count: repo.stargazers.total_count,
        pull_request_count: repo.pull_requests.total_count,
        issue_count: repo.issues.total_count,
        pushed_at: repo.pushed_at,
        parent: (parent = repo.parent) ? Payload.new(parent) : nil,
        tags: (t = repo.repository_topics.nodes) ? t.map(&.topic.name) : [] of String,
        release_tags: (nodes = repo.tags.nodes) ? nodes.map(&.name) : [] of String
      )
    end

    def self.new(repo : Service::Github::REST::Repository)
      new(
        uri: repo.full_name,
        api_id: repo.node_id,
        description: repo.description,
        homepage: repo.homepage,
        pushed_at: repo.pushed_at,
        watcher_count: repo.watchers_count,
        star_count: repo.stargazers_count,
        issue_count: repo.open_issues_count,
        default_branch: repo.default_branch || "HEAD"
      )
    end

    def initialize(
      *,
      @uri : String,
      @api_id : String? = nil,
      @description : String? = nil,
      @pushed_at : Time? = nil,
      @watcher_count : Int32? = nil,
      @star_count : Int32? = nil,
      @issue_count : Int32? = nil,
      @pull_request_count : Int32? = nil,
      @parent : Payload? = nil,
      @tags : Array(String) = [] of String,
      @release_tags : Array(String) = [] of String,
      @default_branch : String = "HEAD"
    ); end
  end

  params(
    payload : Payload
  )

  def self.with_payload(*args, **params)
    new payload: Payload.new(*args, **params)
  end

  def serialize_job__github__project_update_queued_job__payload(p : Payload)
    p.to_json
  end

  def deserialize_job__github__project_update_queued_job__payload(s : String)
    Payload.from_json s
  end

  def perform
    project = update_project

    # Create Versions
    unless versions.empty?
      versions.each do |version|
        Shard::VersionUpdateQueuedJob.new(
          shardfile_url: "https://raw.githubusercontent.com/#{payload.uri}/v#{version}/shard.yml",
          project_id: project.id,
          git_tag: version
        ).enqueue
      end
    else
      Shard::VersionUpdateQueuedJob.new(
        shardfile_url: "https://raw.githubusercontent.com/#{payload.uri}/#{payload.default_branch}/shard.yml",
        project_id: project.id
      ).enqueue
    end
  end

  private def update_project(payload = self.payload)
    puts "Creating/Updating project: github:#{payload.uri}".colorize(:cyan)
    project = get_project
    project.api_id = payload.api_id
    project.uri = payload.uri
    project.tags = payload.tags
    project.pushed_at = payload.pushed_at
    project.watcher_count = payload.watcher_count
    project.star_count = payload.star_count
    project.pull_request_count = payload.pull_request_count
    project.issue_count = payload.issue_count
    project.description = payload.description
    if (parent = payload.parent)
      project.mirror_type = MirrorType.from_string("fork")
      project.mirrored = update_project(parent)
    end
    project.tap(&.save)
  end

  private def get_project(payload = self.payload)
    # Find and and update by URL
    Project.query.find_or_build({provider: "github", uri: payload.uri}) { }
  rescue
    # Find and update by API ID to catch renames
    Project.query.find_or_build({provider: "github", api_id: payload.api_id}) { }
  end

  private def versions
    payload.release_tags.each_with_object([] of String) do |tag, versions|
      match = tag.match(/^v(.+)/)
      version = match[1] if match
      versions << version if version
    end
  end
end
