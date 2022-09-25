//
//  PhotoSectionCell.swift
//  Gratitude
//
//  Created by Yuvaraj on 16/09/22.
//

import Foundation
import UIKit

class PhotoSectionCell: BasePhotoSectionCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func configureCellFor(row: BaseRow, owner: VisionBoardViewController, indexPath: IndexPath) {
        super.configureCellFor(row: row, owner: owner, indexPath: indexPath)
        self.configure()
    }
    
    func configure() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = self.createLayout()
        guard let row = row as? BoardRow else {
            return
        }
        let photos = row.photos.rows
        if photos.count == 5 {
            self.collectionViewHeightConstraint.constant = 286
        } else {
            self.collectionViewHeightConstraint.constant = 134
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func onTap(_ sender: UIButton) {
        self.owner.photoCellTapped(on: self.indexPath)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let row = self.row as? BoardRow else {
                return self.fiveItemSection()
            }
            let photos = row.photos.rows
            switch photos.count {
            case 1:
                return self.oneItemSection()
            case 2:
                return self.twoItemSection()
            case 3:
                return self.threeItemSection()
            case 4:
                return self.fourItemSection()
            case 5:
                return self.fiveItemSection()
            default:
                return self.fourItemSection()
            }
        }
        return layout
    }
    
    func fiveItemSection() -> NSCollectionLayoutSection {
        let insets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)))
        leadingItem.contentInsets = insets
        let leadingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0)),
            subitem: leadingItem, count: 2)

        let topItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)))
        topItem.contentInsets = insets
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitem: topItem, count: 2)
        
        let trailingContainerGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0)),
            subitems: [topItem, trailingGroup])
        
        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)),
            subitems: [leadingGroup, trailingContainerGroup])
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func fourItemSection() -> NSCollectionLayoutSection {
        let insets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = insets
        let leadingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                              heightDimension: .fractionalHeight(1.0)),
            subitem: leadingItem, count: 2)

        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.5)))
        trailingItem.contentInsets = insets
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                              heightDimension: .fractionalHeight(1.0)),
            subitem: trailingItem, count: 2)

        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)),
            subitems: [leadingGroup, trailingGroup])
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func threeItemSection() -> NSCollectionLayoutSection {
        let insets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = insets
        let leadingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0)),
            subitem: leadingItem, count: 1)

        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.3)))
        trailingItem.contentInsets = insets
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0)),
            subitem: trailingItem, count: 2)

        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)),
            subitems: [leadingGroup, trailingGroup])
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func twoItemSection() -> NSCollectionLayoutSection {
        let insets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = insets
        let leadingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0)),
            subitem: leadingItem, count: 2)
        let section = NSCollectionLayoutSection(group: leadingGroup)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func oneItemSection() -> NSCollectionLayoutSection {
        let insets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = insets
        let leadingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0)),
            subitem: leadingItem, count: 1)
        let section = NSCollectionLayoutSection(group: leadingGroup)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
}

extension PhotoSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let row = row as? BoardRow else {
            return 0
        }
        let photos = row.photos.rows
        guard photos.count != 0 else {
            return 5
        }
        return photos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = row as! BoardRow
        let id = row.photos.rows[indexPath.row].reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! PhotoCell
        cell.configureCellFor(row: row, owner: self, indexPath: indexPath)
        return cell
    }
}
