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
    
    func characterIndexAtPoint(var point:CGPoint) ->CFIndex?{
        
        guard CGRectContainsPoint(self.textRect, point) else{
            return nil
        }
        let optimizedAttributedText = self.attributedText?.mutableCopy()
        
        optimizedAttributedText?.enumerateAttribute(kCTParagraphStyleAttributeName as String, inRange: NSMakeRange(0, (optimizedAttributedText?.length)!), options: NSAttributedStringEnumerationOptions.Reverse, usingBlock: { (value, range, stop) -> Void in
            let paragraphStyle:NSMutableParagraphStyle = value!.mutableCopy() as! NSMutableParagraphStyle
            if paragraphStyle.lineBreakMode == NSLineBreakMode.ByTruncatingTail{
                paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            }
            optimizedAttributedText?.removeAttribute(kCTParagraphStyleAttributeName as String, range: range)
            optimizedAttributedText?.addAttribute(kCTParagraphStyleAttributeName as String, value: paragraphStyle, range: range)
        })
        
        if CGRectContainsPoint(self.bounds, point) == false{
            return NSNotFound;
        }
        
        point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y)
        point = CGPointMake(point.x, textRect.size.height - point.y)
        
        let framesetter = CTFramesetterCreateWithAttributedString(optimizedAttributedText as! CFAttributedStringRef)
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, textRect)
        
        let frame:CTFrameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedText!.length), path, nil)
                
        let lines = CTFrameGetLines(frame)
        
        let numberOfLines = self.numberOfLines > 0 ? min(self.numberOfLines, CFArrayGetCount(lines)):CFArrayGetCount(lines)
        if numberOfLines == 0{
            return NSNotFound
        }
        var idx = NSNotFound
        
        var lineOrigins = [CGPoint](count: numberOfLines, repeatedValue: CGPointZero)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), &lineOrigins)
        
        for lineIndex:CFIndex in 0..<numberOfLines{
            let lineOrigin = lineOrigins[lineIndex]
            
            let line:CTLineRef = unsafeBitCast(CFArrayGetValueAtIndex(lines, lineIndex), CTLineRef.self)
            
            var ascent:CGFloat = 0.0
            var descent:CGFloat = 0.0
            var leading:CGFloat = 0.0
            let width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
            
            let yMin = floor(lineOrigin.y - fabs(descent))
            let yMax = ceil(lineOrigin.y + ascent)
            
            if point.y > yMax{
                break
            }
            if point.y >= yMin{
                if point.x >= lineOrigin.x && point.x <= (lineOrigin.x + CGFloat(width)){
                    let relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y)
                    idx = CTLineGetStringIndexForPosition(line, relativePoint)
                    self.delegate?.SSWCurrentSelectedLineAscent_CTCoordinate?(yMax)
                    self.delegate?.SSWCurrentSelectedLineDescent_CTCoordinate?(yMin)
                    self.delegate?.SSWCurrentSelectedLineAscent_iOSCoordinate?(max(textRect.height - yMax, 0))
                    self.delegate?.SSWCurrentSelectedLineDescent_iOSCoordinate?(textRect.height - yMin)
                    break
                }
            }
        }
        return idx
    }
    
    func stringAtPoint(point:CGPoint) ->String?{
        
        guard var cfIndex = characterIndexAtPoint(point) else{
            return nil
        }
        
        print(cfIndex)
        
        cfIndex = Int(cfIndex)
        let textString:NSString = self.text! as NSString;
        
        let stringLength = Int(textString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))

        var endRange = textString.rangeOfString(" ", options: NSStringCompareOptions.RegularExpressionSearch, range: NSMakeRange(cfIndex, stringLength - cfIndex))
        var frontRange = textString.rangeOfString(" ", options: NSStringCompareOptions.BackwardsSearch, range: NSMakeRange(0, cfIndex))
        
        if frontRange.location == NSNotFound{
            frontRange.location = 0
        }
        if endRange.location == NSNotFound{
            endRange.location = stringLength
        }
        
        var wordRange = NSMakeRange(frontRange.location, endRange.location - frontRange.location)
        
        if frontRange.location != 0{
            wordRange.location += 1
            wordRange.length -= 1
        }
        return textString.substringWithRange(wordRange)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let validDel = touchFuncValidDelegate(touches, withEvent: event)
        if validDel == false {
            super.touchesBegan(touches, withEvent: event)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let validDel = touchFuncValidDelegate(touches, withEvent: event)
        if validDel == false {
            super.touchesMoved(touches, withEvent: event)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        let validDel = touchFuncValidDelegate(touches, withEvent: event)
        if validDel == false {
            super.touchesCancelled(touches, withEvent: event)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let validDel = touchFuncValidDelegate(touches, withEvent: event)
        if validDel == false {
            super.touchesEnded(touches, withEvent: event)
        }
    }
    
    func touchFuncValidDelegate(touches: Set<UITouch>?, withEvent event: UIEvent?) -> Bool{
        let litterIndex = self.characterIndexAtPoint(touchPoint(touches, baseView: self))
        let string = self.stringAtPoint(touchPoint(touches, baseView: self))
        if self.delegate != nil{
            if litterIndex != nil{
                self.delegate!.SSWCurrentSelectedLitterIndex?(litterIndex!)
            }
            if string != nil{
                self.delegate!.SSWCurrentSelectedString?(string!)
            }
            return true
        }else{
            return false
        }
    }
}
