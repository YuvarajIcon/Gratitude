//
//  Router.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit

class GratitudeRouter {
    private static var sharedInstance: GratitudeRouter?
    class var shared: GratitudeRouter {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = GratitudeRouter()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    class func deinitializeSharedInstance() {
        sharedInstance = nil
    }
    
    static var mainWindow: UIWindow?
    
    func route() {
        if RealmManager.shared.getVisionData().sections.isEmpty == false {
            GratitudeRouter.mainWindow?.rootViewController = VisionBoardViewController.instanceWithNavigationController(isLargeTitle: true)
        } else {
            GratitudeRouter.mainWindow?.rootViewController = LaunchViewController.instanceWithNavigationController()
        }
    }
}
