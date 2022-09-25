//
//  SearchBarView.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit

protocol TextFieldDelegate: UITextFieldDelegate {
    func textFieldDidChange(_ textField: UITextField)
}

class SearchBarView: UIView, NibLoadable {
    static var nibName: String = "SearchBar"
    
    @IBOutlet private weak var textField: UITextField!
    
    weak var delegate: TextFieldDelegate? {
        didSet {
            self.textField.delegate = self.delegate
        }
    }
    
    var text: String? {
        didSet {
            self.textField.text = self.text
        }
    }
    
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
        self.textField.addTarget(self, action: #selector(textfieldDidChangeText(_ :)), for: .editingChanged)
    }
    
    @objc
    func textfieldDidChangeText(_ textField: UITextField) {
        delegate?.textFieldDidChange(textField)
    }
}
