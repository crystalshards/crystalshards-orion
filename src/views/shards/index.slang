- start_index = locals[:start_index]
- end_index = locals[:end_index]
- total_count = locals[:total_count]
- starts_with = locals[:starts_with]
- shards = locals[:shards]
.row
  .col-12
    == render partial: "directory_nav.slang"
.row
  .col-12
    | Displaying shards
    = "#{start_index} - #{end_index} of #{total_count} in total"
    - if starts_with
      | starting with
      span.font-weight-bold #{starts_with.upcase}
.row
  - shards.each do |shard|
    == render partial: "shards/shard_card.slang", locals: { shard: shard }
.row
  == render partial: "shared/pagination.slang"
