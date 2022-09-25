//
//  RealmManager.swift
//  Gratitude
//
//  Created by Yuvaraj on 21/09/22.
//

import Foundation
import RealmSwift

class RealmManager {
    private static var sharedInstance: RealmManager?
    class var shared: RealmManager {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = RealmManager()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    class func deinitializeSharedInstance() {
        sharedInstance = nil
    }
    
    private var realm: Realm = try! Realm()
    
    func getVisionData() -> Vision {
        return realm.objects(Vision.self).first ?? Vision()
    }
    
    @discardableResult
    func write<Result>(withoutNotifying tokens: [NotificationToken] = [], _ block: (() throws -> Result)) throws -> Result {
        realm.beginWrite()
        var ret: Result!
        do {
            ret = try block()
        } catch let error {
            if realm.isInWriteTransaction { realm.cancelWrite() }
            throw error
        }
        if realm.isInWriteTransaction { try realm.commitWrite(withoutNotifying: tokens) }
        return ret
    }
    
    func add(_ object: Object) {
        realm.add(object, update: .modified)
    }
}
