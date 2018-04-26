//
//  TestView.swift
//  testphoto
//
//  Created by Erwan Le Querré on 18/04/2018.
//  Copyright © 2018 Erwan Le Querré. All rights reserved.
//

import UIKit
import MobileCoreServices
import Foundation

class TestView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum layout {
        case first, second, third
    }
    
    lazy var currentStyle = layout.first
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rectangle: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    
    @IBOutlet weak var rectangleView: UIImageView!
    @IBOutlet weak var leftButtonView: UIImageView!
    @IBOutlet weak var rightButtonView: UIImageView!
    @IBOutlet weak var topLeftButtonView: UIImageView!
    @IBOutlet weak var topRightButtonView: UIImageView!
    
    
    var upperYPosition = CGFloat()
    var downYPosition = CGFloat()
    
    var bufferUpperYPos: CGFloat?
    var bufferDownYPos: CGFloat?
    // to avoid getPositionValues to be called several times, and at the same time not having upperYPos be a ?
    
    private func getPositionValues(up: inout CGFloat?, down: inout CGFloat?){
            up = rectangle.frame.origin.y
            down = leftButton.frame.origin.y
        }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TestView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let views = [rectangleView, leftButtonView, rightButtonView, topLeftButtonView, topRightButtonView]
        let buttons = [rectangle, leftButton, rightButton, topLeftButton, topRightButton]
        
        for index in views.indices {
            alignViewWithButton(view: views[index]!, button: buttons[index]!)
            views[index]?.isHidden = true
        }
        
        if bufferDownYPos == nil {
            getPositionValues(up: &bufferUpperYPos, down: &bufferDownYPos)
            upperYPosition = bufferUpperYPos!
            downYPosition = bufferDownYPos!
        }
    }
    
    private func alignViewWithButton(view: UIImageView, button: UIButton) {
        view.frame = button.frame
    }

    
    @IBAction func rightButtonTuched(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rightButton"), object: nil)
        print("Right Button touched")
    }
    @IBAction func rectangleTouched(_ sender: UIButton) {
        print("Rectangle Button touched")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rectangle"), object: nil)
    }
    @IBAction func leftButtonTouched(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "leftButton"), object: nil)
        print("Left Button touched")
    }
    @IBAction func topRightButtonTouched(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topRightButton"), object: nil)
        print("Top Right Button touched")
    }
    @IBAction func topLeftButtonTouched(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topLeftButton"), object: nil)
        print("Top Left Button touched")
    }
    

    func check() {
        if rectangle.isHidden { print("Rectangle hidden")}
         if leftButton.isHidden { print("Left Button hidden")}
         if rightButton.isHidden { print("Right Button hidden")}
         if topLeftButton.isHidden { print("topLeftButton hidden")}
         if topRightButton.isHidden { print("Top Right Button hidden")}
        print("Rectangle:")
        print(rectangle.frame.origin.x)
        print(rectangle.frame.origin.y)
        print("leftButton:")
        print(leftButton.frame.origin.x)
        print(leftButton.frame.origin.y)
        print("rightButton:")
        print(rightButton.frame.origin.x)
        print(rightButton.frame.origin.y)
        print("topLeftButton:")
        print(topLeftButton.frame.origin.x)
        print(topLeftButton.frame.origin.x)
        print("topRightButton:")
        print(topRightButton.frame.origin.x)
        print(topRightButton.frame.origin.y)
    }
    
    func shambles (from: layout, to: layout) {
        switch from {
        case .first:
            switch to {
            case .first:
                break
            case .second:

                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.rectangle.frame.origin.y = self.downYPosition
                                self.leftButton.frame.origin.y = self.upperYPosition
                                self.rightButton.frame.origin.y = self.upperYPosition
                                self.rectangleView.frame = self.rectangle.frame
                                self.topLeftButtonView.frame = self.leftButton.frame
                                self.topRightButtonView.frame = self.rightButton.frame
                },
                               completion: nil
                )
            case .third:
                topLeftButton.alpha = 0
                topLeftButton.isHidden = false
                topLeftButton.frame.origin.x -= 50
                topLeftButton.frame.origin.y -= 200
                topRightButton.alpha = 0
                topRightButton.isHidden = false
                topRightButton.frame.origin.x += 50
                topRightButton.frame.origin.y -= 200
                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.topLeftButton.alpha = 1
                                self.topLeftButton.frame.origin.x += 50
                                self.topLeftButton.frame.origin.y += 200
                                self.topRightButton.alpha = 1
                                self.topRightButton.frame.origin.x -= 50
                                self.topRightButton.frame.origin.y += 200
                                self.rectangle.frame.origin.y = self.downYPosition
                                self.rectangle.alpha = 0
                                
                                self.rectangleView.frame = self.rectangle.frame
                                self.topLeftButtonView.frame = self.leftButton.frame
                                self.topRightButtonView.frame = self.rightButton.frame
                                self.topRightButtonView.frame = self.topRightButton.frame
                                self.topLeftButtonView.frame = self.topLeftButton.frame
                },
                               completion: { _ in
                                self.rectangle.isHidden = true
                                self.rectangle.alpha = 1
                }
                )
            }
        case .second:
            switch to {
            case .first:
                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.rectangle.frame.origin.y = self.upperYPosition
                                self.leftButton.frame.origin.y = self.downYPosition
                                self.rightButton.frame.origin.y = self.downYPosition
                                self.rectangleView.frame = self.rectangle.frame
                                self.topLeftButtonView.frame = self.leftButton.frame
                                self.topRightButtonView.frame = self.rightButton.frame
                },
                               completion: nil
                )
            case .second:
                break
            case .third:
                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.rectangle.frame.origin.y = self.upperYPosition
                                self.rectangle.isHidden = true
                                self.leftButton.frame.origin.y = self.downYPosition
                                self.rightButton.frame.origin.y = self.downYPosition
                                self.topRightButton.isHidden = false
                                self.topLeftButton.isHidden = false
                                
                                self.rectangleView.frame = self.rectangle.frame
                                self.topLeftButtonView.frame = self.leftButton.frame
                                self.topRightButtonView.frame = self.rightButton.frame
                                self.topRightButtonView.frame = self.topRightButton.frame
                                self.topLeftButtonView.frame = self.topLeftButton.frame
                },
                               completion: nil
                )
            }
        case .third:
            switch to {
            case .first:
                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.topLeftButton.isHidden = true
                                self.topRightButton.isHidden = true
                                self.rectangle.frame.origin.y = self.upperYPosition
                                self.rectangle.isHidden = false
                                self.leftButton.frame.origin.y = self.downYPosition
                                self.rightButton.frame.origin.y = self.downYPosition
                                
                                self.rectangleView.frame = self.rectangle.frame
                                self.topLeftButtonView.frame = self.leftButton.frame
                                self.topRightButtonView.frame = self.rightButton.frame
                                self.topRightButtonView.frame = self.topRightButton.frame
                                self.topLeftButtonView.frame = self.topLeftButton.frame
                },
                               completion: nil
                )
            case .second:
                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.rectangle.frame.origin.y = self.downYPosition
                                self.rectangle.isHidden = false
                                self.topRightButton.isHidden = true
                                self.topLeftButton.isHidden = true
                                self.leftButton.frame.origin.y = self.upperYPosition
                                self.rightButton.frame.origin.y = self.upperYPosition
                                
                                self.rectangleView.frame = self.rectangle.frame
                                self.topLeftButtonView.frame = self.leftButton.frame
                                self.topRightButtonView.frame = self.rightButton.frame
                                self.topRightButtonView.frame = self.topRightButton.frame
                                self.topLeftButtonView.frame = self.topLeftButton.frame
                },
                               completion: nil
                )
            case .third:
                break
            }
        }
    }
    


}
