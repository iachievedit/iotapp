import Core
import HTTP
import Middleware

let datapointController = DatapointController()

final class DatapointController {

  let devices    = try! DeviceRecord()
  let streams    = try! StreamRecord()
  let datapoints = try! DatapointRecord()

  //
  //
  //
  func create(request:Request) -> Response {

    logmsg("ENTRY")

    let deviceSerial = request.parameters["serial"]!
    let streamName   = request.parameters["name"]!

    guard let json = request.JSONBody, value = json["value"]?.stringValue else {
      return Response(status:.BadRequest)
    }

    guard let device = devices.findBySerial(deviceSerial) else {
      return Response(status:.NotFound)
    }

    guard let stream = streams.findByName(streamName, deviceId:device.id) else {
      return Response(status:.NotFound)
    }

    // We now have our stream and data to put into it
    if let datapoint = datapoints.insert(value, streamId:stream.id) {
      return Response(status:.OK, json:datapoint.toJSON())
    }
    
    return Response(status:.BadRequest) // Or server error perhaps

  }
  

  /*
  func show(request:Request) -> Response {

    guard let id = request.parameters["id"], device = devices[id] else {
      return Response(status:.NotFound)
    }
    
    return Response(status:.BadRequest)

  }
  */

  func index(request:Request) -> Response {
    logmsg("ENTRY")

    let deviceSerial = request.parameters["serial"]!
    let streamName   = request.parameters["name"]!

    guard let device = devices.findBySerial(deviceSerial) else {
      return Response(status:.NotFound)
    }

    guard let stream = streams.findByName(streamName, deviceId:device.id) else {
      return Response(status:.NotFound)
    }

    let values = datapoints.findByStream(stream.id, count:10)

    return Response(status:.OK, json:JSON.from(values))
  
  }

}
