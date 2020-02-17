class CreateProviderEnum
  include Clear::Migration

  def change(dir)
    create_enum("provider", %w(github gitlab bitbucket git path))
  end
end
