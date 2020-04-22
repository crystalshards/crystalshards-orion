class CreateShardAuthors
  include Clear::Migration

  def change(dir)
    create_table(:shard_authors, id: false) do |t|
      t.references "shards", null: false
      t.references "authors", null: false

      t.timestamps

      t.index [:shard_id, :author_id], unique: true
    end
  end
end
