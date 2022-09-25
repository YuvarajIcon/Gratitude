//
//  BackButton.swift
//  Gratitude
//
//  Created by Yuvaraj on 24/09/22.
//

import Foundation
import UIKit

class BackButton: UIView, NibLoadable {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    func setTitle(_ title: String?) {
        label.text = title
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
}
