class Job::Github::ShardFilePageQueuedJob < Mosquito::QueuedJob
  params(
    page : Int32,
    per_page : Int32
  )

  def perform
    Service::Github.get_by_shardfile(per_page: per_page, page: page).each do |repo|
      ProjectUpdateQueuedJob.new(
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
  end
end
