//
//  ViewController.swift
//  testphoto
//
//  Created by Erwan Le Querré on 15/04/2018.
//  Copyright © 2018 Erwan Le Querré. All rights reserved.
//

import UIKit
import MobileCoreServices
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    lazy var picker: UIImagePickerController = {
        var picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeImage as String]
        return picker
    }()
    
    lazy var rectangleNotificationName = NSNotification.Name(rawValue: "rectangle")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(putPhotoInRectangle), name: rectangleNotificationName, object: nil)
        
    }
    
    
    @objc
    func putPhotoInRectangle() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let photo = (info[UIImagePickerControllerEditedImage] ?? info[UIImagePickerControllerOriginalImage]) as? UIImage {
            self.image.image = photo
            self.customView.rectangle.setImage(photo, for: .normal)
        }
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var image: UIImageView! {
        didSet {
            image.layer.masksToBounds = true
            image.clipsToBounds = true
        }
    }
    
    @IBAction func firstButton(_ sender: UIButton) {

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }

    
    
    
    
    @IBOutlet weak var customView: TestView!
    
    lazy var currentLayout = TestView.layout.first
    
    @IBAction func firstLayoutButtonPushed(_ sender: UIButton) {
        customView.shambles(from: currentLayout, to: .first)
        currentLayout = .first
    }
    
    @IBAction func secondLayoutButtonPushed(_ sender: UIButton) {
        customView.shambles(from: currentLayout, to: .second)
        currentLayout = .second
    }
    
    @IBAction func thirdLayoutButtonPushed(_ sender: UIButton) {
        customView.shambles(from: currentLayout, to: .third)
        currentLayout = .third
    }
    
    let name = NSNotification.Name(rawValue: "rectangle")
    
    
    

    
}

