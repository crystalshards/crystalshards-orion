- author = locals[:author]
.col-12.col-lg-6.d-flex.align-items-stretch.my-3
  a.card.text-decoration-none.text-body.w-100 href="/authors/#{author.email || author.name}"
    .card-body.d-flex.align-items-center
      img.rounded height=100 src=author.avatar_url
      h4.flex-fill.text-center = author.name
    .d-flex.card-footer.text-muted.font-weight-lighter.justify-content-center.align-items-center
      i.fa.fa-code
      span.ml-1 = pluralize(author.attributes["shard_count"].as(Int64), "Shard")
      i.fas.fa-link.ml-2
      span.ml-1 = pluralize(author.attributes["use_count"].as(Int64), "Dependent")
