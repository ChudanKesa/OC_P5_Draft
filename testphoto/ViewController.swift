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
    
    var currentDeviceOrientation = UIDeviceOrientation.unknown
    
    lazy var rectangleNotificationName = NSNotification.Name(rawValue: "rectangle")
    lazy var rightButtonNotificationName = NSNotification.Name(rawValue: "rightButton")
    lazy var leftButtonNotificationName = NSNotification.Name(rawValue: "leftButton")
    lazy var topRightButtonNotificationName = NSNotification.Name(rawValue: "topRightButton")
    lazy var topLeftButtonNotificationName = NSNotification.Name(rawValue: "topLeftButton")
    
    lazy var currentImageViewToFill = UIImageView()
    lazy var associatedButton = UIButton()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var alreadySet = false
        let subviews = self.view.subviews
        
        for subview in subviews.indices {
            if subviews[subview] == firstLayoutButtonView { alreadySet = true }
        }
        if !alreadySet { setButtonsViews() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        picker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveView(gesture:)))
        customView.addGestureRecognizer(panGestureRecognizer)

        
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInRectangle), name: rectangleNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInRightButton), name: rightButtonNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInLeftButton), name: leftButtonNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInTopRightButton), name: topRightButtonNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(putPictureInTopLeftButton), name: topLeftButtonNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(notification:)), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    var isLandscape = false {
        didSet {
            adaptButtonsViewsToPhoneRotation()
            customView.shambles(from: TestView.layout.first, to: self.currentLayout, animated: false)
        }
    }
    var isPortrait = false {
        didSet {
            adaptButtonsViewsToPhoneRotation()
            customView.shambles(from: TestView.layout.first, to: self.currentLayout, animated: false)
        }
    }
    
    private func adaptButtonsViewsToPhoneRotation() {
        firstLayoutButtonView.frame = firstLayoutButton.frame
        secondLayoutButtonView.frame = secondLayoutButton.frame
        thirdLayoutButtonView.frame = thirdLayoutButton.frame
        switch currentLayout {
        case .first:
            selectedSign.frame = firstLayoutButtonView.frame
        case .second:
            selectedSign.frame = secondLayoutButtonView.frame
        case .third:
            selectedSign.frame = thirdLayoutButtonView.frame
        }
    }
    
    @objc
    func deviceDidRotate(notification: Notification) {
        self.currentDeviceOrientation = UIDevice.current.orientation
        // Ignore changes in device orientation if unknown, face up, or face down.
        if !UIDeviceOrientationIsValidInterfaceOrientation(currentDeviceOrientation) {
            return;
        }
        
        self.isLandscape = UIDeviceOrientationIsLandscape(currentDeviceOrientation);
        self.isPortrait = UIDeviceOrientationIsPortrait(currentDeviceOrientation);
    }
    
    enum direction: String {
        case horizontal, vertical, undefined
    }
    lazy var orientation = direction.undefined
    
    // Lets the view follow the user's fingers freely for 50px, then set a horizontal or vertical course.
    // View comes back in place if finger is lifted.
    @objc
    func moveView(gesture: UIPanGestureRecognizer) {
        
        var translationX = CGFloat()
        var translationY = CGFloat()
        let movement = gesture.translation(in: customView)
        
        switch gesture.state {
        case .began, .changed:
            if abs(movement.x) < 25 && abs(movement.y) < 25 && orientation == .undefined {
                translationY = movement.y
                translationX = movement.x
                
                customView.transform = CGAffineTransform(translationX: translationX, y: translationY)
            } else {
                if abs(movement.x) > abs(movement.y) && orientation == .undefined  { orientation = .horizontal }
                if abs(movement.y) > abs(movement.x) && orientation == .undefined  { orientation = .vertical }
                if orientation == .vertical {
                    translationX = 0
                    translationY = movement.y
                }
                if orientation == .horizontal {
                    translationY = 0
                    translationX = movement.x
                }
                
                if isPortrait {
                    if movement.y < -50 {
                        customView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    } else {
                        customView.backgroundColor = #colorLiteral(red: 0.7005076142, green: 0.7005076142, blue: 0.7005076142, alpha: 0.4212328767)
                    }
                } else if isLandscape {
                    if movement.x < -50 {
                        customView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    } else {
                        customView.backgroundColor = #colorLiteral(red: 0.7005076142, green: 0.7005076142, blue: 0.7005076142, alpha: 0.4212328767)
                    }
                }
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.customView.transform = CGAffineTransform(translationX: translationX, y: translationY)
                }
                )
            }
            
        case .ended, .cancelled:
            if isPortrait {
                if movement.y < -50 {
                    share()
                }
            } else if isLandscape {
                if movement.x < -50 {
                    share()
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: {self.customView.transform = .identity})
            orientation = .undefined
        default:
            break
        }

        
    }
    
    
    @objc
    func putPictureInRectangle() {
        currentImageViewToFill = self.customView.rectangleView
        associatedButton = self.customView.rectangle
        choosePicture()
    }
    @objc
    func putPictureInRightButton() {
        currentImageViewToFill = self.customView.rightButtonView
        associatedButton = self.customView.rightButton
        choosePicture()
    }
    @objc
    func putPictureInLeftButton() {
        currentImageViewToFill = self.customView.leftButtonView
        associatedButton = self.customView.leftButton
        choosePicture()
    }
    @objc
    func putPictureInTopRightButton() {
        currentImageViewToFill = self.customView.topRightButtonView
        associatedButton = self.customView.topRightButton
        choosePicture()
    }
    @objc
    func putPictureInTopLeftButton() {
        currentImageViewToFill = self.customView.topLeftButtonView
        associatedButton = self.customView.topLeftButton
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
            self.currentImageViewToFill.alpha = 1
            self.currentImageViewToFill.contentMode = .scaleAspectFill
            self.currentImageViewToFill.layer.masksToBounds = true
            self.currentImageViewToFill.clipsToBounds = true
            self.currentImageViewToFill.image = photo
            self.customView.setButtonStyle(button: self.associatedButton, style: self.customView.invisibleStyle)
        }
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var customView: TestView!
    
    
    @IBOutlet weak var firstLayoutButton: UIButton!
    @IBOutlet weak var secondLayoutButton: UIButton!
    @IBOutlet weak var thirdLayoutButton: UIButton!
    
    var firstLayoutButtonView = UIImageView()
    var secondLayoutButtonView = UIImageView()
    var thirdLayoutButtonView = UIImageView()
    
    var selectedSign = UIImageView()
    
    private func setButtonsViews() {
        
        self.view.addSubview(firstLayoutButtonView)
        self.view.addSubview(secondLayoutButtonView)
        self.view.addSubview(thirdLayoutButtonView)
        
        self.view.addSubview(selectedSign)
        selectedSign.frame = firstLayoutButton.frame
        selectedSign.contentMode = .scaleAspectFill
        selectedSign.layer.masksToBounds = true
        selectedSign.clipsToBounds = true
        selectedSign.image = UIImage(named: "Selected")
        selectedSign.isUserInteractionEnabled = false
        selectedSign.layer.zPosition = 2
        
        firstLayoutButtonView.frame = firstLayoutButton.frame
        secondLayoutButtonView.frame = secondLayoutButton.frame
        thirdLayoutButtonView.frame = thirdLayoutButton.frame

        
        customView.setButtonStyle(button: firstLayoutButton, style: customView.invisibleStyle)
        customView.setButtonStyle(button: secondLayoutButton, style: customView.invisibleStyle)
        customView.setButtonStyle(button: thirdLayoutButton, style: customView.invisibleStyle)
        
        firstLayoutButtonView.contentMode = .scaleAspectFill
        firstLayoutButtonView.layer.masksToBounds = true
        firstLayoutButtonView.clipsToBounds = true
        firstLayoutButtonView.image = UIImage(named: "Layout 1")
        firstLayoutButtonView.isUserInteractionEnabled = false
        firstLayoutButtonView.layer.zPosition = 1
        
        secondLayoutButtonView.contentMode = .scaleAspectFill
        secondLayoutButtonView.layer.masksToBounds = true
        secondLayoutButtonView.clipsToBounds = true
        secondLayoutButtonView.image = UIImage(named: "Layout 2")
        secondLayoutButtonView.isUserInteractionEnabled = false
        secondLayoutButtonView.layer.zPosition = 1
        
        thirdLayoutButtonView.contentMode = .scaleAspectFill
        thirdLayoutButtonView.layer.masksToBounds = true
        thirdLayoutButtonView.clipsToBounds = true
        thirdLayoutButtonView.image = UIImage(named: "Layout 3")
        thirdLayoutButtonView.isUserInteractionEnabled = false
        thirdLayoutButtonView.layer.zPosition = 1
    }
    
    lazy var currentLayout = TestView.layout.first
    
    @IBAction func firstLayoutButtonPushed(_ sender: UIButton) {
        customView.shambles(from: currentLayout, to: .first, animated: true)
        currentLayout = .first
        selectedSign.frame = firstLayoutButton.frame
    }
    
    @IBAction func secondLayoutButtonPushed(_ sender: UIButton) {
        customView.shambles(from: currentLayout, to: .second, animated: true)
        currentLayout = .second
        selectedSign.frame = secondLayoutButton.frame
    }
    
    @IBAction func thirdLayoutButtonPushed(_ sender: UIButton) {
        customView.shambles(from: currentLayout, to: .third, animated: true)
        currentLayout = .third
        selectedSign.frame = thirdLayoutButton.frame
    }
    
    @IBAction func check(_ sender: UIButton) {
        customView.check()
    }
    

    
    private func share() {
        customView.backgroundColor = #colorLiteral(red: 0.7005076142, green: 0.7005076142, blue: 0.7005076142, alpha: 0.4212328767)
        guard let viewToShare = customView.toUIImage() else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [viewToShare], applicationActivities: [])
        present(vc, animated: true)
    }
}






extension UIView {
    func toUIImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
