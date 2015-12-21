import Core

extension Device {
  func toJSON() -> JSON {
    return [
      "id":JSON.from(id),
      "name":JSON.from(name),
      "serial":JSON.from(serial),
      "location":JSON.from(location),
      "streams":JSON.from(streams)
    ]
  }

  static func toJSON(device:Device) -> JSON {
    return device.toJSON()
  }
}
