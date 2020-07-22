- start_index = locals[:start_index]
- end_index = locals[:end_index]
- total_count = locals[:total_count]
- shards = locals[:shards]
.row
  .col-12
    | Searching shards containing
    = request.query_params["q"]?
    = "#{start_index} - #{end_index} of #{total_count} in total"
.row
  - shards.each(fetch_columns: true) do |shard|
    == render partial: "shards/shard_card.slang", locals: { shard: shard }
.row
  == render partial: "shared/pagination.slang"
