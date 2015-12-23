import Core

extension JSON {
  static func from(value:[Datapoint]) -> JSON {
    var json:[JSON] = []
    for datapoint in value {
      json.append(datapoint.toJSON())
    }
    return JSON.from(json)
  }
}

extension Datapoint {
  func toJSON() -> JSON {
    return [
      "id":JSON.from(id),
      "value":JSON.from(value),
      "inserted_at":JSON.from(inserted_at)
    ]
  }

  static func toJSON(device:Device) -> JSON {
    return device.toJSON()
  }
}
