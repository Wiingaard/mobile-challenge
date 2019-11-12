//
//  ImageHelper.swift
//  pleo_challenge
//
//  Created by Martin Wiingaard on 12/11/2019.
//  Copyright © 2019 Fiks IVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImageHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    private let presenter: PublishSubject<UIViewController>
    private let imageResult = PublishSubject<UIImage?>()
    
    init(presenter: PublishSubject<UIViewController>) {
        self.presenter = presenter
        super.init()
    }
    
    func getImage() -> Observable<UIImage> {
        return selectImageSource().flatMap(presentImagePicker)
            .take(1)
            .filter { $0 != nil }
            .map { $0! }
    }
    
    private func selectImageSource() -> Observable<ImageSource> {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return .just(ImageSource.photoLibrary) }
        
        return Observable<ImageSource>.create { [weak self] observer -> Disposable in
            let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction.init(title: "Photo Library", style: .default, handler: { _ in
                observer.onNext(.photoLibrary)
                observer.onCompleted()
            }))
            actionSheet.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { _ in
                observer.onNext(.camera)
                observer.onCompleted()
            }))
            actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
                observer.onCompleted()
            }))
            self?.presenter.onNext(actionSheet)
            return Disposables.create {
                actionSheet.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    lazy var presentImagePicker: (ImageSource) -> Observable<UIImage?> = { [weak self] source -> Observable<UIImage?> in
        let imageController = UIImagePickerController.init()
        imageController.delegate = self
        switch source {
        case .camera:
            imageController.sourceType = .camera
        case .photoLibrary:
            imageController.sourceType = .photoLibrary
        }
        self?.presenter.onNext(imageController)
        return self?.imageResult.asObservable() ?? .empty()
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return  }
        imageResult.onNext(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imageResult.onNext(nil)
    }
    
}
