//
//  AddStudentViewController.swift
//  TutoringSchedule
//
//  Created by 김하은 on 2023/09/30.
//

import UIKit

class AddStudentViewController: UIViewController {
    
    private let mainView = EditStudentView()
    private let realmRepository = RealmRepository()
    var delegate: saveSucsessDelegate?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "학생 등록"
        
        let backItem = UIBarButtonItem(image: UIImage(systemName: "lessthan.circle.fill"), style: .plain, target: self, action: #selector(backButtonTapped))
        backItem.width = 70
        backItem.tintColor = .black
        navigationItem.leftBarButtonItem = backItem
        
        let saveItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.checkmark"), style: .plain, target: self, action: #selector(saveButtonTapped))
        saveItem.width = 100
        saveItem.tintColor = .black
        navigationItem.rightBarButtonItem = saveItem

        mainView.memoTextField.addTarget(self, action: #selector(endEdit), for: .editingDidEndOnExit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.nameTextField.becomeFirstResponder()
    }
    
    @objc private func addScheduleButtonTapped() {
        let vc = AddScheduleViewController()
        self.present(vc, animated: true)
    }
    
    @objc private func endEdit(_ sender: UITextField) {
        view.endEditing(true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let name = mainView.nameTextField.text, !name.isEmpty else {
            mainView.nameTextField.becomeFirstResponder()
            let alert = UIAlertController().customMessageAlert(message: "이름 입력은 필수입니다")
            present(alert, animated: true)
            return //필수체크
        }
        
        var studentPhoneNum: String
        
        if let studentPhoneNumText = mainView.studentPhoneNumTextField.text, !studentPhoneNumText.isEmpty{
            if isInt(text: studentPhoneNumText) {
                studentPhoneNum = studentPhoneNumText
            }else {
                mainView.studentPhoneNumTextField.becomeFirstResponder()
                let alert = UIAlertController().customMessageAlert(message: "번호는 숫자만 입력해주세요")
                present(alert, animated: true)
                return
            }
        }else {
            studentPhoneNum = ""
        }
         
        var parentPhoneNum: String
        
        if let parentPhoneNumText = mainView.parentPhoneNumTextField.text, !parentPhoneNumText.isEmpty {
            if isInt(text: parentPhoneNumText) {
                parentPhoneNum = parentPhoneNumText
            }else {
                mainView.parentPhoneNumTextField.becomeFirstResponder()
                let alert = UIAlertController().customMessageAlert(message: "번호는 숫자만 입력해주세요")
                present(alert, animated: true)
                return
            }
        }else {
            parentPhoneNum = ""
        }

        let address = mainView.addressTextField.text ?? ""
        let memo = mainView.memoTextField.text ?? ""
        
        let data = StudentTable(name: name, studentPhoneNum: studentPhoneNum, parentPhoneNum: parentPhoneNum, address: address, memo: memo)
        realmRepository.create(data: data)
        delegate?.saveSucsess()
        navigationController?.popViewController(animated: true)
    }
    
    func isInt(text: String) -> Bool {
        return Int(text) ?? -1 != -1 ? true : false
    }
}