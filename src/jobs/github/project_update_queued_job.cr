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
        watcher_count: repo.watchers.try(&.total_count),
        homepage: repo.homepage_url,
        star_count: repo.stargazers.try(&.total_count),
        pull_request_count: repo.pull_requests.try(&.total_count),
        issue_count: repo.issues.try(&.total_count),
        pushed_at: repo.pushed_at,
        parent: (parent = repo.parent) ? Payload.new(parent) : nil,
        tags: (t = repo.repository_topics.try(&.nodes)) ? t.map(&.topic.name) : [] of String,
        release_tags: (nodes = repo.tags.try(&.nodes)) ? nodes : [] of Service::Github::GraphQL::Ref
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
      @homepage : String? = nil,
      @tags : Array(String)? = nil,
      @release_tags : Array(Service::Github::GraphQL::Ref) = [] of Service::Github::GraphQL::Ref,
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
      versions.each do |tag|
        Shard::VersionUpdateQueuedJob.with_payload(
          shardfile_url: "https://raw.githubusercontent.com/#{payload.uri}/#{tag.name}/shard.yml",
          readme_url: "https://raw.githubusercontent.com/#{payload.uri}/#{tag.name}/README.md",
          project_id: project.id,
          git_tag: tag,
        ).enqueue
      end
    else
      Shard::VersionUpdateQueuedJob.with_payload(
        shardfile_url: "https://raw.githubusercontent.com/#{payload.uri}/#{payload.default_branch}/shard.yml",
        readme_url: "https://raw.githubusercontent.com/#{payload.uri}/#{payload.default_branch}/README.md",
        project_id: project.id
      ).enqueue
    end
  end

  private def update_project(payload = self.payload)
    project = get_project
    Log.debug { "#{project.persisted? ? "Updating" : "Creating"} project: github:#{payload.uri}".colorize(:cyan) }
    project.uri = payload.uri
    project.api_id = payload.api_id unless payload.api_id.nil?
    project.tags = payload.tags.not_nil! unless payload.tags.nil?
    project.pushed_at = payload.pushed_at unless payload.pushed_at.nil?
    project.watcher_count = payload.watcher_count unless payload.watcher_count.nil?
    project.star_count = payload.star_count unless payload.star_count.nil?
    project.pull_request_count = payload.pull_request_count unless payload.pull_request_count.nil?
    project.issue_count = payload.issue_count unless payload.issue_count.nil?
    project.description = payload.description unless payload.description.nil?
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
    payload.release_tags.each_with_object([] of Service::Github::GraphQL::Ref) do |tag, tags|
      match = tag.name.to_s.match(/^v(.+)/)
      tags << tag if match
    end
  end
end
