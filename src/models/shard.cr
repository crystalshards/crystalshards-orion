class Shard
  include Clear::Model

  column id : UUID, primary: true, presence: false
  column name : String
  column provider : Provider
  column provider_uri : String
  column watcher_count : Int32
  column fork_count : Int32
  column star_count : Int32
  column pull_request_count : Int32
  column issue_count : Int32

  full_text_searchable

  def url
    @url ||= case provider
    when "github"
      "https://github.com/#{provider_uri}"
    when "gitlab"
      "https://gitlab.com/#{provider_uri}"
    when "bitbucket"
      "https://bitbucket.com/#{provider_uri}"
    when "git", "path"
      provider_uri
    end
  end

  def clone_url
    case provider
    when "github", "gitlab", "bitbucket"
      "#{url}.git"
    when "git"
      provider_uri
    end
  end
end
