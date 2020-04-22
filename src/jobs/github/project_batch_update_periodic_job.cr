class Job::Github::ProjectBatchUpdatePeriodicJob < Mosquito::PeriodicJob
  run_every 1.hour

  def perform
    # Fetch node_ids in batches
    id_collector = Channel(String).new
    spawn do
      Project.query.where { (provider == "github") & (api_id != nil) }.select("api_id").each_with_cursor(100) do |project|
        id_collector.send(project.api_id.not_nil!)
      end
      id_collector.close
    end

    # Collect the node ids and batch an api call
    node_ids = [] of String
    while (node_id = id_collector.receive?)
      node_ids << node_id
      if (node_ids.size == 100)
        ::Service::Github.fetch(node_ids: node_ids).each do |repo|
          ProjectUpdateQueuedJob.new(
            api_id: repo.id,
            url: repo.url,
            watcher_count: repo.watchers.total_count || 0,
            fork_count: repo.forks.total_count || 0,
            star_count: repo.stargazers.total_count || 0,
            pull_request_count: repo.pull_requests.total_count || 0,
            issue_count: repo.issues.total_count || 0,
            release_tags: (nodes = repo.tags.nodes) ? nodes.map(&.name).join(",") : "",
            name_with_owner: repo.name_with_owner
          ).enqueue
        end
        node_ids = [] of String
      end
    end
  end
end
