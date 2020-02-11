class CreateUsers
  include Clear::Migration

  def change(dir)
    create_table(:users) do |t|
      t.column :first_name, :string, index: true
      t.column :last_name, :string, unique: true

      t.timestamps
    end
  end
end
