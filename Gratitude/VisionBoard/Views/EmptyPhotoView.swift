//
//  EmptyPhotoView.swift
//  Gratitude
//
//  Created by Yuvaraj on 23/09/22.
//

import Foundation
import UIKit

class EmptyPhotoView: UIView, NibLoadable {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var visionLabel: UILabel!
    static var nibName: String = "EmptyPhoto"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
}
