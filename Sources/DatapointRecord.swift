import PostgreSQL
import CLibpq
import Foundation

final class DatapointRecord {

  let tableName = "datapoints"
  let db = Connection("postgresql://iotuser:iotuser@localhost/iot_staging")

  init() throws {
    try db.open()
    try db.execute("CREATE TABLE IF NOT EXISTS \(tableName) (id SERIAL PRIMARY KEY, inserted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT (now() AT TIME ZONE 'utc'), value TEXT, stream_id INTEGER NOT NULL)")
  }

  deinit {
    db.close()
  }

  func insert(value:String, streamId:String) -> Datapoint? {

    let stmt = "INSERT into \(tableName) (value, stream_id) VALUES('\(value)', '\(streamId)') RETURNING id, inserted_at"
    logmsg("insert datapoint:  \(stmt)")

    do {
      let result = try db.execute(stmt)
      let id     = result[0]["id"]!.string!
      let inserted_at = result[0]["inserted_at"]!.string!
      logmsg("datapoint inserted with id \(id)")
      return Datapoint(id:id, value:value, inserted_at:inserted_at)
    } catch {
      return nil
    }
           
  }

  func findByStream(streamId:String, count:Int) -> [Datapoint] {
    let stmt = "SELECT * FROM \(tableName) WHERE stream_id = \(streamId) LIMIT \(count)"

    logmsg(stmt)

    var datapoints:[Datapoint] = []
    do {
      let results = try db.execute(stmt)
      for result in results {
        let id          = result["id"]!.string!
        let value       = result["value"]!.string!
        let inserted_at = result["inserted_at"]!.string!
        let datapoint   = Datapoint(id:id, value:value, inserted_at:inserted_at)
        datapoints.append(datapoint)
      }
      return datapoints
    } catch {
      return []
    }
  }
}
