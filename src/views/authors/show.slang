- shard_count = author.shards.distinct("project_id").count
.d-flex
  img.rounded.mr-4 height=100 src=(author.avatar_url || author.default_avatar_url)
  div.flex-fill
    h2 = author.name
    - if author.email
      a href="mailto:#{author.email}"
        i.fa.fa-envelope
        | Email Me
  div
    h5 Total Shards
    h3 = shard_count

- if shard_count > 0
  .mt-4.pt-3.border-top
    h2 Shards
  .row
    - Shard.by_author(author).each do |shard|
      = render partial: "shard_card.slang"




