class Job::Shard::VersionUpdateQueuedJob < Mosquito::QueuedJob
  params(
    project_id : UUID,
    shardfile_url : String,
    version_string : String = ""
  )

  def deserialize_uuid(string)
    UUID.new(string)
  end

  def serialize_uuid(uuid)
    uuid.to_s
  end

  def perform
    shard_version = ::Shard.query.find({project_id: project_id, version: version}) || ::Shard.create(
      project_id: project_id,
      version: version,
      manifest: manifest
    )
  end

  private def manifest
    ::Manifest::Shard.from_yaml HTTP::Client.get(shardfile_url).body
  end

  private def version(string = version_string)
    SemanticVersion.parse(string) unless string.blank?
  end
end
