//
//  Chip.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation

protocol ChipDelegate: AnyObject {
    func chipTapped(at: IndexPath)
}

class Chips {
    var sections: [ChipSection]
    init(sections: [ChipSection]) {
        self.sections = sections
    }
    
    static func instance(with texts: [String]) -> Chips {
        var sections: [ChipSection] = []
        var rows: [ChipRow] = []
        for text in texts {
            rows.append(ChipRow(reuseIdentifier: "chipCellID", text: text))
        }
        sections.append(ChipSection(rows: rows))
        return Chips(sections: sections)
    }
}

class ChipSection {
    var rows: [ChipRow]
    init(rows: [ChipRow]) {
        self.rows = rows
    }
}

class ChipRow {
    var reuseIdentifier: String
    var text: String
    init(reuseIdentifier: String, text: String) {
        self.reuseIdentifier = reuseIdentifier
        self.text = text
    }
}
