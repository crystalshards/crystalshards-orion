class AddIndexToShards
  include Clear::Migration

  def change(dir)
    add_column "shards", "index", "boolean", default: "true"
  end
end
