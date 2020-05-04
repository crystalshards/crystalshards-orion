class Author
  include Clear::Model

  primary_key
  column name : String
  column email : String?
  column avatar_url : String?

  timestamps

  has_many shards : Shard, through: "shard_authors"

  scope :includes_uses do
    cte =
      Clear::SQL.select("COUNT(DISTINCT shards.project_id) AS use_count", "authors.id")
        .from("authors")
        .join("shard_authors") { shard_authors.author_id == authors.id }
        .join("shards AS owned_shards") { owned_shards.id == shard_authors.shard_id }
        .join("projects") { projects.id == owned_shards.project_id }
        .join("shard_dependencies") { shard_dependencies.dependency_id == projects.id }
        .join("shards") { shards.id == shard_dependencies.parent_id }
        .group_by("authors.id")

    with_cte({uses: cte})
      .select("authors.*", "uses.use_count")
      .inner_join("uses") { authors.id == uses.id }
  end

  scope :emails_only do
    where { authors.email =~ /@/ }
  end

  # Order by most used by other public shards
  scope :most_depended_on do
    includes_uses
      .includes_shard_count
      .emails_only
      .order_by("use_count": "DESC")
  end

  scope :includes_shard_count do
    cte =
      Clear::SQL.select("COUNT(DISTINCT shards.project_id) AS shard_count", "authors.id")
        .from("authors")
        .inner_join("shard_authors") { shard_authors.author_id == authors.id }
        .inner_join("shards") { shards.id == shard_authors.shard_id }
        .group_by("authors.id")

    with_cte({author_shards: cte})
      .select("authors.*", "author_shards.shard_count")
      .inner_join("author_shards") { authors.id == author_shards.id }
  end

  def initials
    name.split(" ").map(&.chars.first?).compact.join("")
  end

  def default_avatar_url
    initials_url = "https://avatars.dicebear.com/v2/initials/#{initials}.svg"
    return initials_url unless email
    hash = Digest::MD5.hexdigest email.to_s
    "https://www.gravatar.com/avatar/#{hash}?#{HTTP::Params.encode({ d: initials_url })}"
  end

  def name_is_username?
    !name.includes?(" ")
  end

  private def cache_key(*parts)
    (["authors", id] + parts.to_a).join("/")
  end
end
