//
//  UIApplication.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit

extension UIApplication {
    var safeKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive || $0.activationState == .foregroundInactive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}
