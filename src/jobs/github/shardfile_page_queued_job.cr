class Job::Github::ShardFilePageQueuedJob < Mosquito::QueuedJob
  params(
    page : Int32,
    per_page : Int32
  )

  def perform
    return if per_page * page > 1000
    Service::Github.get_by_shardfile(per_page: per_page, page: page).each do |repo|
      ProjectUpdateQueuedJob.new(
        api_id: repo.node_id,
        url: repo.html_url,
        description: repo.description || "",
        name_with_owner: repo.full_name,
        pushed_at: repo.pushed_at || Time.utc + Time::Span.new(days: 300),
      ).enqueue
    end
  end
end
