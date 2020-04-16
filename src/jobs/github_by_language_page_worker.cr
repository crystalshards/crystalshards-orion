class GithubByLanguagePageWorker < Mosquito::QueuedJob
  include JobSerializers

  params(
    first : Int32 = 100,
    after : String = "",
    pushed_before : String = ""
  )

  def perform
    search = Github.get_by_language(first: first, after: after.blank? ? nil : after, pushed_before: pushed_before.blank? ? nil : pushed_before)
    search.edges.each do |edge|
      repo = edge.node
      GithubProjectUpdateWorker.peform(
        url: repo.url,
        watcher_count: repo.watchers.total_count,
        fork_count: repo.forks.total_count,
        star_count: repo.stargazers.total_count,
        pull_request_count: repo.pull_requests.total_count,
        issue_count: repo.issues.total_count,
        release_tags: repo.releases.nodes.map(&.tag_name).join(","),
        name_with_owner: repo.name_with_owner
      )
    end
    self.class.new(first: first, after: search.edges.last.cursor, pushed_before: search.edges.last.node.updated_at).enqueue
  end
end
