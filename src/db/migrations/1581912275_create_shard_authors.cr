class CreateShardAuthors
  include Clear::Migration

  def change(dir)
    create_table(:shard_authors, id: false) do |t|
      t.references "shards", null: false, on_delete: "CASCADE"
      t.references "authors", null: false, on_delete: "CASCADE"

      t.timestamps

      t.index [:shard_id, :author_id], unique: true
    end
  end
end
