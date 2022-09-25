//
//  BaseViewController.swift
//  Gratitude
//
//  Created by Yuvaraj on 14/09/22.
//

import Foundation
import UIKit

protocol StoryBoardProtocol {
    static var storyboardName: String { get }
    static func instance() -> Self
}

public protocol NibLoadable {
    static var nibName: String { get }
}

public extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: Self.self)
    }

    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }

    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Error loading \(self) from nib") }
        self.addSubview(view)
        view.attachAllAnchors(to: self)
    }
}

enum KeyboardState {
    case closed
    case opened
}

enum PaletteColor: CaseIterable {
    case yellow
    case pink
    case green
    case blue
    static func color(for index: Int) -> UIColor {
        switch index {
        case 0:
            return .palleteYellow
        case 1:
            return .palletePink
        case 2:
            return .palleteGreen
        case 3:
            return .palleteBlue
        default:
            return .palleteYellow
        }
    }
}

enum BarButtonType {
    case kNil
    case image
    case title
    case system
    case custom
}

struct ButtonConfig {
    var type: BarButtonType
    var value: Any?
}

extension StoryBoardProtocol {
    static func instance() -> Self {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier:String(describing: self)) as! Self
    }
    
    static func instanceWithNavigationController(isLargeTitle: Bool = false, isTranslucent: Bool = false, presentationStyle: UIModalPresentationStyle = .fullScreen) -> UINavigationController {
        return instanceWithNavigationControllerTuple(isLargeTitle: isLargeTitle, isTranslucent: isTranslucent, presentationStyle: presentationStyle).0
    }
    
    static func instanceWithNavigationControllerTuple(isLargeTitle: Bool = false, isTranslucent: Bool = false, presentationStyle: UIModalPresentationStyle = .fullScreen) -> (UINavigationController, Self) {
        let controller = instance()
        let navigationController = NavigationController(rootViewController: controller as! UIViewController, largeTitle: isLargeTitle, translucentHeader: isTranslucent)
        navigationController.modalPresentationStyle = presentationStyle
        return (navigationController, controller)
    }
}

class BaseViewController: UIViewController, StoryBoardProtocol {
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint("\(String(describing: type(of: self))) deinit")
    }
    
    class var storyboardName: String {
        return "Base"
    }
    
    var respondsForKeyboardNotification: Bool {
        return true
    }
    
    var dismissesKeyboardOnTap: Bool  {
        return false
    }
    
    var navigationButtonConfigurations: (ButtonConfig, ButtonConfig) {
        return (leftBarButtonConfig, rightBarButtonConfig)
    }
    
    var leftBarButtonConfig: ButtonConfig {
        return ButtonConfig(type: .kNil)
    }
    
    var rightBarButtonConfig: ButtonConfig {
        return ButtonConfig(type: .kNil)
    }
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                self.view.isUserInteractionEnabled = false
                self.view.alpha = 0.5
                self.showLoader()
            } else {
                self.view.isUserInteractionEnabled = true
                self.view.alpha = 1
                self.hideLoader()
            }
        }
    }
    
    var activityIndicator: Loader?
    var observers = [NSObjectProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureGestureRecognizers()
        self.configureLeftBarButton()
        self.configureRightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.respondsForKeyboardNotification {
            observers.append(contentsOf: [
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { (notification) in
                self.adjustLayoutFor(keyboardState: .opened, userInfo: notification.userInfo!)
            }),
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { (notification) in
                self.adjustLayoutFor(keyboardState: .closed, userInfo: notification.userInfo!)
            })])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.respondsForKeyboardNotification {
            for observer in observers {
                NotificationCenter.default.removeObserver(observer)
            }
            observers.removeAll()
        }
    }
    
    func configureGestureRecognizers() {
        if self.dismissesKeyboardOnTap {
            let tapRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
            tapRecognizer.cancelsTouchesInView = true
            view.addGestureRecognizer(tapRecognizer)
        }
    }
    
    func adjustLayoutFor(keyboardState: KeyboardState, userInfo: [AnyHashable : Any]) {
        if self.presentedViewController != nil { return }
        let animationCurve = UIView.AnimationCurve(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSInteger)!
        var animationOptions: UIView.AnimationOptions
        switch animationCurve {
        case .easeInOut:
            animationOptions = [.beginFromCurrentState, .curveEaseInOut]
        
        case .easeIn:
            animationOptions = [.beginFromCurrentState, .curveEaseIn]
        
        case .easeOut:
            animationOptions = [.beginFromCurrentState, .curveEaseOut]
        
        case .linear:
            animationOptions = [.beginFromCurrentState, .curveLinear]
            
        @unknown default:
            animationOptions = [.beginFromCurrentState, .curveLinear]
        }
        UIView.animate(withDuration: userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double, delay: 0, options: animationOptions, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func configureLeftBarButton () {
        let type = self.leftBarButtonConfig.type
        let value = self.leftBarButtonConfig.value
        switch type {
        case .image:
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: value as? UIImage, style: .done, target: self, action: #selector(leftBarButtonAction))
        case .title:
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: value as? String, style: .plain, target: self, action: #selector(leftBarButtonAction))
        case .system:
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: value as! UIBarButtonItem.SystemItem, target: self, action: #selector(leftBarButtonAction))
        case .custom:
            let view = value as! UIView
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftBarButtonAction)))
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
        default:
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc
    func leftBarButtonAction() {
        if let count = self.navigationController?.viewControllers.count, count > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureRightBarButton () {
        let type = self.rightBarButtonConfig.type
        let value = self.rightBarButtonConfig.value
        switch type {
        case .image:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: value as? UIImage, style: .done, target: self, action: #selector(rightBarButtonAction))
        case .title:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: value as? String, style: .plain, target: self, action: #selector(rightBarButtonAction))
        case .system:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: value as! UIBarButtonItem.SystemItem, target: self, action: #selector(rightBarButtonAction))
        case .custom:
            let view = value as! UIView
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightBarButtonAction)))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
        default:
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc
    func rightBarButtonAction() { }
    
    func showLoader() {
        guard self.activityIndicator == nil else {
            return
        }
        self.activityIndicator = Loader()
        self.activityIndicator?.indicator.style = .large
        self.activityIndicator?.indicator.startAnimating()
        self.view.addSubview(self.activityIndicator!)
        self.activityIndicator?.attachCenterXAnchor(to: self.view, withHeight: 150)
        self.activityIndicator?.attachCentenYAnchor(to: self.view, withWidth: 150)
    }
    
    func hideLoader() {
        guard let indicator = self.activityIndicator else {
            return
        }
        indicator.removeFromSuperview()
        self.activityIndicator = nil
    }
}

class NavigationController: UINavigationController {
    
    var prefersLargeTitle: Bool = false
    var prefersTransulent: Bool = false
    
    init(rootViewController: UIViewController, largeTitle: Bool, translucentHeader: Bool) {
        prefersLargeTitle = largeTitle
        prefersTransulent = translucentHeader
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateBarTintColor()
        navigationBar.prefersLargeTitles = prefersLargeTitle
        navigationBar.isTranslucent = prefersTransulent
    }
    
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .all
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       super.traitCollectionDidChange(previousTraitCollection)
       self.updateBarTintColor()
    }

    private func updateBarTintColor() {
        let color: UIColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
        self.navigationBar.backgroundColor = color
        self.view.backgroundColor = color
    }
}
