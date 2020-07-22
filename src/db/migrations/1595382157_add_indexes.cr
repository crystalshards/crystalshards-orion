class AddIndexes
  include Clear::Migration

  def change(dir)
    create_index "shards", "pushed_at"
    create_index "shards", "index"
    create_index "authors", "name"
  end
end
