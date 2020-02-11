class GithubByLanguageIndexWorker < Mosquito::PeriodicJob
  run_every 1.hour

  def perform
    GithubByLanguagePageWorker.perform(first: 100)
  end
end
