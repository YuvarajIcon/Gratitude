//
//  VisionBoardEditingController.swift
//  Gratitude
//
//  Created by Yuvaraj on 23/09/22.
//

import Foundation
import UIKit
import RealmSwift

class VisionBoardEditingController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var vision: Vision = RealmManager.shared.getVisionData()
    var selectedIndexPath: IndexPath!
    var attachedPhotos: AttachedPhotos!
    var token: NotificationToken?
    
    override class var storyboardName: String {
        return "VisionBoard"
    }
    
    override var leftBarButtonConfig: ButtonConfig {
        let backButton = BackButton()
        backButton.setTitle(self.vision.sections[self.selectedIndexPath.section].name)
        backButton.setImage(UIImage(named: "backArrowGray"))
        return ButtonConfig(type: .custom, value: backButton)
    }
    
    override var dismissesKeyboardOnTap: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attachedPhotos = AttachedPhotos.instance(with: self.vision, for: self.selectedIndexPath)
        self.addButtonTargets()
        self.configureTableView()
        self.observeVision()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureTitle()
    }
    
    func observeVision() {
        self.token = vision.observe(keyPaths: ["sections.photos"], { [weak self] change in
            guard let self else { return }
            DispatchQueue.main.async {
                self.attachedPhotos = AttachedPhotos.instance(with: self.vision, for: self.selectedIndexPath)
                self.reloadTableView()
            }
        })
    }
    
    func addButtonTargets() {
        self.addPhotoButton.addTarget(self, action: #selector(addPhotoTapped(_ :)), for: .touchUpInside)
        self.doneButton.addTarget(self, action: #selector(doneTapped(_ :)), for: .touchUpInside)
    }
    
    func configureTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = .init(top: 0, left: 0, bottom: 56, right: 0)
        self.reloadTableView()
    }
    
    func reloadTableView() {
        if self.attachedPhotos.sections.isEmpty {
            self.buttonStackView.isHidden = true
            self.tableView.backgroundView = self.createEmptyView()
        } else {
            self.buttonStackView.isHidden = false
            self.tableView.backgroundView = nil
        }
        self.tableView.reloadData()
    }
    
    func createEmptyView() -> UIView {
        let emptyView = EmptyPhotoView()
        let index = self.selectedIndexPath.section
        emptyView.button.addTarget(self, action: #selector(addPhotoTapped(_ :)), for: .touchUpInside)
        emptyView.visionLabel.text = "Start manifesting your \(vision.sections[index].name)"
        return emptyView
    }
    
    func deletePhoto(at indexPath: IndexPath) {
        try! RealmManager.shared.write({
            self.vision.sections[self.selectedIndexPath.section].photos.remove(at: indexPath.section)
        })
    }
    
    func captionAdded(at indexPath: IndexPath, as caption: String?) {
        try! RealmManager.shared.write({
            self.vision.sections[self.selectedIndexPath.section].photos[indexPath.row].caption = caption
        })
    }
    
    @objc
    func addPhotoTapped(_ sender: UIButton) {
        self.isLoading = true
        ConnectionManager.shared.searchPexel(for: self.vision.sections[self.selectedIndexPath.section].name, count: 20).then({ result in
            let urls = result.photos.map({ $0.src.large })
            let pexelController = PexelsImagePickerController.instance()
            pexelController.selectedIndexPath = self.selectedIndexPath
            pexelController.searchResult = result
            pexelController.urls = urls
            self.navigationController?.pushViewController(pexelController, animated: true)
        }).always({
            self.isLoading = false
        })
    }
    
    @objc
    func doneTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VisionBoardEditingController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = attachedPhotos.sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath) as! EditPhotoCell
        cell.configureCellFor(row: row, owner: self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachedPhotos.sections[section].rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return attachedPhotos.sections.count
    }
}
