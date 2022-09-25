//
//  Loader.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit

class Loader: UIView, NibLoadable {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
}
