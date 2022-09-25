//
//  BaseEditPhotoCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 23/09/22.
//

import Foundation
import UIKit

class BaseEditPhotoCell: UITableViewCell {
    var row: BaseRow!
    var indexPath: IndexPath!
    weak var owner: VisionBoardEditingController!
    
    func configureCellFor(row: BaseRow, owner: VisionBoardEditingController, indexPath: IndexPath) {
        self.row = row
        self.indexPath = indexPath
        self.owner = owner
    }
}
