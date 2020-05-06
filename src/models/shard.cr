require "common_marker"

class Shard
  include Clear::Model
  BLACKLIST = Hash(String, Manifest::Shard::Dependency::Provider).from_yaml(File.read("blacklist.yml"))

  # Columns
  primary_key
  column manifest : Manifest::Shard
  column index : Bool, presence: false
  column name : String
  column version : String
  column git_tag : String?
  column license : String?
  column readme : String?
  column pushed_at : Time?
  column description : String?
  column crystal : String?
  column tags : Array(String), presence: false

  timestamps

  full_text_searchable

  # Associations
  belongs_to project : Project
  has_many dependencies : ShardDependency, foreign_key: "parent_id"
  has_many authors : Author, through: "shard_authors"

  # Copy spec data to shard
  before :validate do |model|
    m = model.as(self)
    m.update_from_manifest!
    m.git_tag = nil if m.git_tag.to_s.strip.empty?
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
    where { (git_tag == raw("concat('v', version)")) }
      .order_by("shards.pushed_at", "DESC", "NULLS LAST")
  end

  # Ranked within project (in order to get the latest release)
  scope :latest_in_project do
    # Set the has_tag field
    has_tags_cte =
      dup.select({
        id:      "shards.id",
        has_tag: "CASE git_tag WHEN null THEN 0 WHEN '' THEN 0 ELSE 1 END",
      })

    # Rank the shards
    ranked_cte =
      dup.select({
        id:   "shards.id",
        rank: "row_number() OVER (PARTITION BY shards.project_id ORDER BY shards_with_has_tag.has_tag ASC, shards.pushed_at DESC NULLS LAST, shards.created_at DESC)",
      })
        .join("shards_with_has_tag") { shards_with_has_tag.id == shards.id }

    # Select the first in rank
    with_cte({
      shards_with_has_tag: has_tags_cte.to_sql,
      ranked:              ranked_cte.to_sql,
    })
      .where { ranked.rank == 1 }
      .join("ranked") { ranked.id == shards.id }
  end

  # Order by recently updated
  scope :recently_released do
    where_valid
      .latest_in_project
      .join(:projects) { projects.id == shards.project_id }
      .order_by("shards.pushed_at", "DESC", "NULLS LAST")
      .order_by("projects.pushed_at", "DESC", "NULLS LAST")
  end

  scope :originals do
    latest_in_project
      .join("projects") { projects.id == shards.project_id }
      .where { projects.mirrored_id == nil }
  end

  scope :where_valid do
    where { (name != nil) & (name != "") & (version != nil) & (version != "") & (index == true) }
  end

  # Order by the most stars
  scope :popular do
    where_valid
      .latest_in_project
      .join("projects") { projects.id == shards.project_id }
      .order_by("projects.star_count", "DESC", "NULLS LAST")
  end

  # Order by most used by other public shards
  scope :most_used do
    where_valid
      .latest_in_project
      .includes_uses
      .order_by("uses.use_count": "DESC")
  end

  scope :includes_uses do
    cte =
      Clear::SQL.select("COUNT(DISTINCT shards.project_id) AS use_count", "dependencies.id")
        .from("shards")
        .full_outer_join("shard_dependencies") { shard_dependencies.parent_id == shards.id }
        .full_outer_join("projects AS dependencies") { shard_dependencies.dependency_id == dependencies.id }
        .group_by("dependencies.id")
    with_cte({uses: cte})
      .select("shards.*", "uses.use_count")
      .join("uses") { shards.project_id == uses.id }
  end

  scope :by_provider do |name|
    join("projects") { projects.id == shards.project_id }
      .where { projects.provider == name }
  end

  scope by_author do |author|
    case author
    when Author
      latest_in_project
        .join("shard_authors") { shard_authors.shard_id == shards.id }
        .where { shard_authors.author_id == author.id }
    else
      raise "not an author"
    end
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

  def last_pushed_at_string : String
    return "Unknown" unless (pushed_at = self.pushed_at)
    span = Time.utc - pushed_at
    if span.total_days >= 1
      "#{span.total_days.to_i}d ago"
    elsif span.total_hours >= 1
      "#{span.total_hours.to_i}h ago"
    elsif span.total_minutes >= 1
      "#{span.total_minutes.to_i}m ago"
    else
      "#{span.total_seconds.to_i}s ago"
    end
  end

  def readme_html
    if (readme = self.readme)
      md = CommonMarker.new(
        readme,
        options: ["unsafe"],
        extensions: ["table", "strikethrough", "autolink", "tagfilter", "tasklist"]
      )
      project.provider.image_replace(Emoji.emojize(md.to_html), project.uri, git_tag)
    end
  end

  def documentation_url
    documentation = manifest.documentation
    unless !documentation || documentation.empty?
      URI.parse(documentation)
    end
  rescue
    nil
  end

  def license_url
    if (base_url = project.provider.base_url)
      "#{project.url}/blob/#{git_tag || "HEAD"}/LICENSE"
    end
  end

  def all_tags
    (self.tags + project.tags).unique
  end

  protected def update_from_manifest!
    self.name = manifest.name
    self.version = manifest.version
    self.license = manifest.license
    self.description = manifest.description || project.description
    self.crystal = manifest.crystal
    self.tags = (manifest.tags || [] of String) + project.tags
    self.index = manifest.index && !blacklisted?
  end

  protected def blacklisted?
    BLACKLIST.any? do |name, spec|
      spec.provider == project.provider.to_s && spec.uri == project.uri
    end
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
    found_authors = (manifest.authors || [] of Manifest::Shard::Author).map do |manifest_author|
      author = Author.query.find_or_build(manifest_author.email ? {email: manifest_author.email} : {name: manifest_author.name}) { }
      unless manifest_author.name_is_username? && author.persisted?
        author.name = manifest_author.name
        author.save
      end
      author
    end

    existing_authors = authors.to_a

    # Remove missing authors
    (existing_authors - found_authors).each do |author|
      authors.unlink author
    end

    # Add new authors
    (found_authors - existing_authors).each do |author|
      authors.add author
    end
  end
end
