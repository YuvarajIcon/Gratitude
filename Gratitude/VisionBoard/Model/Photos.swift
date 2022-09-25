//
//  Photos.swift
//  Gratitude
//
//  Created by Yuvaraj on 23/09/22.
//

import Foundation
import UIKit

class Photos {
    var rows: [PhotoRow]
    init(rows: [PhotoRow]) {
        self.rows = rows
    }
    
    static func instance(with urls: [String]) -> Photos {
        var rows: [PhotoRow] = []
        if urls.isEmpty {
            for index in 0...3 {
                rows.append(contentsOf: [
                    PhotoRow(reuseIdentifier: "photoCellID", urlString: nil, color: PaletteColor.color(for: index))
                ])
            }
        } else {
            for index in 0...urls.count - 1 {
                rows.append(contentsOf: [
                    PhotoRow(reuseIdentifier: "photoCellID", urlString: urls[index], color: PaletteColor.color(for: index))
                ])
            }
        }
        return Photos(rows: rows)
    }
}

class PhotoRow: BaseRow {
    var urlString: String?
    var randomColor: UIColor
    init(reuseIdentifier: String, urlString: String?, color: UIColor) {
        self.urlString = urlString
        self.randomColor = color
        super.init(reuseIdentifier: reuseIdentifier)
    }
}
