class Job::Github::LanguageIndexPerodicJob < Mosquito::PeriodicJob
  run_every 24.hours

  def self.paginate(*, per_page = 100, pushed_before = Time.utc)
    Service::Github.total_pages_by_language(per_page: per_page).times do |index|
      LanguagePageQueuedJob.new(per_page: per_page, page: index + 1, pushed_before: pushed_before).enqueue
    end
  end

  def perform
    self.class.paginate
  end
end
