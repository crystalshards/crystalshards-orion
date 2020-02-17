class CreateShardRefAuthors
  include Clear::Migration

  def change(dir)
    create_table(:shard_ref_authors, :uuid) do |t|
      t.references "shard_refs", type: :uuid, null: false
      t.column :name, type: :string, null: false
      t.column :email, type: :string
      t.timestamps
    end
  end
end
