import PostgreSQL
import CLibpq
import Foundation

final class DeviceRecord {

  let db = Connection("postgresql://iotuser:iotuser@localhost/iot_staging")

  init() throws {
    try db.open()
    try db.execute("CREATE TABLE IF NOT EXISTS devices (id SERIAL PRIMARY KEY, name VARCHAR(256), serial VARCHAR(256) UNIQUE, location POINT)")
  }

  deinit {
    db.close()
  }

  func insert(name:String, serial:String, location:Point) -> Device {

    let stmt = "INSERT into devices (name,serial,location) VALUES('\(name)','\(serial)',POINT(\(location["latitude"]!),\(location["longitude"]!))) RETURNING id"
    logmsg("insert device:  \(stmt)")
    
    let result = try! db.execute(stmt)
    let id = result[0]["id"]!.string!
    logmsg("device inserted with id \(id)")
    return Device(id:id, name:name, serial:serial, location:location)
  }

  // Retrieval methods
  subscript(id:String) -> Device? {
    get {
      logmsg("get device[\(id)]")
      let result = try! db.execute("SELECT * from devices where id = '\(id)'")
      if result.count > 0 {
        return Device(id:result[0]["id"]!.string!,
                      name:result[0]["name"]!.string!,
                      serial:result[0]["serial"]!.string!,
                      location:ZERO_POINT)
      }
      return nil
    }
  }

  func findBySerial(serial:String) -> Device? {

    let stmt   = "SELECT * from devices where serial = '\(serial)'"
    
    logmsg(stmt)
    
    let result = try! db.execute(stmt)
    if result.count > 0 {
        return Device(id:result[0]["id"]!.string!,
                      name:result[0]["name"]!.string!,
                      serial:result[0]["serial"]!.string!,
                      location:ZERO_POINT)
    }
    return nil
  }

}
