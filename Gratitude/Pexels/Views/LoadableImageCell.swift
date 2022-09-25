//
//  LoadableImageCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit
import LoadableImageView

class LoadableImageCell: UICollectionViewCell, NibLoadable {
    @IBOutlet weak var loadableImageView: LoadableImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    func configure(with url: String) {
        self.loadableImageView.load(from: url)
    }
}
