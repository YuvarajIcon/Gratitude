//
//  Vision.swift
//  Gratitude
//
//  Created by Yuvaraj on 21/09/22.
//

import Foundation
import RealmSwift

class Vision: Object {
    @objc dynamic var ID: Int = 0
    @objc dynamic var userName: String = ""
    @objc dynamic var boardName: String = ""
    var sections: List<VisionSection> = List<VisionSection>()
    
    override class func primaryKey() -> String? {
        return "ID"
    }
}

class VisionSection: EmbeddedObject {
    @objc dynamic var name: String = ""
    var photos: List<VisionPhoto> = List<VisionPhoto>()
}

class VisionPhoto: EmbeddedObject {
    @objc dynamic var urlString: String = ""
    @objc dynamic var caption: String? = nil
}




