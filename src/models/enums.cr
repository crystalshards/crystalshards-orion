Clear.enum Provider, "github", "gitlab", "bitbucket", "git", "path" do
  def base_url
    case self
    when Provider::Github
      "https://github.com/"
    when Provider::Gitlab
      "https://gitlab.com/"
    when Provider::Bitbucket
      "https://bitbucket.com/"
    else
      nil
    end
  end

  def raw_base_url
    case self
    when Provider::Github
      "https://raw.githubusercontent.com/"
    else
      base_url
    end
  end

  def image_replace(content : String, uri : String, ref : String?)
    case self
    when Provider::Github
      content
        .gsub("<img src=\"#{base_url}", "<img src=\"#{raw_base_url}")
        .gsub("/blob/", "/")
        .gsub("/raw/", "/")
        .gsub(/<img src="(?!(.+?:\/\/|\/))([^"]*)"/, "<img src=\"#{raw_base_url}#{uri}/#{ref || "HEAD"}/\\2\"")
    else
      content
    end
  end
end
Clear.enum RefType, "version", "tag", "branch", "commit"
Clear.enum MirrorType, "mirror", "fork", "legacy", "similar"
