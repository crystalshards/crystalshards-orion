class DropForkCount
  include Clear::Migration

  def change(dir)
    drop_column "projects", "fork_count", "integer"
  end
end
