class Job::Github::ProjectBatchUpdatePeriodicJob < Mosquito::PeriodicJob
  run_every 24.hours

  def perform
    # Fetch node_ids in batches
    id_collector = Channel(String).new
    spawn do
      Project.query.where { (provider == "github") & (api_id != nil) }.select("api_id").order_by("random()").each_with_cursor(100) do |project|
        id_collector.send(project.api_id.not_nil!)
      end
      id_collector.close
    end

    # Collect the node ids and batch an api call
    node_ids = [] of String
    while (node_id = id_collector.receive?)
      node_ids << node_id
      if (node_ids.size == 100)
        ProjectBatchPageQueuedJob.with_payload(node_ids: node_ids).enqueue
        node_ids = [] of String
      end
    end

    # Capture any remaining node_ids
    ProjectBatchPageQueuedJob.with_payload(node_ids: node_ids).enqueue
  end
end
