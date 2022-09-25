//
//  LaunchViewController.swift
//  Gratitude
//
//  Created by Yuvaraj on 13/09/22.
//

import Foundation
import UIKit

class LaunchViewController: BaseViewController {
    @IBOutlet weak var nextStepButton: UIButton!
    
    override class var storyboardName: String {
        return "Onboarding"
    }
    
    override var dismissesKeyboardOnTap: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonTargets()
    }
    
    func addButtonTargets() {
        self.nextStepButton.addTarget(self, action: #selector(onNextTap(_:)), for: .touchUpInside)
    }
    
    @objc
    func onNextTap(_: UIButton) {
        self.navigationController?.pushViewController(NameViewController.instance(), animated: true)
    }
}
