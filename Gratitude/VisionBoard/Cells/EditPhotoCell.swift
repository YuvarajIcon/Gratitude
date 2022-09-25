//
//  EditPhotoCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 23/09/22.
//

import Foundation
import UIKit
import LoadableImageView

class EditPhotoCell: BaseEditPhotoCell {
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var loadableImageView: LoadableImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func configureCellFor(row: BaseRow, owner: VisionBoardEditingController, indexPath: IndexPath) {
        super.configureCellFor(row: row, owner: owner, indexPath: indexPath)
        self.configure()
    }
    
    func configure() {
        guard let row = row as? AttachedPhotoRow else {
            return
        }
        self.captionField.text = row.caption
        self.captionField.delegate = self
        self.loadableImageView.load(from: row.urlString)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        owner.deletePhoto(at: self.indexPath)
    }
}

extension EditPhotoCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        owner.captionAdded(at: self.indexPath, as: textField.text)
    }
}
