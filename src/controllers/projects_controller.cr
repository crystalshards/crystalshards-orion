class ProjectsController < ApplicationController
  def index
    @hero_text = "Project Directory"
    render view: "projects/index.slang"
  end

  def show
    @hero_text = "Project Detail"
    render view: "projects/show.slang"
  end

  def new
    @hero_text = "Add Project"
    render view: "projects/new.slang"
  end

  def create
  end
end
