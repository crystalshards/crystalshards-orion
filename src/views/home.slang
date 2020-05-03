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
    - most_used.each(fetch_columns: true) do |shard|
      = render partial: "shard_card.slang"

.mt-3
  h4
    i.fa.fa-history.text-primary
    | Recently Released
  .row
    - recently_released.each do |shard|
      = render partial: "shard_card.slang"
