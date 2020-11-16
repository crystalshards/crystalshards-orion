class AuthorsController < ApplicationController
  def index
    @hero_text = "Top Authors of the Crystal The Community"
    render view: "index.slang", locals: {
      most_impactful_authors: Author.most_depended_on.limit(50)
    }
  end

  def show
    if (author = self.author)
      response.headers["Content-Type"] = "text/html"
      @hero_text = "Author Detail"
      render view: "show.slang", locals: {
        author: author
      }
    else
      raise Orion::RoutingError.new "Author Not Found"
    end
  end

  private def author
    Author.query.find { (name == name_or_email) | (email == name_or_email) }
  end

  private def name_or_email
    request.path_params["email_or_name"] + File.extname(resource)
  end
end
