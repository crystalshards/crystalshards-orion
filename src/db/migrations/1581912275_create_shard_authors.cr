class CreateShardAuthors
  include Clear::Migration

  def change(dir)
    create_table(:shard_authors, id: false) do |t|
      t.references "shards", type: :uuid, null: false
      t.references "authors", type: :uuid, null: false

      t.timestamps

      t.index ["shard_id", "author_id"], unique: true
    end

    dir.up do
      execute <<-SQL
        ALTER TABLE shard_authors ADD CONSTRAINT shard_authors_pkey primary key (shard_id, author_id);
      SQL
    end

    dir.down do
      execute <<-SQL
        ALTER TABLE shard_authors DROP CONSTRAINT shard_authors_pkey;
      SQL
    end
  end
end
