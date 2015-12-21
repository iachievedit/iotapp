import Core
import HTTP
import Middleware

let streamController = StreamController()

final class StreamController {

  let streams = try! StreamRepository()

  func create(request:Request) -> Response {
    return Response(status:.BadRequest)
  }

  func show(request:Request) -> Response {
    return Response(status:.BadRequest)
  }

}
