class Job::Author::AvatarPeriodicJob < Mosquito::PeriodicJob
  run_every 1.hour

  def perform
    ::Author.emails_only.order_by("avatar_url", "DESC", "NULLS FIRST").each_with_cursor(100) do |author|
      if (github_user = Service::Github::REST::OwnerSearch.fetch(q: "#{author.email}+in%3Aemail", per_page: 1).items.first?)
        author.avatar_url = github_user.avatar_url
        author.save
      end
      sleep 1
    end
  end
end
