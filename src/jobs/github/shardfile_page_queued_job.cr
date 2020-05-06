class Job::Github::ShardFilePageQueuedJob < Mosquito::QueuedJob
  params(
    page : Int32,
    per_page : Int32
  )

  def perform
    return if per_page * page > 1000
    Service::Github.get_by_shardfile(per_page: per_page, page: page).each do |repo|
      ProjectUpdateQueuedJob.with_payload(repo).enqueue
    end
  end
end
