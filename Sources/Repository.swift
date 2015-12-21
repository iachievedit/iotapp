import PostgreSQL
import CLibpq
import Foundation

final class Repository {

  let db = Connection("postgresql://postgres:postgres@localhost/iot")

  init() throws {
    try db.open()
    try db.execute("CREATE TABLE IF NOT EXISTS devices (id SERIAL PRIMARY KEY, name VARCHAR(256), serial VARCHAR(256) UNIQUE, location POINT")
    try db.execute("CREATE TABLE IF NOT EXISTS streams (id SERIAL PRIMARY KEY, name VARCHAR(256), device_id INTEGER NOT NULL")
  }

  deinit {
    db.close()
  }

}
