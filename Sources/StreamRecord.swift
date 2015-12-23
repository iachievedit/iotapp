import PostgreSQL
import CLibpq
import Foundation

final class StreamRecord {

  let db = Connection("postgresql://iotuser:iotuser@localhost/iot_staging")

  init() throws {
    try db.open()
    try db.execute("CREATE TABLE IF NOT EXISTS streams (id SERIAL PRIMARY KEY, name VARCHAR(256), device_id INTEGER NOT NULL)")
  }

  deinit {
    db.close()
  }

  func insert(name:String, deviceId:String) -> Stream {

    let stmt = "INSERT into streams (name, device_id) VALUES('\(name)', '\(deviceId)') RETURNING id"
    logmsg("insert stream:  \(stmt)")

    let result = try! db.execute(stmt)
    let id     = result[0]["id"]!.string!
    logmsg("stream inserted with id \(id)")
    return Stream(id:id, name:name)
           
  }

  func findByName(name:String, deviceId:String) -> Stream? {
    let stmt = "SELECT * from streams where name = '\(name)' and device_id = '\(deviceId)'"
    logmsg("\(stmt)")

    let result = try! db.execute(stmt)
    
    if result.count > 0 {
        return Stream(id:result[0]["id"]!.string!,
                      name:result[0]["name"]!.string!)
    }
    return nil
  }

}
