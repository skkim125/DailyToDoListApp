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
    
    var beforeVC: AddToDoViewController?
    
    override func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = true
    }
    
    override func configureHierarchy() {
        addChild(imagePickerView as UIViewController)
        imagePickerView.view.frame = view.bounds
        
        view.addSubview(imagePickerView.view)
        imagePickerView.didMove(toParent: beforeVC ?? AddToDoViewController())
    }
    
    override func configureView() {
        imagePickerView.delegate = self
    }
}

extension SetImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            if let vc = beforeVC {
                vc.sendImage(image: image)
            }
            navigationController?.popViewController(animated: true)
        }
    }
}
