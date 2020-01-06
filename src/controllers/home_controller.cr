class HomeController < ApplicationController
  def home
    render("src/templates/home.slang")
  end
end
