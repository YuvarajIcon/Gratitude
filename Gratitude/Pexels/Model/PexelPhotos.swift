//
//  PexelPhotos.swift
//  Gratitude
//
//  Created by Yuvaraj on 24/09/22.
//

import Foundation

class PexelPhotos {
    var sections: [PexelPhotoSection]
    init(sections: [PexelPhotoSection]) {
        self.sections = sections
    }
    
    static func instance(with urls: [String], vision: Vision, and indexPath: IndexPath) -> PexelPhotos {
        var sections: [PexelPhotoSection] = []
        var rows: [PexelPhotoRow] = []
        for url in urls {
            let isSelected = vision.sections[indexPath.section].photos.first(where: { $0.urlString == url }) != nil
            rows.append(
                PexelPhotoRow(reuseIdentifier: "pexelCellID", urlString: url, isSelected: isSelected)
            )
        }
        sections.append(PexelPhotoSection(rows: rows))
        return PexelPhotos(sections: sections)
    }
}

class PexelPhotoSection {
    var rows: [PexelPhotoRow]
    init(rows: [PexelPhotoRow]) {
        self.rows = rows
    }
}

class PexelPhotoRow: BaseRow {
    var urlString: String
    var isSelected: Bool
    init(reuseIdentifier: String, urlString: String, isSelected: Bool) {
        self.urlString = urlString
        self.isSelected = isSelected
        super.init(reuseIdentifier: reuseIdentifier)
    }
}
