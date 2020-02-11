class Github::REST::File
  JSON.mapping({
    repository: Github::REST::Repository,
  })
end
