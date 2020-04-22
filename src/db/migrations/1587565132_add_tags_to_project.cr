class AddTagsToProject
  include Clear::Migration

  def change(dir)
    add_column "projects", "tags", "text[]", default: "'{}'", nullable: false
  end
end
