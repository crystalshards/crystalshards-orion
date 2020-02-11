class GithubByLanguagePageWorker < Mosquito::QueuedJob
  params first : Int32 = 100
  params after : String
  params pushed_before : Time

  def perform
    search = Github.get_by_language(first: first, after: after)
    search.edges.each do |edge|
      repo = edge.node
      GithubShardUpdateWorker.peform(
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
    this.class.perform(first: first, after: search.edges.last.cursor, pushed_before: search.edges.last.node.updated_at)
  end
end
