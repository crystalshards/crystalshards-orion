class Job::Github::LanguagePageQueuedJob < Mosquito::QueuedJob
  include JobSerializers

  params(
    page : Int32 = 1,
    per_page : Int32 = 100,
    pushed_before : Time = Time.utc + Time::Span.new(days: 1)
  )

  def perform
    return if per_page * page >= 1000
    repos = Service::Github.get_by_language(per_page: per_page, page: page, pushed_before: pushed_before)
    repos.each do |repo|
      ProjectUpdateQueuedJob.new(
        api_id: repo.node_id,
        url: repo.html_url,
        name_with_owner: repo.full_name,
        watcher_count: repo.watchers_count || 0,
        fork_count: repo.forks_count || 0,
        star_count: repo.stargazers_count || 0,
        pull_request_count: 0,
        issue_count: repo.open_issues_count || 0,
        default_branch: repo.default_branch || "HEAD"
      ).enqueue
    end
    # if page < Service::Github.total_pages_by_language
    # end
    # Service::Github.get_by_language(per_page: per_page, page: page, pushed_before: pushed_before)
    # return unless (last_repo = repos.last?)
    # self.class.new(pushed_before: last_repo.pushed_at).enqueue
  end
end
