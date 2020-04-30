class Shard
  include Clear::Model

  # Columns
  primary_key
  column manifest : Manifest::Shard
  column name : String
  column version : String
  column git_tag : String?
  column license : String?
  column readme : String?
  column pushed_at : Time?
  column description : String?
  column crystal : String?
  column tags : Array(String)?

  timestamps

  # Associations
  belongs_to project : Project
  has_many dependencies : ShardDependency, foreign_key: "parent_id"
  has_many authors : Author, through: "shard_authors"

  # Copy spec data to shard
  before :validate do |model|
    model.as(self).update_from_manifest!
  end

  after :save do |model|
    model.as(self).associate_authors!
    model.as(self).associate_dependencies!
  end

  after :create do |model|
    model.as(self).associate_authors!
    model.as(self).associate_dependencies!
  end

  scope :versions do
    where { git_tag != nil }
  end

  # Ranked within project (in order to get the latest release)
  scope :latest_in_project do
    # Set the has_tag field
    has_tags_cte =
      dup.select({
        id: "shards.id",
        has_tag: "CASE git_tag WHEN null THEN 0 WHEN '' THEN 0 ELSE 1 END"
      })

    # Rank the shards
    ranked_cte =
      dup.select({
        id: "shards.id",
        rank: "row_number() OVER (PARTITION BY shards.project_id ORDER BY shards_with_has_tag.has_tag ASC, shards.created_at DESC NULLS LAST)"
      })
      .inner_join("shards_with_has_tag") { shards_with_has_tag.id == shards.id }

    # Select the first in rank
    with_cte({
      shards_with_has_tag: has_tags_cte.to_sql,
      ranked: ranked_cte.to_sql,
    })
      .where { ranked.rank == 1 }
      .inner_join("ranked") { ranked.id == shards.id }
  end

  # Order by recently updated
  scope :recently_released do
    where_valid
      .latest_in_project
      .order_by("shards.pushed_at", "DESC", "NULLS LAST")
  end

  scope :originals do
    latest_in_project
      .inner_join("projects") { projects.id == shards.project_id }
      .where { projects.mirrored_id == nil }
  end

  scope :where_valid do
    where { (name != nil) & (name != "") & (version != nil) & (version != "") }
  end

  # Order by the most stars
  scope :popular do
    where_valid
      .latest_in_project
      .inner_join("projects") { projects.id == shards.project_id }
      .order_by("projects.star_count", "DESC", "NULLS LAST")
  end

  # Order by most used by other public shards
  scope :most_used do
    where_valid
      .latest_in_project
      .includes_uses
      .order_by("use_count": "DESC")
  end

  scope :includes_uses do
    cte =
      Clear::SQL.select("COUNT(DISTINCT shards.project_id) AS use_count", "dependencies.id")
        .from("shards")
        .inner_join("shard_dependencies") { shard_dependencies.parent_id == shards.id }
        .inner_join("projects AS dependencies") { shard_dependencies.dependency_id == dependencies.id }
        .group_by("dependencies.id")
        .order_by("use_count")
    with_cte({uses: cte}).inner_join("uses") { shards.project_id == uses.id }
  end

  scope :by_provider do |name|
    inner_join("projects") { projects.id == shards.project_id }
      .where { projects.provider == name }
  end

  def formatted_description
    Emoji.emojize(description || project.description || "No Description")
  end

  def homepage_url
    homepage = manifest.homepage || project.homepage
    unless !homepage || homepage.empty?
      URI.parse(homepage)
    end
  rescue
    nil
  end

  def documentation_url
    documentation = manifest.documentation
    unless !documentation || documentation.empty?
      URI.parse(documentation)
    end
  rescue
    nil
  end

  def all_tags
    (self.tags + project.tags).unique
  end

  protected def update_from_manifest!
    self.name = manifest.name
    self.version = manifest.version
    self.license = manifest.license
    self.description = manifest.description
    self.crystal = manifest.crystal
    self.tags = manifest.tags
  end

  protected def associate_dependencies!
    # Associate release deps
    (manifest.dependencies || {} of String => Manifest::Shard::Dependency::Provider).each do |name, dependency|
      if (dep = ShardDependency.associate(self, name, dependency))
        self.dependencies << dep
      end
    end

    # Associate development deps
    (manifest.development_dependencies || {} of String => Manifest::Shard::Dependency::Provider).each do |name, dependency|
      if (dep = ShardDependency.associate(self, name, dependency, true))
        self.dependencies << dep
      end
    end
  end

  protected def associate_authors!
    (manifest.authors || [] of Manifest::Shard::Author).each do |manifest_author|
      self.authors << Author.query.find_or_create({name: manifest_author.name, email: manifest_author.email}) { }
    end
  end
end
