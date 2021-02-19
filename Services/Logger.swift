//
//  Logger.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 29.01.2021.
//

import Foundation
import RealmSwift

final class Logger {
    init() {
        self.realm = try? Realm()
    }
    private let realm: Realm?
    func log(_ content: String) {
        realm?.add(Log(content))
    }
    private func getLogObjects(_ since: Date? = nil) -> [Log] {
        guard let logs = self.realm?.objects(Log.self) else {
            return []
        }
        let result = logs.compactMap { (log) -> Log? in
            if let since = since, since < log.timestamp {
                return nil
            }
            return log
        }
        return Array(result)
    }
    
    func getLogs(since: Date? = nil)-> [(String, Date)] {
        let result = getLogObjects(since)
        return result.map{($0.content, $0.timestamp)}
    }
    
    func clear() {
        let objects = getLogObjects()
        for object in objects {
            realm?.delete(object)
        }
    }
}

class Log: Object {
    @objc dynamic var content = ""
    @objc dynamic var timestamp = Date()
    init(_  content: String) {
        self.content = content
        self.timestamp = Date()
    }
}
