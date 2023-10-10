//
//  ScheduleManagementViewController.swift
//  TutoringSchedule
//
//  Created by 김하은 on 2023/10/06.
//

import UIKit

class ScheduleManagementViewController: UIViewController {

    private let mainView = ScheduleManagementView()
    private let realmRepository = RealmRepository()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "일정 관리"

        let addItem = UIBarButtonItem(image: UIImage(systemName: "text.badge.plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        addItem.width = 100
        addItem.tintColor = .black
        navigationItem.rightBarButtonItem = addItem
        
        guard let realmData = realmRepository.read(ScheduleTable.self) else { return }
        mainView.data = realmData
    }
    
    @objc private func addButtonTapped() {
        let vc = AddScheduleViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ScheduleManagementViewController: saveSucsessDelegate {
    func saveSucsess() {
        mainView.tableView.reloadData()
    }
}