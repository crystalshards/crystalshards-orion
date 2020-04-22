class Project
  include Clear::Model

  primary_key
  column provider : Provider
  column uri : String
  column api_id : String?
  column watcher_count : Int32, presence: false
  column fork_count : Int32, presence: false
  column star_count : Int32, presence: false
  column pull_request_count : Int32, presence: false
  column issue_count : Int32, presence: false
  column mirror_type : MirrorType?
  timestamps

  belongs_to mirrored : Project, foreign_key: "mirrored_id", key_type: Int64?
  has_many mirrors : Project, foreign_key: "mirrored_id"

  def url
    @url ||= case provider
             when "github"
               "https://github.com/#{uri}"
             when "gitlab"
               "https://gitlab.com/#{uri}"
             when "bitbucket"
               "https://bitbucket.com/#{uri}"
             when "git", "path"
               uri
             end
  end

  def clone_url
    case provider
    when "github", "gitlab", "bitbucket"
      "#{url}.git"
    when "git"
      uri
    end
  end
end
