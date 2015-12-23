import Core
import HTTP
import Middleware

let deviceController = DeviceController()

final class DeviceController {

  let devices = try! DeviceRecord()

  func create(request:Request) -> Response {
    guard let json = request.JSONBody else {
      return Response(status:.BadRequest,
                      json:[
                        "message":"No device definition found"
                      ])
    }

    guard let name = json["name"]?.stringValue else {
      return Response(status:.BadRequest,
                      json:[
                        "message":"name property missing"
                      ])
    }

    guard let serial = json["serial"]?.stringValue else {
      return Response(status:.BadRequest,
                      json:[
                        "message":"serial property missing"
                      ])
    }

    // TODO:  Error check this input
    var location = ZERO_POINT
    if let l = json["location"] {
      location["latitude"]  = l["latitude"]!.doubleValue!
      location["longitude"] = l["longitude"]!.doubleValue! 
    }
    
    guard let _ = json["streams"]?.arrayValue else {
      return Response(status:.BadRequest,
                      json:[
                        "message":"streams property missing"
                      ])
    }

    if let device = devices.insert(name, serial:serial, location:location) {
      return Response(status:.OK, json:device.toJSON())
    } else {
      return Response(status:.BadRequest, json:[
                        "message":"error creating device"
                      ])
    }
    
  }
  

  func show(request:Request) -> Response {

    guard let serial = request.parameters["serial"] else {
      return Response(status:.BadRequest)
    }

    if let device = devices.findBySerial(serial) {
      return Response(status: .OK, json:device.toJSON())
    } else {
      return Response(status:.NotFound)    
    }

  }

}
