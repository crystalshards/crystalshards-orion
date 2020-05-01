class Job::Github::ProjectBatchPageQueuedJob < Mosquito::QueuedJob
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

  def serialize_job__github__project_batch_page_queued_job__payload(p : Payload)
    p.to_json
  end

  def deserialize_job__github__project_batch_page_queued_job__payload(s : String)
    Payload.from_json s
  end

  def perform
    ::Service::Github.fetch(node_ids: payload.node_ids).each do |repo|
      ProjectUpdateQueuedJob.with_payload(repo).enqueue
    end
  end
end
