import PostgreSQL
import CLibpq
import Foundation

final class DeviceRecord {

  let tableName = "devices"
  let db = Connection("postgresql://iotuser:iotuser@localhost/iot_staging")

  init() throws {
    try db.open()
    try db.execute("CREATE TABLE IF NOT EXISTS \(tableName) (id SERIAL PRIMARY KEY, name VARCHAR(256), serial VARCHAR(256) UNIQUE, location POINT)")
  }

  deinit {
    db.close()
  }

  func insert(name:String, serial:String, location:Point) -> Device? {

    let stmt = "INSERT into \(tableName) (name,serial,location) VALUES('\(name)','\(serial)',POINT(\(location["latitude"]!),\(location["longitude"]!))) RETURNING id"
    
    logmsg(stmt)

    do {
      try db.open()
      let result = try db.execute(stmt)
      let id = result[0]["id"]!.string!
      return Device(id:id, name:name, serial:serial, location:location)
    } catch {
      return nil
    }
  }

  func findBySerial(serial:String) -> Device? {

    let stmt   = "SELECT * from devices where serial = '\(serial)'"
    
    logmsg(stmt)
  
    do {
      try db.open()
      let result = try! db.execute(stmt)
      if result.count > 0 {
        let id = result[0]["id"]!.string!
        let name = result[0]["name"]!.string!
        let serial = result[0]["serial"]!.string!
        let location = result[0]["location"]!.string!
        let locationAsPoint = pointFromString(location)
        return Device(id:id, name:name, serial:serial, location:locationAsPoint)
      }
      return nil
    } catch {
      return nil
    }
  }
}

