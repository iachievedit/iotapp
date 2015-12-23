import Core
import HTTP
import Middleware

let deviceController = DeviceController()

final class DeviceController {

  let devices = try! DeviceRecord()
  let streams = try! StreamRecord()

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
    guard let streams = json["streams"]?.arrayValue else {
      return Response(status:.BadRequest)
    }

    for s in streams {
      streamName = s["name"]!.stringValue!
      let stream = self.streams.insert(streamName, deviceId:device.id)
      device.addStream(stream)
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
