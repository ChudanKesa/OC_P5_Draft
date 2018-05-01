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
    
    
    var rightButtonStyle = ButtonStyle()
    var leftButtonStyle = ButtonStyle()
    var rectangleStyle = ButtonStyle()
    var topRightButtonStyle = ButtonStyle()
    var topLeftButtonStyle = ButtonStyle()
    
    
    lazy var invisibleStyle: ButtonStyle = {
        var style = ButtonStyle()
        style.color = UIColor(white: 1, alpha: 0)
        style.text = ""
        style.textColor = UIColor(white: 1, alpha: 0)
        guard let font = UIFont(name: "System", size: 0) else { return style }
        style.font = font
        return style
    }()
    
    
    
    
    func reccordStyles() {
        let buttons = [rectangle, leftButton, rightButton, topLeftButton, topRightButton]
        let styles = [rectangleStyle, leftButtonStyle, rightButtonStyle, topLeftButtonStyle, topRightButtonStyle]
        for index in buttons.indices {
            styles[index].color = buttons[index]!.backgroundColor!
            styles[index].font = buttons[index]!.titleLabel!.font
            styles[index].text = buttons[index]!.currentTitle!
            styles[index].textColor = buttons[index]!.titleLabel!.textColor
        }
    }
    
    func setButtonStyle(button: UIButton, style: ButtonStyle) {
        button.backgroundColor = style.color
        button.titleLabel!.font = style.font
        button.titleLabel!.text = style.text
        button.titleLabel!.textColor = style.textColor
    }
    
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
        
        for index in views.indices {
            views[index]!.alpha = 0
            views[index]!.layer.zPosition = -1
            views[index]?.isUserInteractionEnabled = false
        }
        
        viewsToFollowButtons()
        
        if bufferDownYPos == nil {
            getPositionValues(up: &bufferUpperYPos, down: &bufferDownYPos)
            upperYPosition = bufferUpperYPos!
            downYPosition = bufferDownYPos!
        }
        
        reccordStyles()
    }


    
    @IBAction func rightButtonTuched(_ sender: UIButton) {
        sendNotification("rightButton")
    }
    @IBAction func rectangleTouched(_ sender: UIButton) {
        sendNotification("rectangle")
    }
    @IBAction func leftButtonTouched(_ sender: UIButton) {
        sendNotification("leftButton")
    }
    @IBAction func topRightButtonTouched(_ sender: UIButton) {
        sendNotification("topRightButton")
    }
    @IBAction func topLeftButtonTouched(_ sender: UIButton) {
        sendNotification("topLeftButton")
    }
    
    private func sendNotification(_ name: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    
    private func hideViewIfButtonIs() {
        let views = [rectangleView, leftButtonView, rightButtonView, topLeftButtonView, topRightButtonView]
        let buttons = [rectangle, leftButton, rightButton, topLeftButton, topRightButton]
        
        for index in views.indices {
            views[index]!.alpha = buttons[index]!.alpha
        }
    }
    
    private func viewsToFollowButtons() {
        let views = [rectangleView, leftButtonView, rightButtonView, topLeftButtonView, topRightButtonView]
        let buttons = [rectangle, leftButton, rightButton, topLeftButton, topRightButton]
        
        for index in views.indices {
            views[index]!.frame = buttons[index]!.frame
        }
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
                                self.viewsToFollowButtons()
                                self.hideViewIfButtonIs()
                },
                               completion: nil
                )
            case .third:
                topLeftButton.alpha = 0
                topLeftButton.frame.origin.x -= 50
                topLeftButton.frame.origin.y -= 200
                topRightButton.alpha = 0
                topRightButton.frame.origin.x += 50
                topRightButton.frame.origin.y -= 200
                viewsToFollowButtons()
                hideViewIfButtonIs()
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
                                
                                self.viewsToFollowButtons()
                                self.hideViewIfButtonIs()
                },
                               completion: nil
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
                                
                                self.viewsToFollowButtons()
                                self.hideViewIfButtonIs()
                },
                               completion: nil
                )
            case .second:
                break
            case .third:
                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.rectangle.frame.origin.y = self.upperYPosition
                                self.rectangle.alpha = 0
                                self.leftButton.frame.origin.y = self.downYPosition
                                self.rightButton.frame.origin.y = self.downYPosition
                                self.topRightButton.alpha = 1
                                self.topLeftButton.alpha = 1
                                
                                self.viewsToFollowButtons()
                                self.hideViewIfButtonIs()
                },
                               completion: nil
                )

            }
        case .third:
            switch to {
            case .first:
                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.topLeftButton.alpha = 0
                                self.topRightButton.alpha = 0
                                self.rectangle.frame.origin.y = self.upperYPosition
                                self.rectangle.alpha = 1

                                self.viewsToFollowButtons()
                                self.hideViewIfButtonIs()
                },
                               completion: nil
                )
            case .second:
                UIView.animate(withDuration: 1.0,
                               animations: {
                                self.rectangle.frame.origin.y = self.downYPosition
                                self.rectangle.alpha = 1
                                self.topRightButton.alpha = 0
                                self.topLeftButton.alpha = 0
                                self.leftButton.frame.origin.y = self.upperYPosition
                                self.rightButton.frame.origin.y = self.upperYPosition
                                
                                self.viewsToFollowButtons()
                                self.hideViewIfButtonIs()
                },
                               completion: nil
                )
            case .third:
                break
            }
        }
    }

    
    func check() {
        print("Rectangle:")
        print(rectangle.frame.origin.x, rectangle.frame.origin.y)
        print("z.pos: \(rectangle.layer.zPosition), alhpa: \(rectangle.alpha), hidden: \(rectangle.isHidden), enabled: \(rectangle.isEnabled), state: \(rectangle.state)")
        
        print("\nleftButton:")
        print(leftButton.frame.origin.x, leftButton.frame.origin.y)
        print("z.pos: \(leftButton.layer.zPosition), alhpa: \(leftButton.alpha), hidden: \(leftButton.isHidden), enabled: \(leftButton.isEnabled), state: \(leftButton.state)")
        
        print("\nrightButton:")
        print(rightButton.frame.origin.x, rightButton.frame.origin.y)
        print("z.pos: \(rightButton.layer.zPosition), alhpa: \(rightButton.alpha), hidden: \(rightButton.isHidden), enabled: \(rightButton.isEnabled), state: \(rightButton.state)")
        
        print("\ntopLeftButton:")
        print(topLeftButton.frame.origin.x, topLeftButton.frame.origin.y)
        print("z.pos: \(topLeftButton.layer.zPosition), alhpa: \(topLeftButton.alpha), hidden: \(topLeftButton.isHidden), enabled: \(topLeftButton.isEnabled), state: \(topLeftButton.state)")
        
        print("\ntopRightButton:")
        print(topRightButton.frame.origin.x, topRightButton.frame.origin.y)
        print("z.pos: \(topRightButton.layer.zPosition), alhpa: \(topRightButton.alpha), hidden: \(topRightButton.isHidden), enabled: \(topRightButton.isEnabled), state: \(topRightButton.state)")
        
        print("\nrectangleView:")
        print(rectangleView.frame.origin.x, rectangleView.frame.origin.y)
        print("z.pos: \(rectangleView.layer.zPosition), alhpa: \(rectangleView.alpha), hidden: \(rectangleView.isHidden)")
        
        print("\nleftButtonView:")
        print(leftButtonView.frame.origin.x, leftButtonView.frame.origin.y)
        print("z.pos: \(leftButtonView.layer.zPosition), alhpa: \(leftButtonView.alpha), hidden: \(leftButtonView.isHidden)")
        
        print("\nrightButtonView:")
        print(rightButtonView.frame.origin.x, rightButtonView.frame.origin.y)
        print("z.pos: \(rightButtonView.layer.zPosition), alhpa: \(rightButtonView.alpha), hidden: \(rightButtonView.isHidden)")
        
        print("\ntopLeftButtonView:")
        print(topLeftButtonView.frame.origin.x, topLeftButtonView.frame.origin.y)
        print("z.pos: \(topLeftButtonView.layer.zPosition), alhpa: \(topLeftButtonView.alpha), hidden: \(topLeftButtonView.isHidden)")
        
        print("\ntopRightButtonView:")
        print(topRightButtonView.frame.origin.x, topRightButtonView.frame.origin.y)
        print("z.pos: \(topRightButtonView.layer.zPosition), alhpa: \(topRightButtonView.alpha), hidden: \(topRightButtonView.isHidden)")
    }
}




class ButtonStyle {
    var color: UIColor
    var font: UIFont
    var text: String
    var textColor: UIColor
    
    init(color: UIColor, font: UIFont, text: String, textColor: UIColor) {
        self.color = color
        self.font = font
        self.text = text
        self.textColor = textColor
    }
    
    convenience init() {
        self.init(color: UIColor(), font: UIFont(), text: "", textColor: UIColor())
    }
}


