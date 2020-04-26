.col-12.col-md-6.d-flex.my-3
  a.card.h-100.w-100.text-decoration-none.text-body href="/shards/#{shard.project.provider.to_s}/#{shard.project.display_name}"
    .card-header
      span.font-weight-bold=shard.name
    .card-body=shard.description || shard.project.description || "No Description"
    .card-footer.text-muted.font-weight-lighter
      i class="fab fa-#{shard.project.provider.to_s}"
      span=shard.project.display_name
      - if shard.project.star_count
        span.font-weight-bold.ml-1.mr-1 •
        i.far.fa-star
        span=shard.project.star_count
      - if shard.project.pushed_at
        span.font-weight-bold.ml-1.mr-1 •
        i.fas.fa-history
        span=shard.project.last_pushed_at_string
