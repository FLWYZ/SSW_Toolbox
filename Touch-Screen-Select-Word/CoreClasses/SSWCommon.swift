//
//  SSWCommon.swift
//  Touch-Screen-Select-Word
//
//  Created by Fanglei on 16/3/17.
//  Copyright © 2016年 Fanglei. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SSWCommonProtocol_Label{
    /**
     to get the select string by space
     */
    optional func SSWCurrentSelectString( string:String ) -> Void
    
    /**
     to get the select litter index in the ctline
     */
    optional func SSWCurrentSelectLitterIndex( litterIndex:CFIndex ) -> Void
    
    /**
     to get the select ctline ascent in CT Coordinate (origin point is in bottom left)
     */
    optional func SSWCurrentSelectLineAscent_CTCoordinate(ascent_CT:CGFloat)->Void
    
    /**
     to get the select ctline descent in CT Coordinate (origin point is in bottom left)
     */
    optional func SSWCurrentSelectLineDescent_CTCoordinate(descent_CT:CGFloat)->Void
    
    /**
     to get the select ctline ascent in iOS Coordinate (origin point is in top left)
     */
    optional func SSWCurrentSelectLineAscent_iOSCoordinate(ascent_iOS:CGFloat)->Void
    
    /**
     to get the select ctline descent in iOS Coordinate (origin point is in bottom left)
     */
    optional func SSWCurrentSelectLineDescent_iOSCoordinate(descent_iOS:CGFloat)->Void
    
    optional func SSWCurrentSelectWordRect(wordRect:NSValue,wordCenter:NSValue)->Void
    
    optional func SSWCurrentSelectWordTopCenter(topCenter:NSValue,BottomCenter bottomCenter:NSValue)
}

@objc protocol SSWCommonProtocol_TextView{
    
    optional func SSW_TextView_SelectString(string:String?)->Void
    
    optional func SSW_TextView_SelectLine(line:String?)->Void
    
    optional func SSW_TextView_SelectRect_Line(line_TextView lineRect:NSValue, line_Window lineRect_2:NSValue)->Void
    
    optional func SSW_TextView_SelectRect_Word(word_TextView wordRect:NSValue, word_Window wordRect_2:NSValue)->Void
    
    optional func SSW_TextView_SelectRect(line_TextView lineRect:NSValue, word_TextView wordRect:NSValue, line_Window lineRect_2:NSValue, word_Window wordRect_2:NSValue)->Void
    
    optional func SSW_TextView_SelectCenter(word_TextView wordCenter:NSValue,word_Window wordCenter_2:NSValue)->Void
    
    optional func SSW_TextView_SelectString(string:String? ,line:String? ,line_Window lineRect:NSValue ,word_Window wordRect:NSValue ,word_TextView wordCenter:NSValue ,word_Window wordCenter_2:NSValue)->Void
}

extension CGRect{
    var center:CGPoint{
        get{
            
            print(self)
            print(CGPointMake(CGRectGetMidX(self), CGRectGetMidY(self)))
            
            return CGPointMake(CGRectGetMidX(self), CGRectGetMidY(self))
        }
    }
}

func touchPoint(touches:Set<UITouch>?,baseView:UIView) -> CGPoint{
    if touches != nil{
        let touch = (touches! as NSSet).allObjects.last as! UITouch;
        return touch.locationInView(baseView)
    }
    return CGPointZero
}