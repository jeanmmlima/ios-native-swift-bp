import Foundation
import SQLite3

final class PlacesDatabase {
    static let shared = PlacesDatabase()

    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createTableIfNeeded()
    }

    deinit {
        sqlite3_close(db)
    }

    func fetchAll() -> [Place] {
        var result: [Place] = []
        let query = "SELECT id, title, image_path, latitude, longitude FROM places ORDER BY rowid DESC;"
        var stmt: OpaquePointer?

        guard sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK else {
            return result
        }
        defer { sqlite3_finalize(stmt) }

        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = String(cString: sqlite3_column_text(stmt, 0))
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let imagePath = String(cString: sqlite3_column_text(stmt, 2))
            let latitude = sqlite3_column_type(stmt, 3) == SQLITE_NULL ? nil : sqlite3_column_double(stmt, 3)
            let longitude = sqlite3_column_type(stmt, 4) == SQLITE_NULL ? nil : sqlite3_column_double(stmt, 4)

            result.append(
                Place(
                    id: id,
                    title: title,
                    imagePath: imagePath,
                    latitude: latitude,
                    longitude: longitude
                )
            )
        }

        return result
    }

    func insert(_ place: Place) {
        let sql = "INSERT OR REPLACE INTO places (id, title, image_path, latitude, longitude) VALUES (?, ?, ?, ?, ?);"
        var stmt: OpaquePointer?

        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            return
        }
        defer { sqlite3_finalize(stmt) }

        sqlite3_bind_text(stmt, 1, (place.id as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 2, (place.title as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 3, (place.imagePath as NSString).utf8String, -1, nil)

        if let lat = place.latitude { sqlite3_bind_double(stmt, 4, lat) } else { sqlite3_bind_null(stmt, 4) }
        if let lng = place.longitude { sqlite3_bind_double(stmt, 5, lng) } else { sqlite3_bind_null(stmt, 5) }

        sqlite3_step(stmt)
    }

    private func openDatabase() {
        let url = databaseURL()
        if sqlite3_open(url.path, &db) != SQLITE_OK {
            db = nil
        }
    }

    private func createTableIfNeeded() {
        let ddl = """
        CREATE TABLE IF NOT EXISTS places (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            image_path TEXT NOT NULL,
            latitude REAL,
            longitude REAL
        );
        """

        sqlite3_exec(db, ddl, nil, nil, nil)
    }

    private func databaseURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("places.sqlite")
    }
}
