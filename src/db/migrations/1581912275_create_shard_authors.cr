class CreateShardAuthors
  include Clear::Migration

  def change(dir)
    create_table(:shard_authors, id: false) do |t|
      t.references "shards", type: :uuid, null: false
      t.references "authors", type: :uuid, null: false

      t.timestamps

      t.index ["shard_id", "author_id"], unique: true
    end
  end
end
