class Job::Shard::VersionUpdateQueuedJob < Mosquito::QueuedJob
  params(
    project_id : Int64,
    shardfile_url : String,
    git_tag : String = ""
  )

  def perform
    update_shard
  end

  private def update_shard
    if (manifest = self.manifest)
      m = manifest.not_nil!
      ::Shard.query.find_or_create({project_id: project_id, git_tag: git_tag}) do |shard|
        puts "Creating/Updating shard version: #{m.name}@#{m.version}".colorize(:cyan)
        shard.manifest = m
        shard.git_tag = git_tag
      end
    end
  end

  protected def manifest : ::Manifest::Shard?
    puts "Fetching shardfile: #{shardfile_url}".colorize(:yellow)
    response = HTTP::Client.get(shardfile_url)
    puts "Response: #{response.status_code}".colorize(response.status_code === 200 ? :light_green : :light_red)
    if response.status_code === 200
      ::Manifest::Shard.from_yaml response.body
    end
  end
end
