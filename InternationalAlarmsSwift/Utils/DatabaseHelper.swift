import Foundation
import SQLite3
import UserNotifications

class DatabaseHelper {
    
    static let shared = DatabaseHelper()
    
    private let databaseName: String
    private let databasePath: String
    private var db: OpaquePointer?
    private var cache: [String: [[Any]]] = [:]
    
    private init() {
        self.databaseName = "alarm.db"
        self.databasePath = DatabaseHelper.getDBPath(dbName: self.databaseName)
    }
    
    private static func getDBPath(dbName: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = paths[0]
        return (documentsDir as NSString).appendingPathComponent(dbName)
    }
    
    func checkAndCreateDatabase() -> Bool {
        let fileManager = FileManager.default
        print("databasePath: " + databasePath)
        if fileManager.fileExists(atPath: databasePath) {
            return false
        }
        print("DB file does not exist, copying over: ")
        
        let databasePathFromApp = Bundle.main.resourcePath!.appending("/\(databaseName)")
        
        do {
            print("copy worked")
            try fileManager.copyItem(atPath: databasePathFromApp, toPath: databasePath)
        } catch {
            print("COPY FAILED :( \(error.localizedDescription)")
            return false
        }
        return false
    }
    
    func deleteDatabase() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: databasePath) { return }
        do {
            try fileManager.removeItem(atPath: databasePath)
        } catch {
            print("DELETE DID NOT WORK :(")
        }
    }
    
    func getDBPath(dbName: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = paths[0]
        return documentsDir.appending("/\(dbName)")
    }
    
    func openDatabase() -> OpaquePointer? {
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            return db
        }
        return nil
    }
    
    func closeDatabase() {
        sqlite3_close(db)
    }
    
    func executeSelectQueryWithNumCols(numCols: Int, query: String) -> [[Any]]? {
        print("In executeSelectQueryWithNumCols: numCols: " + String(numCols) + " query: " + query)
        var retArray: [[Any]] = []
        var doCache = false
        
        if !query.lowercased().hasSuffix("alarms") {
            doCache = true
        }
        
        if doCache, let cached = cache[query] {
            return cached
        }
        
        if db == nil {
            if sqlite3_open(databasePath, &db) != SQLITE_OK {
                print("Error opening DB")
                return nil
            }
        }
        
        var selectstmt: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &selectstmt, nil) == SQLITE_OK {
            let cols = sqlite3_column_count(selectstmt)
            while sqlite3_step(selectstmt) == SQLITE_ROW {
                var row: [Any] = []
                for i in 0..<cols {
                    if let text = sqlite3_column_text(selectstmt, i) {
                        row.append(String(cString: text))
                    } else {
                        row.append("")
                    }
                }
                retArray.append(row)
            }
        } else {
            print("Error: \(String(cString: sqlite3_errmsg(db)!)) for query: \(query)")
        }
        
        if doCache {
            cache[query] = retArray
        }
        
        sqlite3_finalize(selectstmt)
        return retArray
    }
    
    func getLastId() -> Int {
        return Int(sqlite3_last_insert_rowid(db))
    }
    
    func executeQuery(_ query: String) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error '\(String(cString: sqlite3_errmsg(db)!))' for query: \(query)")
            }
        } else {
            print("sqlite3_prepare_v2 failed")
            print("Error '\(String(cString: sqlite3_errmsg(db)!))' was: \(query)")
        }
        sqlite3_finalize(statement)
    }
}
