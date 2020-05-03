class AuthorsController < ApplicationController
  def index
    @hero_text = "Top Authors of the Crystal The Community"
    most_impactful_authors = Author.most_depended_on.limit(50)
    render view: "authors/index.slang"
  end

  def show
    if (author = self.author)
      response.headers["Content-Type"] = "text/html"
      @hero_text = "Author Detail"
      render view: "authors/show.slang"
    else
      render_404
    end
  end

  private def author
    Author.query.find { (name == name_or_email) | (email == name_or_email) }
  end

  private def name_or_email
    request.path_params["email_or_name"] + request.format
  end
end
