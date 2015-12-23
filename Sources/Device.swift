typealias Point = [String:Any]

let ZERO_POINT:Point = ["latitude":0.0,
                        "longitude":0.0]

func pointFromString(point:String) -> Point {
  let point2 = String(String(point.characters.dropFirst()).characters.dropLast())
  var pointArr = point2.characters.split{$0 == ","}.map(String.init)
  return [
    "latitude":pointArr[0],
    "longitude":pointArr[1]
  ]
}


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
