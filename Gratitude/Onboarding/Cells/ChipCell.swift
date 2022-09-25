//
//  ChipCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit

class ChipCell: BaseChipCell {
    @IBOutlet weak var button: UIButton!
    
    override func configureCellFor(row: ChipRow, owner: ChipDelegate, indexPath: IndexPath) {
        super.configureCellFor(row: row, owner: owner, indexPath: indexPath)
        self.configure()
    }
    
    func configure() {
        self.button.setTitle(row.text, for: .normal)
    }
    
    @IBAction func chipTapped(_ sender: UIButton) {
        owner.chipTapped(at: self.indexPath)
    }
}
