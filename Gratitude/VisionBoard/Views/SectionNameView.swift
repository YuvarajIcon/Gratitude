//
//  SectionNameView.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit

class SectionNameView: UIView, NibLoadable {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    static var nibName: String = "SectionName"
    
    weak var editingDelegate: HeaderEditingDelegate?
    var indexPath: IndexPath!
    var text: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        configure()
    }
    
    func configure() {
        self.textField.delegate = self
        self.textField.isUserInteractionEnabled = false
        self.textField.text = self.text
        self.addButtonTargets()
    }
    
    func addButtonTargets() {
        self.editButton.addTarget(self, action: #selector(editTapped(_ :)), for: .touchUpInside)
    }
    
    @objc
    func editTapped(_ sender: UIButton) {
        self.textField.isUserInteractionEnabled = true
        self.textField.becomeFirstResponder()
    }
}

extension SectionNameView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textField.isUserInteractionEnabled = false
        guard let text = self.textField.text else {
            return
        }
        self.editingDelegate?.didEndEditing(with: text, at: self.indexPath)
    }
}
