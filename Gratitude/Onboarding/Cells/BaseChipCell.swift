//
//  BaseChipCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit

class BaseChipCell: UICollectionViewCell {
    var row: ChipRow!
    var indexPath: IndexPath!
    weak var owner: ChipDelegate!
    
    func configureCellFor(row: ChipRow, owner: ChipDelegate, indexPath: IndexPath) {
        self.row = row
        self.indexPath = indexPath
        self.owner = owner
    }
}
