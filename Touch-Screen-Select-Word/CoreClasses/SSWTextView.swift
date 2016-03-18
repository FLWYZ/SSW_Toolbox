//
//  SSWTextView.swift
//  Touch-Screen-Select-Word
//
//  Created by Fanglei on 16/3/17.
//  Copyright © 2016年 Fanglei. All rights reserved.
//

import UIKit

class SSWTextView: UITextView {
    weak var sswDelegate:SSWCommonProtocol_TextView?
    
    init(frame: CGRect, textContainer: NSTextContainer?,sswDelegate:SSWCommonProtocol_TextView) {
        self.sswDelegate = sswDelegate
        super.init(frame: frame, textContainer: textContainer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.editable = false
    }
    
    func optionAtPoint(selectPosition:UITextPosition?){        
        var direction:UITextLayoutDirection
        switch self.textAlignment{
        case .Left:
            direction = .Left
        case .Right:
            direction = .Right
        default:
            direction = .Right
        }
        
        let wordRange = self.tokenizer.rangeEnclosingPosition(selectPosition!, withGranularity: UITextGranularity.Word, inDirection:direction.rawValue)
        
        let lineRange = self.tokenizer.rangeEnclosingPosition(selectPosition!, withGranularity: UITextGranularity.Line, inDirection: direction.rawValue)
        
        var wordRect_TextView_Value:NSValue?, wordRect_Window_Value:NSValue?, lineRect_TextView_Value:NSValue?, lineRect_Window_Value:NSValue?
        
        
        if wordRange != nil{
            sswDelegate?.SSW_TextView_SelectString?(self.textInRange(wordRange!))
            
            wordRect_TextView_Value = NSValue(CGRect:self.firstRectForRange(wordRange!))
            var wordRect_Window = self.firstRectForRange(wordRange!)
            wordRect_Window.origin.y -= self.contentOffset.y
            wordRect_Window.origin.y += CGRectGetMinY(self.frame)
            wordRect_Window.origin.x += CGRectGetMinX(self.frame)
            wordRect_Window_Value = NSValue(CGRect: wordRect_Window)
        }
        if lineRange != nil{
            sswDelegate?.SSW_TextView_SelectLine?(self.textInRange(lineRange!))
            
            lineRect_TextView_Value = NSValue(CGRect:self.firstRectForRange(lineRange!))
            var lineRect_Window = self.firstRectForRange(lineRange!)
            lineRect_Window.origin.y -= self.contentOffset.y
            lineRect_Window.origin.y += CGRectGetMinY(self.frame)
            lineRect_Window.origin.x += CGRectGetMinX(self.frame)
            lineRect_Window_Value = NSValue(CGRect:lineRect_Window)
        }
        
        let wordRectValid = wordRect_TextView_Value != nil && wordRect_Window_Value != nil
        let lineRectValid = lineRect_TextView_Value != nil && lineRect_Window_Value != nil
        
        if wordRectValid == true {
            sswDelegate?.SSW_TextView_SelectRect_Word?(word_TextView: wordRect_TextView_Value!, word_Window: wordRect_Window_Value!)
            sswDelegate?.SSW_TextView_SelectCenter?(word_TextView: NSValue(CGPoint: wordRect_TextView_Value!.CGRectValue().center), word_Window: NSValue(CGPoint: wordRect_Window_Value!.CGRectValue().center))
        }
        if lineRectValid == true{
            sswDelegate?.SSW_TextView_SelectRect_Line?(line_TextView: lineRect_TextView_Value!, line_Window: lineRect_Window_Value!)
        }
        if wordRectValid == true && lineRectValid == true{
            sswDelegate?.SSW_TextView_SelectRect?(line_TextView: lineRect_TextView_Value!, word_TextView: wordRect_TextView_Value!, line_Window: lineRect_Window_Value!, word_Window: wordRect_Window_Value!)
        }
        if  wordRange != nil &&
            lineRange != nil &&
            lineRect_Window_Value != nil &&
            wordRect_Window_Value != nil &&
            lineRect_TextView_Value != nil &&
            lineRect_Window_Value != nil{
            sswDelegate?.SSW_TextView_SelectString?(self.textInRange(wordRange!), line: self.textInRange(lineRange!), line_Window: lineRect_Window_Value!, word_Window: wordRect_Window_Value!, word_TextView:NSValue(CGPoint: wordRect_TextView_Value!.CGRectValue().center) , word_Window: NSValue(CGPoint: wordRect_Window_Value!.CGRectValue().center))
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.touchFuncValidDelegate(touches, withEvent: event) == false{
            super.touchesBegan(touches, withEvent: event)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.touchFuncValidDelegate(touches, withEvent: event) == false{
            super.touchesMoved(touches, withEvent: event)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if self.touchFuncValidDelegate(touches, withEvent: event){
            super.touchesCancelled(touches, withEvent: event)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.touchFuncValidDelegate(touches, withEvent: event){
            super.touchesEnded(touches, withEvent: event)
        }
    }
    
    func touchFuncValidDelegate(touches: Set<UITouch>?, withEvent event: UIEvent?) -> Bool{
        
        guard self.sswDelegate != nil else{
            return false
        }
        self.optionAtPoint(self.closestPositionToPoint(touchPoint(touches, baseView: self)))
        return true
    }
}
