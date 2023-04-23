class Job::Github::ProjectBatchPageQueuedJob < Mosquito::QueuedJob
  BAD_ID_PATTERN = /Could not resolve to a node with the global id of '((?:[A-Za-z0-9+]{4})*(?:[A-Za-z0-9+]{2}==|[A-Za-z0-9+]{3}=)?)'\./

  class Payload
    include JSON::Serializable
    getter node_ids

    def initialize(
      *,
      @node_ids : Array(String)
    ); end
  end

  params(
    payload : Payload
  )

  def self.with_payload(*args, **params)
    new payload: Payload.new(*args, **params)
  end

  def serialize_job_github_project_batch_page_queued_job_payload(p : Payload)
    p.to_json
  end

  def deserialize_job_github_project_batch_page_queued_job_payload(s : String)
    Payload.from_json s
  end

  def perform
    ::Service::Github.fetch(node_ids: payload.node_ids).each do |repo|
      ProjectUpdateQueuedJob.with_payload(repo).enqueue
    end
  rescue error
    if (bad_ids = error.message.to_s.scan(BAD_ID_PATTERN).map(&.[1])).size > 0
      Project.query.where { projects.api_id.in?(bad_ids) }.map(&.delete)
      self.class.with_payload(node_ids: payload.node_ids - bad_ids).enqueue
    else
      raise error
    end
  end
end
