import Core
import HTTP
import Middleware

let deviceController = DeviceController()

final class DeviceController {

  let devices = try! DeviceRepository()
  let streams = try! StreamRepository()

  func create(request:Request) -> Response {
    guard let json = request.JSONBody, name = json["name"]?.stringValue, serial = json["serial"]?.stringValue else {
      return Response(status:.BadRequest)
    }

    // TODO:  Error check this input
    var location = ZERO_POINT
    if let _location = json["location"] {
      location["latitude"] = _location["latitude"]!.doubleValue!
      location["longitude"] = _location["longitude"]!.doubleValue! 
    }
    
    let device = devices.insert(name, serial:serial, location:location)

    // TODO:  Implement creating streams
    var streamName:String
    if let _streams = json["streams"] {
      if let __streams = _streams.arrayValue {
        for s in __streams {
          streamName = s["name"]!.stringValue!
          let stream = streams.insert(streamName, deviceId:device.id)
          device.addStream(stream)
        }
      }
    }
    
    return Response(status:.OK, json:device.toJSON())
  }
  

  func show(request:Request) -> Response {

    guard let id = request.parameters["id"], device = devices[id] else {
      return Response(status:.NotFound)
    }
    
    return Response(status: .OK, json:device.toJSON())

  }

}
