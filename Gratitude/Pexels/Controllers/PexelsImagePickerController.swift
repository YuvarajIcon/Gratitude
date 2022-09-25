//
//  PexelsImagePickerController.swift
//  Gratitude
//
//  Created by Yuvaraj on 13/09/22.
//

import Foundation
import UIKit
import RealmSwift

class PexelsImagePickerController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectionView: SelectionCarouselView!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var toastConstraint: NSLayoutConstraint!
    @IBOutlet weak var toastView: UIView!
    @IBOutlet weak var searchBar: SearchBarView!
    
    override class var storyboardName: String {
        "Pexels"
    }
    
    override var leftBarButtonConfig: ButtonConfig {
        let backButton = BackButton()
        backButton.setTitle(nil)
        backButton.setImage(UIImage(named: "backArrowGray"))
        return ButtonConfig(type: .custom, value: backButton)
    }
    
    override var dismissesKeyboardOnTap: Bool {
        return true
    }
    
    var selectedURLStrings: [String] {
        return self.vision.sections[self.selectedIndexPath.section].photos.map({ $0.urlString })
    }
    var vision: Vision = RealmManager.shared.getVisionData()
    var pexelPhotos: PexelPhotos!
    var selectedIndexPath: IndexPath!
    var searchResult: PexelSearchResult!
    var urls: [String]!
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.observeVision()
        self.configureToast()
    }
    
    func configureView() {
        self.pexelPhotos = PexelPhotos.instance(with: urls, vision: self.vision, and: self.selectedIndexPath)
        self.searchBar.delegate = self
        self.searchBar.text = self.vision.sections[self.selectedIndexPath.section].name
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.isPrefetchingEnabled = true
        self.collectionView.prefetchDataSource = self
        self.collectionView.collectionViewLayout = self.twoBytwoGridLayout()
        self.selectionView.delegate = self
        self.selectionView.imageURLStrings = self.selectedURLStrings
        self.photoCountLabel.text = "\(self.selectedURLStrings.count) photos selected"
        self.selectionView.isHidden = self.selectedURLStrings.count == 0
        self.toastView.isHidden = self.selectionView.isHidden
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func observeVision() {
        self.token = vision.observe(keyPaths: ["sections.photos"], { [self] change in
            DispatchQueue.main.async {
                self.pexelPhotos = PexelPhotos.instance(with: self.urls, vision: self.vision, and: self.selectedIndexPath)
                self.selectionView.imageURLStrings = self.selectedURLStrings
                self.photoCountLabel.text = "\(self.selectedURLStrings.count) photos selected"
                self.selectionView.isHidden = self.selectedURLStrings.count == 0
                self.toastView.isHidden = self.selectionView.isHidden
                self.collectionView.reloadData()
            }
        })
    }
    
    func loadNextPagePhotos() {
        guard let nextURL = self.searchResult.nextPageURL else { return }
        ConnectionManager.shared.nextPexelPage(url: nextURL).then({ result in
            let urls = result.photos.map({ $0.src.large })
            self.searchResult = result
            self.urls.append(contentsOf: urls)
            self.urls = self.urls.filter({ $0.isEmpty == false })
            self.pexelPhotos = PexelPhotos.instance(with: self.urls, vision: self.vision, and: self.selectedIndexPath)
            self.collectionView.reloadData()
        })
    }
    
    func searchPhoto(for searchTerm: String) {
        self.isLoading = true
        ConnectionManager.shared.searchPexel(for: searchTerm, count: 20).then({ result in
            let urls = result.photos.map({ $0.src.large })
            self.searchResult = result
            self.urls = urls
            self.pexelPhotos = PexelPhotos.instance(with: self.urls, vision: self.vision, and: self.selectedIndexPath)
            self.collectionView.reloadData()
            try! RealmManager.shared.write({
                self.vision.sections[self.selectedIndexPath.section].photos.removeAll()
            })
        }).always({
            self.isLoading = false
        })
    }
    
    func twoBytwoGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func tappedPhoto(at indexPath: IndexPath, isSelected: Bool) {
        let row = self.pexelPhotos.sections[indexPath.section].rows[indexPath.row]
        let selectedURL = row.urlString
        if isSelected {
            guard self.selectedURLStrings.count < 5 else { return }
            self.addPhoto(of: selectedURL)
        } else {
            self.deletePhoto(of: selectedURL)
        }
        self.configureToast()
    }
    
    func configureToast() {
        if self.selectedURLStrings.count < 5 {
            self.toastConstraint.constant = 0
        } else {
            self.toastConstraint.constant = -48
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func addPhoto(of selectedURL: String) {
        try! RealmManager.shared.write({
            let visionPhoto = VisionPhoto()
            visionPhoto.urlString = selectedURL
            self.vision.sections[self.selectedIndexPath.section].photos.append(visionPhoto)
        })
    }
    
    func deletePhoto(of selectedURL: String) {
        guard let index = self.vision.sections[self.selectedIndexPath.section].photos.firstIndex(where: { $0.urlString == selectedURL }) else {
            return
        }
        try! RealmManager.shared.write({
            self.vision.sections[self.selectedIndexPath.section].photos.remove(at: index)
        })
    }
}

extension PexelsImagePickerController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.pexelPhotos.sections[indexPath.section].rows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.reuseIdentifier, for: indexPath) as! PexelPhotoCell
        cell.configureCellFor(row: row, owner: self, indexPath: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.pexelPhotos.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pexelPhotos.sections[section].rows.count
    }
}

extension PexelsImagePickerController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row > self.urls.count - 2 }) {
            self.loadNextPagePhotos()
        }
    }
}

extension PexelsImagePickerController: SelectionCarouselDelegate {
    func doneTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PexelsImagePickerController: TextFieldDelegate {
    func textFieldDidChange(_ textField: UITextField) { }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.isEmpty == false else {
            return
        }
        self.searchPhoto(for: text)
    }
}
