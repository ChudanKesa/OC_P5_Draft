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
    
    var upperYPosition = CGFloat()
    var downYPosition = CGFloat()
    
    private func getPositionValues(up: inout CGFloat, down: inout CGFloat){
            up = rectangle.frame.origin.y
            down = leftButton.frame.origin.y
        }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TestView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        getPositionValues(up: &upperYPosition, down: &downYPosition)
    }

    
    @IBAction func rightButtonTuched(_ sender: UIButton) {
        print("Right Button touched")
    }
    @IBAction func rectangleTouched(_ sender: UIButton) {
        print("Rectangle Button touched")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rectangle"), object: nil)
    }
    @IBAction func leftButtonTouched(_ sender: UIButton) {
        print("Left Button touched")
    }
    @IBAction func topRightButtonTouched(_ sender: UIButton) {
        print("Top Right Button touched")
    }
    @IBAction func topLeftButtonTouched(_ sender: UIButton) {
        print("Top Left Button touched")
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
                },
                               completion: nil
                )
            case .third:
                break
            }
        }
    }
    


}
