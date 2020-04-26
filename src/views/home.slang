.mt-3
  h4
    i.fa.fa-star.text-primary
    | Most Popular
  .row
    - most_popular.each do |shard|
      = render partial: "shard_card.slang"

.mt-3
  h4
    i.fa.fa-umbrella.text-primary
    | Most Used
  .row
    - most_used.each do |shard|
      = render partial: "shard_card.slang"

.mt-3
  h4
    i.fa.fa-history.text-primary
    | Recently Updated
  .row
    - recently_updated.each do |shard|
      = render partial: "shard_card.slang"
