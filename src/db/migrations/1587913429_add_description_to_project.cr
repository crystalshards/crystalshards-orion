class AddDescriptionToProject
  include Clear::Migration

  def change(dir)
    add_column "projects", "description", "text", nullable: true
  end
end
