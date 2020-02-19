class CreateShardAuthors
  include Clear::Migration

  def change(dir)
    create_table(:shard_authors, :uuid) do |t|
      t.references "shards", type: :uuid, null: false
      t.references "authors", type: :uuid, null: false
      t.timestamps
    end
  end
end
