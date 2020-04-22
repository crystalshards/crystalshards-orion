class Job::Shard::VersionUpdateQueuedJob < Mosquito::QueuedJob
  params(
    project_id : Int64,
    shardfile_url : String,
    git_tag : String = ""
  )

  def perform
    if (manifest = self.manifest)
      m = manifest.not_nil!
      puts "Creating/Updating shard version: #{m.name}@#{m.version}".colorize(:cyan)
      shard = ::Shard.query.find_or_build({project_id: project_id, git_tag: git_tag}) { }
      shard.manifest = m
      shard.git_tag = git_tag
      shard.save
    end
  end

  protected def manifest : ::Manifest::Shard?
    puts "Fetching shardfile: #{shardfile_url}".colorize(:yellow)
    response = HTTP::Client.get(shardfile_url)
    puts "Response: #{response.status_code}".colorize(response.status_code === 200 ? :light_green : :light_red)
    raise "Bad Response: #{response.status_code}" unless response.status_code === 200
    ::Manifest::Shard.from_yaml response.body
  rescue e
    puts "Project does not have a valid shard file: #{e.message}"
  end
end
