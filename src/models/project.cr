class Project
  include Clear::Model

  primary_key name: "id", type: :uuid
  column provider : Provider
  column api_id : String
  column uri : String
  column watcher_count : Int32
  column fork_count : Int32
  column star_count : Int32
  column pull_request_count : Int32
  column issue_count : Int32
  column mirror_type : MirrorType?

  belongs_to mirrored : Project, foreign_key: "mirrored_id", key_type: UUID?
  has_many mirrors : Project, foreign_key: "mirrored_id", foreign_key_type: UUID?

  def url
    @url ||= case provider
             when "github"
               "https://github.com/#{provider_uri}"
             when "gitlab"
               "https://gitlab.com/#{provider_uri}"
             when "bitbucket"
               "https://bitbucket.com/#{provider_uri}"
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
