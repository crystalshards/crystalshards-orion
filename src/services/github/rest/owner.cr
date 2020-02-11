class Github::REST::Owner
  JSON.mapping(
    login: String,
    avatar_url: String,
    html_url: String
  )
end
