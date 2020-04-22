class Job::Shard::VersionUpdateQueuedJob < Mosquito::QueuedJob
  params(
    project_id : Int64,
    shardfile_url : String,
    git_tag : String = ""
  )

  def perform
    update_shard || create_shard
  end

  private def create_shard
    if (manifest = self.manifest)
      puts "Creating shard version: #{manifest.name}@#{manifest.version}"
      ::Shard.create!(
        project_id: project_id,
        manifest: manifest,
        git_tag: git_tag
      )
    end
  end

  private def update_shard
    if (manifest = self.manifest) && (shard = ::Shard.query.find({project_id: project_id, git_tag: git_tag}))
      puts "Updating shard version: #{manifest.name}@#{manifest.version}"
      shard.update(
        manifest: manifest,
        git_tag: git_tag
      )
      return shard
    end
  end

  private def manifest
    puts "Fetching shardfile: #{shardfile_url}"
    response = HTTP::Client.get(shardfile_url)
    puts "Response: #{response.status_code}"
    if response.status_code === 200
      ::Manifest::Shard.from_yaml response.body
    end
  end
end
