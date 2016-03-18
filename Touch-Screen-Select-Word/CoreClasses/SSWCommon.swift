//
//  SSWCommon.swift
//  Touch-Screen-Select-Word
//
//  Created by Fanglei on 16/3/17.
//  Copyright © 2016年 Fanglei. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SSWCommonProtocol{
    /**
     to get the select string by space
     */
    optional func SSWCurrentSelectedString( string:String ) -> Void
    
    /**
     to get the select litter index in the ctline
     */
    optional func SSWCurrentSelectedLitterIndex( litterIndex:CFIndex ) -> Void
    
    /**
     to get the select ctline ascent in CT Coordinate (origin point is in bottom left)
     */
    optional func SSWCurrentSelectedLineAscent_CTCoordinate(ascent_CT:CGFloat)->Void
    
    /**
     to get the select ctline descent in CT Coordinate (origin point is in bottom left)
     */
    optional func SSWCurrentSelectedLineDescent_CTCoordinate(descent_CT:CGFloat)->Void
    
    /**
     to get the select ctline ascent in iOS Coordinate (origin point is in top left)
     */
    optional func SSWCurrentSelectedLineAscent_iOSCoordinate(ascent_iOS:CGFloat)->Void
    
    /**
     to get the select ctline descent in iOS Coordinate (origin point is in bottom left)
     */
    optional func SSWCurrentSelectedLineDescent_iOSCoordinate(descent_iOS:CGFloat)->Void
}

func touchPoint(touches:Set<UITouch>?,baseView:UIView) -> CGPoint{
    if touches != nil{
        let touch = (touches! as NSSet).allObjects.last as! UITouch;
        return touch.locationInView(baseView)
    }
    return CGPointZero
}