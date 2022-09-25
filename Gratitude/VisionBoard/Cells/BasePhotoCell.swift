//
//  BasePhotoCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 20/09/22.
//

import Foundation
import UIKit

class BasePhotoCell: UICollectionViewCell {
    var row: BaseRow!
    var indexPath: IndexPath!
    weak var owner: BasePhotoSectionCell!
    
    func configureCellFor(row: BaseRow, owner: BasePhotoSectionCell, indexPath: IndexPath) {
        self.row = row
        self.indexPath = indexPath
        self.owner = owner
    }
}
