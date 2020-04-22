class AddPushedAtToProject
  include Clear::Migration

  def change(dir)
    add_column "projects", "pushed_at", "timestamp without time zone", nullable: true
  end
end
