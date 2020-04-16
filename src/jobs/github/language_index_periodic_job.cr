class Job::Github::LanguageIndexPerodicJob < Mosquito::PeriodicJob
  run_every 1.hour

  def perform
    LanguagePageQueuedJob.new(first: 100).enqueue
  end
end
