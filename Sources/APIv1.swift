import HTTP
import Router
import Middleware

let APIv1 = Router("/v1") {
  route in
  route.get("/version") {
    _ in
    return Response(status: .OK,
                    json:["version":"1.0.0"])
  }

  // Create a new device
  route.post("/devices", parseJSON >>> deviceController.create)

  // Get a device
  route.get("/devices/:serial", deviceController.show)

  // Post a datapoint to a stream
  route.post("/devices/:serial/streams/:name/value",
             parseJSON >>> datapointController.create)

  // Get values posted to a stream
  route.get("/devices/:serial/streams/:name", datapointController.index)

}
