class Service::Github::REST::Repository
  JSON.mapping(
    node_id: String,
    html_url: String,
    owner: Github::REST::Owner,
    url: String
  )

  def git_url
    "#{url}.git"
  end
end
