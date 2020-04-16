class GithubByShardfileIndexWorker < Mosquito::PeriodicJob
  run_every 1.hour

  def perform
    per_page = 100
    Github.total_pages(strategy: Github::REST::ShardSearch, per_page: per_page).times do |index|
      GithubShardFilePageWorker.new(strategy: Github::REST::ShardSearch, per_page: per_page, page: index + 1).enqueue
    end
  end
end
