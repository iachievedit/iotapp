import Core
import HTTP
import Middleware

let streamController = StreamController()

final class StreamController {

  let streams = try! StreamRecord()

  func create(request:Request) -> Response {
    return Response(status:.BadRequest)
  }

  func show(request:Request) -> Response {
    return Response(status:.BadRequest)
  }

}
