import Core

extension JSON {
  static func from(value:[Stream]) -> JSON {
    var json:[JSON] = []
    for stream in value {
      json.append(stream.toJSON())
    }
    return JSON.from(json)
  }
}

extension Stream {
  func toJSON() -> JSON {
    return [
      "id":JSON.from(id),
      "name":JSON.from(name),
    ]
  }

  static func toJSON(stream:Stream) -> JSON {
    return stream.toJSON()
  }
}
