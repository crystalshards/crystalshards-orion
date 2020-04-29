class AddHomepageToProject
  include Clear::Migration

  def change(dir)
    add_column "projects", "homepage", "text", nullable: true
  end
end
