class Job::Github::ProjectURLUpdatePeriodicJob < Mosquito::PeriodicJob
  run_every 1.hour

  def perform
    Project.query.where { (provider == "github") & (api_id == nil) }.select("uri").each_with_cursor(100) do |project|
      if (repo = ::Service::Github.fetch(url: project.url))
        ProjectUpdateQueuedJob.new(
          api_id: repo.id,
          url: repo.url,
          description: repo.description || "",
          watcher_count: repo.watchers.total_count || -1,
          fork_count: repo.forks.total_count || -1,
          star_count: repo.stargazers.total_count || -1,
          pull_request_count: repo.pull_requests.total_count || -1,
          issue_count: repo.issues.total_count || -1,
          pushed_at: repo.pushed_at || Time.utc + Time::Span.new(days: 300),
          tags: (t = repo.repository_topics.nodes) ? t.map(&.topic.name).join(",") : "",
          release_tags: (nodes = repo.tags.nodes) ? nodes.map(&.name).join(",") : "",
          name_with_owner: repo.name_with_owner
        ).enqueue
      end
    end
  end
end
