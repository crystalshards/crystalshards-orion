.card.mb-4
  .card-header
    span.font-weight-bold=shard.name
  .card-body=shard.description
  .card-footer.text-muted.font-weight-lighter
    i class="fab fa-#{shard.project.provider.to_s}"
    span=shard.project.uri
    - if shard.project.star_count
      span.font-weight-bold.ml-1.mr-1 •
      i.far.fa-star
      span=shard.project.star_count
    - if shard.project.pushed_at
      span.font-weight-bold.ml-1.mr-1 •
      i.fas.fa-history
      span=shard.project.last_pushed_at_string
