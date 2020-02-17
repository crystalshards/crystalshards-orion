class CreateShards
  include Clear::Migration

  def change(dir)
    create_table(:shards, :uuid) do |t|
      t.column :name, :string, index: true, null: false
      t.column :provider, :provider, null: false
      t.timestamps
    end
  end
end
