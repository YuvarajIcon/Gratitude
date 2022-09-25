//
//  ImageSelector.swift
//  Gratitude
//
//  Created by Yuvaraj on 25/09/22.
//

import Foundation
import UIKit

protocol SelectionCarouselDelegate: AnyObject {
    func doneTapped()
}

class SelectionCarouselView: UIView, NibLoadable {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    static var nibName: String = "SelectionCarousel"
    
    @MainActor
    var imageURLStrings: [String] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    weak var delegate: SelectionCarouselDelegate?
    
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
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(LoadableImageCell.self, forCellWithReuseIdentifier: "loadableCellID")
        self.collectionView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        self.addButtonTargets()
    }
    
    func addButtonTargets() {
        self.doneButton.addTarget(self, action: #selector(doneTapped(_ :)), for: .touchUpInside)
    }
    
    @objc
    func doneTapped(_ button: UIButton) {
        delegate?.doneTapped()
    }
}

extension SelectionCarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadableCellID", for: indexPath) as! LoadableImageCell
        cell.configure(with: self.imageURLStrings[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLStrings.count
    }
}
