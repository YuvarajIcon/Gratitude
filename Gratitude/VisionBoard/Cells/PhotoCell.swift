//
//  PhotoCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 20/09/22.
//

import Foundation
import UIKit
import LoadableImageView

class PhotoCell: BasePhotoCell {
    @IBOutlet weak var loadableImageView: LoadableImageView!
    
    @IBOutlet weak var plusView: UIImageView!
    override func configureCellFor(row: BaseRow, owner: BasePhotoSectionCell, indexPath: IndexPath) {
        super.configureCellFor(row: row, owner: owner, indexPath: indexPath)
        self.configure()
    }
    
    func configure() {
        guard let row = self.row as? BoardRow else {
            return
        }
        guard let urlString = row.photos.rows[self.indexPath.row].urlString else {
            self.loadableImageView.image = nil
            self.loadableImageView.backgroundColor = row.photos.rows[self.indexPath.row].randomColor
            self.plusView.isHidden = false
            return
        }
        self.loadableImageView.load(from: urlString, onFailure: {
            self.loadableImageView.backgroundColor = row.photos.rows[self.indexPath.row].randomColor
            self.plusView.isHidden = false
        }, onSuccess: {
            self.loadableImageView.backgroundColor = nil
            self.plusView.isHidden = true
        })
    }
}
