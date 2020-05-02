class AddAvatarUrlToAuthor
  include Clear::Migration

  def change(dir)
    add_column "authors", "avatar_url", "text", nullable: true
  end
end
