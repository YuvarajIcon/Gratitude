//
//  PexelPhotoCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 23/09/22.
//

import Foundation
import LoadableImageView

class PexelPhotoCell: BasePexelPhotoCell {
    @IBOutlet weak var loadableImageView: LoadableImageView!
    @IBOutlet weak var selectionView: UIView!
    
    override func configureCellFor(row: BaseRow, owner: PexelsImagePickerController, indexPath: IndexPath) {
        super.configureCellFor(row: row, owner: owner, indexPath: indexPath)
        self.configure()
    }
    
    @IBAction func cellTapped(_ sender: UIButton) {
        guard let row = row as? PexelPhotoRow else {
            return
        }
        row.isSelected.toggle()
        owner.tappedPhoto(at: self.indexPath, isSelected: row.isSelected)
    }
    
    func configure() {
        guard let row = row as? PexelPhotoRow else {
            return
        }
        self.loadableImageView.load(from: row.urlString, onFailure: {
            self.loadableImageView.backgroundColor = .red
        })
        if row.isSelected {
            self.selectionView.isHidden = false
        } else {
            self.selectionView.isHidden = true
        }
    }
}
