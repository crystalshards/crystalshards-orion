class GithubByLanguageIndexWorker < Mosquito::PeriodicJob
  run_every 1.hour

  def perform
    GithubByLanguagePageWorker.new(first: 100).enqueue
  end
end
