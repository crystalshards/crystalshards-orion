class Job::Github::ShardfilePeriodicJob < Mosquito::PeriodicJob
  run_every 1.hour

  def perform
    per_page = 100
    Service::Github.total_pages_by_shardfile(per_page: per_page).times do |index|
      ShardFilePageQueuedJob.new(per_page: per_page, page: index + 1).enqueue
    end
  end
end
