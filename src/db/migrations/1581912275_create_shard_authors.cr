class CreateShardAuthors
  include Clear::Migration

  def change(dir)
    create_table(:shard_authors, :uuid) do |t|
      t.references "shards", null: false, index: true
      t.references "authors", null: false, index: true
      t.timestamps
    end
  end
end
