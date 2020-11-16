.mt-3
  h4
    i.fa.fa-star.text-primary
    | Most Popular
  .row
    - locals[:most_popular].each do |shard|
      == render partial: "shards/shard_card.slang", locals: { shard: shard }

.mt-3
  h4
    i.fa.fa-umbrella.text-primary
    | Most Used
  .row
    - locals[:most_used].each(fetch_columns: true) do |shard|
      == render partial: "shards/shard_card.slang", locals: { shard: shard }

.mt-3
  h4
    i.fa.fa-history.text-primary
    | Recently Released
  .row
    - locals[:recently_released].each do |shard|
      == render partial: "shards/shard_card.slang", locals: { shard: shard }
