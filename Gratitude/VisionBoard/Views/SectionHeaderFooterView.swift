//
//  SectionHeaderFooterView.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit

protocol HeaderEditingDelegate: AnyObject {
    func didEndEditing(with: String, at: IndexPath)
}

class SectionHeaderFooterView: UITableViewHeaderFooterView, HeaderEditingDelegate {
    lazy var nameView: SectionNameView = {
        return SectionNameView()
    }()
    weak var editingDelegate: HeaderEditingDelegate?
    var indexPath: IndexPath!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(self.nameView)
        self.nameView.editingDelegate = self
        self.nameView.attachVerticalAnchors(to: self)
        self.nameView.attachLeftAnchor(to: self, distance: 20)
        self.nameView.attachRightAnchor(to: self)
    }
    
    func configure(name: String) {
        self.nameView.indexPath = self.indexPath
        self.nameView.text = name
        self.nameView.configure()
    }

    func didEndEditing(with text: String, at indexPath: IndexPath) {
        self.editingDelegate?.didEndEditing(with: text, at: indexPath)
    }
}
