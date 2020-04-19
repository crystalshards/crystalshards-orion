class Service::Github::REST::Repository
  include JSON::Serializable

  getter node_id : String
  getter html_url : String
  getter full_name : String
  getter pushed_at : Time?
  getter stargazers_count : Int32?
  getter watchers_count : Int32?
  getter forks_count : Int32?
  getter open_issues_count : Int32?
  getter default_branch : String?

  def git_url
    "#{url}.git"
  end
end
