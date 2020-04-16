module JobSerializers
  private def serialize_uuid(uuid : UUID)
    uuid.to_s
  end

  private def deserialize_uuid(str : String)
    UUID.new str
  end

  private def serialize_time(time : Time)
    time.to_json
  end

  private def deserialize_time(str : String)
    Time.from_json str
  end
end
