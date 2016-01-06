import PostgreSQL
import CLibpq
import Foundation

final class StreamRecord {

  let tableName = "streams"
  let db = Connection("postgresql://iotuser:iotuser@localhost/iot_staging")

  init() throws {
    try db.open()
    try db.execute("CREATE TABLE IF NOT EXISTS \(tableName) (id SERIAL PRIMARY KEY, name VARCHAR(256), device_id INTEGER NOT NULL)")
  }

  deinit {
    db.close()
  }

  func insert(name:String, deviceId:String) -> Stream? {

    let stmt = "INSERT into \(tableName) (name, device_id) VALUES('\(name)', '\(deviceId)') RETURNING id"
    
    logmsg(stmt)

    do {
      try db.open()
      let result = try! db.execute(stmt)
      let id     = result[0]["id"]!.string!
      return Stream(id:id, name:name)
    } catch {
      return nil
    }

           
  }

  func findByName(name:String, deviceId:String) -> Stream? {
    let stmt = "SELECT * from \(tableName) where name = '\(name)' and device_id = '\(deviceId)'"
    
    logmsg(stmt)

    do {
      try db.open()
      let result = try! db.execute(stmt)
    
      if result.count > 0 {
        return Stream(id:result[0]["id"]!.string!,
                      name:result[0]["name"]!.string!)
      } else {
      return nil
      }
    } catch {
      return nil
    }
    
  }

}
