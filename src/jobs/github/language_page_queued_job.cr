class Job::Github::LanguagePageQueuedJob < Mosquito::QueuedJob
  include JobSerializers

  params(
    first : Int32 = 100,
    after : String = "",
    pushed_before : Time = Time.utc
  )

  def perform
    search = Service::Github.get_by_language(first: first, after: after.blank? ? nil : after, pushed_before: pushed_before)
    return unless (edges = search.edges)
    edges.each do |edge|
      next unless (repo = edge.node)
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
    next_pushed_before = ((last_repo = edges.last.node) ? last_repo.updated_at : nil) || pushed_before
    self.class.new(first: first, after: edges.last.cursor.to_s, pushed_before: next_pushed_before).enqueue
  end
end
