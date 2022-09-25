//
//  BaseCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 20/09/22.
//

import Foundation
import UIKit

class BasePhotoSectionCell: UITableViewCell {
    var row: BaseRow!
    var indexPath: IndexPath!
    weak var owner: VisionBoardViewController!
    
    func configureCellFor(row: BaseRow, owner: VisionBoardViewController, indexPath: IndexPath) {
        self.row = row
        self.indexPath = indexPath
        self.owner = owner
    }
}
