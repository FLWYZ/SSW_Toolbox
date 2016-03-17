//
//  SSWLabel.swift
//  Touch-Screen-Select-Word
//
//  Created by Fanglei on 16/3/17.
//  Copyright © 2016年 Fanglei. All rights reserved.
//

import UIKit

class SSWLabel: UILabel {
    weak var delegate:SSWCommonProtocol?
    var textRect:CGRect{
        get{
            var rect = self.textRectForBounds(self.bounds, limitedToNumberOfLines: self.numberOfLines)
            rect.origin.y = (self.bounds.size.height - rect.size.height) / 2.0
            if self.textAlignment == NSTextAlignment.Center{
                rect.origin.x = (self.bounds.size.width - rect.size.width) / 2.0
            }
            if self.textAlignment == NSTextAlignment.Right{
                rect.origin.x = (self.bounds.size.width - rect.size.width)
            }
            return rect
        }
    }
    
    init(frame: CGRect,delegate:SSWCommonProtocol) {
        self.delegate = delegate
        super.init(frame: frame)
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    func characterIndexAtPoint(point:CGPoint) ->CFIndex{
        return 1
    }
    
    func stringAtPoint(point:CGPoint) ->String{
        return ""
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = (touches as NSSet).allObjects.last as! UITouch
        let litterIndex:CFIndex = self.characterIndexAtPoint(touch.locationInView(self))
        let string = self.stringAtPoint(touch.locationInView(self))
        self.delegate?.SSWCurrentSelectedStringIndex(litterIndex)
        self.delegate?.SSWCurrentSelectedString(string)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    
    
}
