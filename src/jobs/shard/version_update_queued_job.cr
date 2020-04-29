class Job::Shard::VersionUpdateQueuedJob < Mosquito::QueuedJob
  class Payload
    include JSON::Serializable

    getter project_id : Int64
    getter shardfile_url : String
    getter readme_url : String
    getter git_tag : Service::Github::GraphQL::Tag?

    def initialize(
      *,
      @project_id : Int64,
      @shardfile_url : String,
      @readme_url : String,
      @git_tag : Service::Github::GraphQL::Tag? = nil,
    ); end
  end

  params(
    payload : Payload
  )

  def self.with_payload(*args, **params)
    new payload: Payload.new(*args, **params)
  end

  def serialize_job__shard__version_update_queued_job__payload(p : Payload)
    p.to_json
  end

  def deserialize_job__shard__version_update_queued_job__payload(s : String)
    Payload.from_json s
  end

  def perform
    if (manifest = self.manifest)
      m = manifest.not_nil!
      puts "Creating/Updating shard version: #{m.name}@#{m.version}".colorize(:cyan)
      shard = ::Shard.query.find_or_build({project_id: payload.project_id, git_tag: payload.git_tag.try(&.name)}) { }
      shard.manifest = m
      shard.readme = readme
      shard.git_tag = payload.git_tag.try(&.name)
      shard.pushed_at = payload.git_tag.try(&.commit.pushed_date)
      shard.save
    end
  end

  protected def manifest : ::Manifest::Shard?
    puts "Fetching shardfile: #{payload.shardfile_url}".colorize(:yellow)
    response = HTTP::Client.get(payload.shardfile_url)
    puts "Response: #{response.status_code}".colorize(response.status_code === 200 ? :light_green : :light_red)
    raise "Bad Response: #{response.status_code}" unless response.status_code === 200
    ::Manifest::Shard.from_yaml response.body
  rescue e
    puts "Project does not have a valid shard file: #{e.message}"
  end

  protected def readme : String?
    puts "Fetching readme: #{payload.readme_url}".colorize(:yellow)
    response = HTTP::Client.get(payload.readme_url)
    puts "Response: #{response.status_code}".colorize(response.status_code === 200 ? :light_green : :light_red)
    response.body if response.status_code === 200
  end
end
