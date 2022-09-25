//
//  PexelPhotoCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 23/09/22.
//

import Foundation
import UIKit

class BasePexelPhotoCell: UICollectionViewCell {
    var row: BaseRow!
    var indexPath: IndexPath!
    weak var owner: PexelsImagePickerController!
    
    func configureCellFor(row: BaseRow, owner: PexelsImagePickerController, indexPath: IndexPath) {
        self.row = row
        self.indexPath = indexPath
        self.owner = owner
    }
}
