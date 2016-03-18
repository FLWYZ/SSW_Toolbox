//
//  SSWLabel.swift
//  Touch-Screen-Select-Word
//
//  Created by Fanglei on 16/3/17.
//  Copyright © 2016年 Fanglei. All rights reserved.
//

import UIKit

class SSWLabel: UILabel {
    weak var delegate:SSWCommonProtocol_Label?
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
    
    init(frame: CGRect,delegate:SSWCommonProtocol_Label) {
        self.delegate = delegate
        super.init(frame: frame)
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    func characterIndexAtPoint(var point:CGPoint) -> (CFIndex,CTLineRef,CGFloat,CGPoint)?{
        
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
            return nil
        }
        
        point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y)
        point = CGPointMake(point.x, textRect.size.height - point.y)
        
        let framesetter = CTFramesetterCreateWithAttributedString(optimizedAttributedText as! CFAttributedStringRef)
        let path = CGPathCreateMutable()
        var rectForCal = textRect
        rectForCal.size.height = 2000
        CGPathAddRect(path, nil, rectForCal)
        
        let frame:CTFrameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedText!.length), path, nil)
                
        let lines = CTFrameGetLines(frame)
        
        let numberOfLines = self.numberOfLines > 0 ? min(self.numberOfLines, CFArrayGetCount(lines)):CFArrayGetCount(lines)
        if numberOfLines == 0{
            return nil
        }
        var idx = NSNotFound
        var idxInLine:CTLineRef = unsafeBitCast(CFArrayGetValueAtIndex(lines, 0), CTLineRef.self)
        var idxLineHeight:CGFloat = 0.0
        var idxLineOriginPoint:CGPoint = CGPointMake(0, 0)
        
        var lineOrigins = [CGPoint](count: numberOfLines, repeatedValue: CGPointZero)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), &lineOrigins)

        //get the last line
        let lastLine:CTLineRef = unsafeBitCast(CFArrayGetValueAtIndex(lines, numberOfLines - 1), CTLineRef.self)
        var lastLineDescent:CGFloat = 0.0
        CTLineGetTypographicBounds(lastLine,nil,&lastLineDescent,nil)
        
        let heightRate = floor(lineOrigins[numberOfLines - 1].y + floor(lastLineDescent))
        print(floor(lastLineDescent))
        
        for lineIndex:CFIndex in 0..<numberOfLines{
            var lineOrigin = lineOrigins[lineIndex]
            lineOrigin.y -= heightRate
            
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
                    idxInLine = line
                    idxLineHeight = yMax - yMin
                    
                    idxLineHeight = textRect.size.height - yMax
                    
                    idxLineOriginPoint = CGPointMake(lineOrigin.x, textRect.size.height - yMax + textRect.origin.y)
                    
                    self.delegate?.SSWCurrentSelectLineAscent_CTCoordinate?(yMax)
                    self.delegate?.SSWCurrentSelectLineDescent_CTCoordinate?(yMin)
                    self.delegate?.SSWCurrentSelectLineAscent_iOSCoordinate?(max(textRect.height - yMax, 0))
                    self.delegate?.SSWCurrentSelectLineDescent_iOSCoordinate?(textRect.height - yMin)
                    break
                }
            }
        }
        guard idx != NSNotFound else {
            return nil
        }
        return (idx,idxInLine,idxLineHeight,idxLineOriginPoint) 
    }
    
    func string_stringRectAtPoint(point:CGPoint) -> (String,CGRect)?{
        
        guard let (cfIndex0,cfLine,cfLineHeight,cfLineOrigin) = characterIndexAtPoint(point) else{
            return nil
        }
        
        let cfIndex = Int(cfIndex0)
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
        
        let startOffset = CTLineGetOffsetForStringIndex(cfLine, frontRange.location + 1 , nil)
        let endOffset = CTLineGetOffsetForStringIndex(cfLine, endRange.location , nil)
        let stringRect = CGRectMake( CGRectGetMinX(self.frame) + cfLineOrigin.x + startOffset , CGRectGetMinY(self.frame) + cfLineOrigin.y , endOffset - startOffset, cfLineHeight)
        
        var wordRange = NSMakeRange(frontRange.location, endRange.location - frontRange.location)
        
        if frontRange.location != 0{
            wordRange.location += 1
            wordRange.length -= 1
        }
        return (textString.substringWithRange(wordRange),stringRect)
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
        let litterIndexLine = self.characterIndexAtPoint(touchPoint(touches, baseView: self))
        let string = self.string_stringRectAtPoint(touchPoint(touches, baseView: self))?.0
        let stringRect = self.string_stringRectAtPoint(touchPoint(touches, baseView: self))?.1
        if self.delegate != nil{
            if litterIndexLine != nil{
                self.delegate!.SSWCurrentSelectLitterIndex?(litterIndexLine!.0)
            }
            if string != nil{
                self.delegate!.SSWCurrentSelectString?(string!)
            }
            if stringRect != nil{
                delegate?.SSWCurrentSelectWordRect?(NSValue(CGRect: stringRect!), wordCenter: NSValue(CGPoint: stringRect!.center))
                let topCenter = CGPointMake(stringRect!.center.x, CGRectGetMinY(stringRect!))
                
                let bottomCenter = CGPointMake(stringRect!.center.x, CGRectGetMaxY(stringRect!))
                delegate?.SSWCurrentSelectWordTopCenter?(NSValue(CGPoint: topCenter), BottomCenter: NSValue(CGPoint: bottomCenter))
            }
            return true
        }else{
            return false
        }
    }
}
