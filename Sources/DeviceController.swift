import Core
import HTTP
import Middleware

let deviceController = DeviceController()

final class DeviceController {

  let devices = try! DeviceRecord()
  let streams = try! StreamRecord()

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

    var streamName:String
    guard let streams = json["streams"]?.arrayValue else {
      return Response(status:.BadRequest,
                      json:[
                        "message":"streams property missing"
                      ])
    }
    
    
    var location = ZERO_POINT
    if let _location = json["location"] {
      location["latitude"] = _location["latitude"]!.doubleValue!
      location["longitude"] = _location["longitude"]!.doubleValue! 
    }

    if let device = devices.insert(name, serial:serial, location:location) {
      for s in streams {
        streamName = s["name"]!.stringValue!
        if let stream = self.streams.insert(streamName, deviceId:device.id) {
         device.addStream(stream)
       }
      }
      
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
