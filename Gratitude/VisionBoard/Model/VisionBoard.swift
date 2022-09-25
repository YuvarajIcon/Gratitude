//
//  VisionBoard.swift
//  Gratitude
//
//  Created by Yuvaraj on 20/09/22.
//

import Foundation

class BoardSection {
    var headerText: String?
    var rows: [BoardRow]!
    init(title: String?, rows: [BoardRow]) {
        self.headerText = title
        self.rows = rows
    }
}

class BaseRow {
    var reuseIdentifier: String
    init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
    }
}

class BoardRow: BaseRow {
    var photos: Photos
    init(reuseIdentifier: String, photos: Photos) {
        self.photos = photos
        super.init(reuseIdentifier: reuseIdentifier)
    }
}

class VisionBoard {
    var sections: [BoardSection]!
    init(sections: [BoardSection]) {
        self.sections = sections
    }
    
    static func instance(with vision: Vision) -> VisionBoard {
        var sections: [BoardSection] = []
        for section in vision.sections {
            let urls = Array(section.photos).map({ $0.urlString })
            let photos = Photos.instance(with: urls)
            sections.append(
                BoardSection(title: section.name, rows: [
                    BoardRow(reuseIdentifier: "CollectionCellID", photos: photos)
                ])
            )
        }
        return VisionBoard(sections: sections)
    }
}


