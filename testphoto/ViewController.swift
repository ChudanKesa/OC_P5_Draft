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
    lazy var rightButtonNotificationName = NSNotification.Name(rawValue: "rightButton")
    lazy var leftButtonNotificationName = NSNotification.Name(rawValue: "leftButton")
    lazy var topRightButtonNotificationName = NSNotification.Name(rawValue: "topRightButton")
    lazy var topLeftButtonNotificationName = NSNotification.Name(rawValue: "topLeftButton")
    
    lazy var currentImageViewToFill = UIImageView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInRectangle), name: rectangleNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInRightButton), name: rightButtonNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInLeftButton), name: leftButtonNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInTopRightButton), name: topRightButtonNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInTopLeftButton), name: topLeftButtonNotificationName, object: nil)
    }
    
    
    @objc
    func putPictureInRectangle() {
        currentImageViewToFill = self.customView.rectangleView
        choosePicture()
    }
    @objc
    func putPictureInRightButton() {
        currentImageViewToFill = self.customView.rightButtonView
        choosePicture()
    }
    @objc
    func putPictureInLeftButton() {
        currentImageViewToFill = self.customView.leftButtonView
        choosePicture()
    }
    @objc
    func putPictureInTopRightButton() {
        currentImageViewToFill = self.customView.topRightButtonView
        choosePicture()
    }
    @objc
    func putPictureInTopLeftButton() {
        currentImageViewToFill = self.customView.topLeftButtonView
        choosePicture()
    }

    func choosePicture() {
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
            self.currentImageViewToFill.isHidden = false
            self.currentImageViewToFill.contentMode = .scaleAspectFill
            self.currentImageViewToFill.layer.masksToBounds = true
            self.currentImageViewToFill.clipsToBounds = true
            self.currentImageViewToFill.image = photo
        }
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    @IBAction func check(_ sender: UIButton) {
        customView.check()
    }
    
}

