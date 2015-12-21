typealias Point = [String:Any]

let ZERO_POINT:Point = ["latitude":0.0,
                        "longitude":0.0]

class Device {
  var id:String
  var name:String
  var serial:String
  var location:Point
  var streams:[Stream]

  init(id:String, name:String, serial:String, location:Point) {
    self.id       = id
    self.name     = name
    self.serial   = serial
    self.location = location
    self.streams  = []
  }

  func addStream(stream:Stream) {
    streams.append(stream)
  }
}
