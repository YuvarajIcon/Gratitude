//
//  VisionBoardViewController.swift
//  Gratitude
//
//  Created by Yuvaraj on 13/09/22.
//

import Foundation
import UIKit
import RealmSwift

class VisionBoardViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addSectionButton: UIButton!
    
    override class var storyboardName: String {
        return "VisionBoard"
    }
    
    override var dismissesKeyboardOnTap: Bool {
        return true
    }
    
    var vision: Vision = RealmManager.shared.getVisionData()
    var boardInstance: VisionBoard!
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.boardInstance = VisionBoard.instance(with: self.vision)
        self.addButtonTargets()
        self.configureTableView()
        self.observeVision()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureTitle()
    }
    
    func configureTitle() {
        self.title = self.vision.boardName
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addButtonTargets() {
        self.addSectionButton.addTarget(self, action: #selector(addNewSectionTapped(_ :)), for: .touchUpInside)
    }
    
    func observeVision() {
        self.token = vision.observe(keyPaths: ["sections.photos"], { [weak self] change in
            guard let self else { return }
            DispatchQueue.main.async {
                self.boardInstance = VisionBoard.instance(with: self.vision)
                self.tableView.reloadData()
            }
        })
    }
    
    func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SectionHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerID")
    }
    
    @objc
    func addNewSectionTapped(_ button: UIButton) {
        let sectionController = SectionNameViewController.instance()
        sectionController.prefillTextField = false
        self.navigationController?.pushViewController(sectionController, animated: true)
    }
    
    func photoCellTapped(on indexPath: IndexPath) {
        let editingController = VisionBoardEditingController.instance()
        editingController.selectedIndexPath = indexPath
        self.navigationController?.pushViewController(editingController, animated: true)
    }
}

extension VisionBoardViewController: UITableViewDataSource, UITableViewDelegate, HeaderEditingDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = boardInstance.sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath) as! BasePhotoSectionCell
        cell.configureCellFor(row: row, owner: self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardInstance.sections[section].rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return boardInstance.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerText =  boardInstance.sections[section].headerText else {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerID") as! SectionHeaderFooterView
        headerView.indexPath = IndexPath(row: 0, section: section)
        headerView.editingDelegate = self
        headerView.configure(name: headerText)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func didEndEditing(with text: String, at indexPath: IndexPath) {
        if text.isEmpty {
            self.tableView.reloadData()
        } else {
            try! RealmManager.shared.write({
                self.vision.sections[indexPath.section].name = text
            })
        }
    }
}
