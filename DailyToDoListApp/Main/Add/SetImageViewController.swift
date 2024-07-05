//
//  SetImageViewController.swift
//  DailyToDoListApp
//
//  Created by 김상규 on 7/5/24.
//

import UIKit
import SnapKit

final class SetImageViewController: BaseViewController {
    private let imagePickerView = UIImagePickerController()
    @objc private let saveButton = UIButton()
    private var image: UIImage?
    var beforeVC: AddToDoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerView.delegate = self

        addChild(imagePickerView as UIViewController)
        imagePickerView.view.frame = view.bounds
        
        view.addSubview(imagePickerView.view)
        imagePickerView.didMove(toParent: beforeVC ?? AddToDoViewController())
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            var configuration = UIButton.Configuration.plain()
            configuration.title = "저장"
            configuration.baseForegroundColor = .systemBlue
            
            self.saveButton.configuration = configuration
            self.saveButton.titleLabel?.font = .systemFont(ofSize: 17)
            self.imagePickerView.view.addSubview(self.saveButton)
            
            self.saveButton.snp.makeConstraints { make in
                make.top.trailing.equalTo(self.imagePickerView.view.safeAreaLayoutGuide).inset(3)
                make.height.equalTo(50)
                make.width.equalTo(60)
            }
        }
        
        saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
    }
    
    override func configureNavigationBar() {
//        navigationItem.title = "사진 선택"
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveImage))
    }
    
    @objc private func saveImage() {
        if let vc = beforeVC {
            vc.sendImage(image: self.image)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension SetImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.image = nil
        saveImage()
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.image = image
        }
    }
}
