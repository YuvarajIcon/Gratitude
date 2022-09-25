//
//  SectionNameViewController.swift
//  Gratitude
//
//  Created by Yuvaraj on 13/09/22.
//

import Foundation
import UIKit

class SectionNameViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chipCollectionView: UICollectionView!
    
    var vision: Vision = RealmManager.shared.getVisionData()
    var chips: Chips!
    var prefillTextField: Bool = true
    
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
        self.configureCollectionView()
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
            break
        case .opened:
            self.nextButtonBottomConstraint.constant = keyboardHeight + 5
            break
        }
        super.adjustLayoutFor(keyboardState: keyboardState, userInfo: userInfo)
    }
    
    func configureCollectionView() {
        self.chips = Chips.instance(with: [
            "Work", "Travel", "Health", "Relationships", "Work", "Travel", "Health", "Relationships"
        ])
        self.chipCollectionView.delegate = self
        self.chipCollectionView.dataSource = self
        self.chipCollectionView.reloadData()
    }
    
    func configureTextField() {
        self.textField.addTarget(self, action: #selector(textfieldDidChangeText(_ :)), for: .editingChanged)
        self.textField.delegate = self
        if self.prefillTextField {
            self.textField.text = self.vision.sections.first?.name
        }
    }
    
    func validateTextField() {
        guard let text = textField.text else {
            self.nextStepButton.isEnabled = false
            return
        }
        self.nextStepButton.isEnabled = (text.isEmpty == false)
    }
    
    func addButtonTargets() {
        self.nextStepButton.addTarget(self, action: #selector(onNextTap(_:)), for: .touchUpInside)
    }
    
    @objc
    func onNextTap(_: UIButton) {
        try! RealmManager.shared.write({
            let section = VisionSection()
            section.name = textField.text!
            self.vision.sections.append(section)
        })
        self.textField.resignFirstResponder()
        self.navigationController?.setViewControllers([VisionBoardViewController.instance()], animated: true)
    }
}

extension SectionNameViewController: UITextFieldDelegate {
    @objc
    func textfieldDidChangeText(_ textField: UITextField) {
        self.validateTextField()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension SectionNameViewController: UICollectionViewDelegate, UICollectionViewDataSource, ChipDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.chips.sections[indexPath.section].rows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.reuseIdentifier, for: indexPath) as! ChipCell
        cell.configureCellFor(row: row, owner: self, indexPath: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.chips.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chips.sections[section].rows.count
    }
    
    func chipTapped(at indexPath: IndexPath) {
        self.textField.text = self.chips.sections[indexPath.section].rows[indexPath.row].text
        self.validateTextField()
    }
}
