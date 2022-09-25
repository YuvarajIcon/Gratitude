//
//  AttachedPhotos.swift
//  Gratitude
//
//  Created by Yuvaraj on 23/09/22.
//

import Foundation

class AttachedPhotos {
    var sections: [AttachedPhotoSection]
    init(sections: [AttachedPhotoSection]) {
        self.sections = sections
    }
    
    static func instance(with vision: Vision, for indexPath: IndexPath) -> AttachedPhotos {
        var sections: [AttachedPhotoSection] = []
        for photo in vision.sections[indexPath.section].photos {
            sections.append(contentsOf: [
                AttachedPhotoSection(rows: [
                    AttachedPhotoRow(reuseIdentifier: "editCellID", urlString: photo.urlString, caption: photo.caption)
                ])
            ])
        }
        return AttachedPhotos(sections: sections)
    }
}

class AttachedPhotoSection {
    var rows: [AttachedPhotoRow]
    init(rows: [AttachedPhotoRow]) {
        self.rows = rows
    }
}

class AttachedPhotoRow: BaseRow {
    var urlString: String
    var caption: String?
    init(reuseIdentifier: String, urlString: String, caption: String? = nil) {
        self.urlString = urlString
        self.caption = caption
        super.init(reuseIdentifier: reuseIdentifier)
    }
}
