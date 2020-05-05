require "./has_version"
require "./git_ref"

class Manifest::Shard::Dependency::Git
  include JSON::Serializable
  include YAML::Serializable
  include HasVersion
  include GitRef

  getter git : String

  def provider
    host, path = parse
    case host
    when "github.com"
      "github"
    when "gitlab.com"
      "gitlab"
    when "bitbucket.com"
      "bitbucket"
    else
      "git"
    end
  end

  def uri
    host, path = parse
    case host
    when "github.com", "gitlab.com", "bitbucket.com"
      path
    else
      git
    end
  end

  private def parse
    if (match = git.match(/.+@(?<host>.+):(?<path>.+)\.git/))
      host = match["host"]
      path = match["path"]
      {host, path}
    elsif (uri = URI.parse(git))
      {uri.host, uri.path.rchop(".git")}
    else
      {nil, nil}
    end
  end
end
