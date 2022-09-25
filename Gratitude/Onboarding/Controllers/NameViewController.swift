//
//  NameViewController.swift
//  Gratitude
//
//  Created by Yuvaraj on 13/09/22.
//

import Foundation
import UIKit

class NameViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewCenterYConstraint: NSLayoutConstraint!
    var vision: Vision = RealmManager.shared.getVisionData()
    
    override class var storyboardName: String {
        return "Onboarding"
    }
    
    override var leftBarButtonConfig: ButtonConfig {
        let backButton = BackButton()
        backButton.setTitle(nil)
        backButton.setImage(UIImage(named: "backArrowGray"))
        return ButtonConfig(type: .custom, value: backButton)
    }
    
    override var respondsForKeyboardNotification: Bool {
        return true
    }
    
    override var dismissesKeyboardOnTap: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonTargets()
        self.configureTextField()
        self.validateTextField()
    }
    
    override func configureLeftBarButton() {
        super.configureLeftBarButton()
        self.navigationItem.leftBarButtonItem?.tintColor = .gray
    }
    
    override func adjustLayoutFor(keyboardState: KeyboardState, userInfo: [AnyHashable : Any]) {
        guard let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        switch keyboardState {
        case .closed:
            self.nextButtonBottomConstraint.constant = 24
            self.stackViewCenterYConstraint.constant = -50
            break
        case .opened:
            self.nextButtonBottomConstraint.constant = keyboardHeight + 5
            let textFieldBottom = self.textField.bounds.minY
            let stackViewMid = self.textField.bounds.midY
            if textFieldBottom < keyboardHeight {
                self.stackViewCenterYConstraint.constant += -(35 + stackViewMid - textFieldBottom)
            }
            break
        }
        super.adjustLayoutFor(keyboardState: keyboardState, userInfo: userInfo)
    }
    
    func addButtonTargets() {
        self.nextStepButton.addTarget(self, action: #selector(onNextTap(_:)), for: .touchUpInside)
    }
    
    func configureTextField() {
        self.textField.addTarget(self, action: #selector(textfieldDidChangeText(_ :)), for: .editingChanged)
        self.textField.delegate = self
        self.textField.text = self.vision.userName
    }
    
    func validateTextField() {
        guard let text = textField.text else {
            self.nextStepButton.isEnabled = false
            return
        }
        self.nextStepButton.isEnabled = (text.isEmpty == false)
    }
    
    @objc
    func onNextTap(_: UIButton) {
        self.textField.resignFirstResponder()
        self.navigationController?.pushViewController(VisionNameViewController.instance(), animated: true)
    }
}

extension NameViewController: UITextFieldDelegate {
    @objc
    func textfieldDidChangeText(_ textField: UITextField) {
        self.validateTextField()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        try! RealmManager.shared.write({
            self.vision.userName = textField.text!
            RealmManager.shared.add(self.vision)
        })
    }
}
