class Job::Shard::VersionUpdateQueuedJob < Mosquito::QueuedJob
  class Payload
    include JSON::Serializable

    getter project_id : Int64
    getter raw_base_url : String
    getter git_tag : Service::Github::GraphQL::Ref?

    def initialize(
      *,
      @project_id : Int64,
      @raw_base_url : String,
      @git_tag : Service::Github::GraphQL::Ref? = nil
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
      tag_name = payload.git_tag.try(&.name)
      shard = ::Shard.query.find_or_build({project_id: payload.project_id, git_tag: tag_name}) { }
      Log.info { "#{shard.persisted? ? "Updating" : "Creating"} shard: #{m.name}@#{m.version}".colorize(:cyan) }
      shard.manifest = m
      shard.readme = readme
      shard.git_tag = tag_name
      shard.pushed_at = pushed_date
      shard.save
    end
  end

  protected def pushed_date
    payload.git_tag.try(&.commit.try(&.pushed_date)) ||
      payload.git_tag.try(&.commit.try(&.authored_date)) ||
      payload.git_tag.try(&.try(&.tag.try(&.commit.try(&.pushed_date)))) ||
      payload.git_tag.try(&.try(&.tag.try(&.commit.try(&.authored_date))))
  end

  protected def manifest : ::Manifest::Shard?
    Log.debug { "Fetching shardfile: #{payload.raw_base_url}/shard.yml".colorize(:yellow) }
    response = HTTP::Client.get("#{payload.raw_base_url}/shard.yml")
    Log.debug { "Response: #{response.status_code}".colorize(response.status_code === 200 ? :light_green : :light_red) }
    raise "Bad Response: #{response.status_code}" unless response.status_code === 200
    ::Manifest::Shard.from_yaml response.body
  rescue e
    Log.debug { "Project does not have a valid shard file: #{e.message}" }
    nil
  end

  protected def readme : String?
    possible_filenames = ["README.md", "readme.md", "Readme.md"]
    body = nil
    until body || possible_filenames.empty?
      url = "#{payload.raw_base_url}/#{possible_filenames.shift}"
      Log.debug { "Fetching readme: #{url}".colorize(:yellow) }
      response = HTTP::Client.get(url)
      Log.debug { "Response: #{response.status_code}".colorize(response.status_code === 200 ? :light_green : :light_red) }
      response.body if response.status_code === 200
    end
    return body
  end
end
