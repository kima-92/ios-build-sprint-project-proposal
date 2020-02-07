//
//  AddItemViewController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Photos
import CoreData

class AddItemViewController: UIViewController {

    @IBOutlet weak var toyName: UITextField!
    @IBOutlet weak var toyImage: UIImageView!
    @IBOutlet weak var toyDescription: UITextView!
    var santaIWishController: SantaIWishController?
    var child: Child?
    @IBOutlet weak var uploadImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // Upload Button
    @IBAction func uploadImageButtonTapped(_ sender: UIButton) {
        presentImagePickerController()
    }
    
    // Upload Gesture
    @IBAction func pickImageButton(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        guard let child = child,
            let image = toyImage.image,
            toyName.text != "",
            let name = toyName.text,
            let description = toyDescription.text,
            let imageData = image.pngData() else { return }
        
        let item = Item(image: imageData, childNote: description, name: name, context: CoreDataStack.shared.mainContext)
        child.addToItems(item)
        CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)

        santaIWishController?.addItemToWishList(child: child, item: item)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func savePhotoToLibrary() {
        
        guard let image = toyImage.image else { return }
                
        PHPhotoLibrary.requestAuthorization { (status) in
            
            guard status == .authorized else { return }
            // Let the library know we are going to make changes
            PHPhotoLibrary.shared().performChanges({
                
                // Make a new photo creation request
                PHAssetCreationRequest.creationRequestForAsset(from: image)
                
            }, completionHandler: { (_, error) in
                
                if let error = error {
                    NSLog("Error saving photo: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("Saved image!")
                }
            })
        }
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The photo library is not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func updateViews() {
        toyDescription.text = ""
        self.hideKeyboardWhenTappedAround()
        uploadImageButton.layer.cornerRadius = 5
    }
}

extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not Found!")
            return
        }
        toyImage.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
