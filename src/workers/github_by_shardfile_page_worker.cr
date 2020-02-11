class GithubShardFilePageWorker < Mosquito::QueuedJob
  params page : Int32
  params per_page : Int32

  def perform
    Github.get_by_shardfile(per_page: per_page, page: page).each do |repo|
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
  end
end
