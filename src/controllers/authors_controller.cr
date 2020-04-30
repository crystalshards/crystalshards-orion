class AuthorsController < ApplicationController
  def index
    @hero_text = "Author Directory"
    render view: "authors/index.slang"
  end

  def show
    response.headers["Content-Type"] = "text/html"
    @hero_text = "Author Detail"
    render view: "authors/show.slang"
  end
end
