//
//  SSWCommon.swift
//  Touch-Screen-Select-Word
//
//  Created by Fanglei on 16/3/17.
//  Copyright © 2016年 Fanglei. All rights reserved.
//

import Foundation
@objc protocol SSWCommonProtocol{
    func SSWCurrentSelectedString( string:String ) -> Void
    func SSWCurrentSelectedStringIndex( litterIndex:CFIndex ) -> Void
}

func isValidSelectWord(delegate:AnyObject?,methodName:String?)->Bool{
    guard methodName?.isEmpty == false else{
        return false
    }
    
    return delegate != nil && delegate?.conformsToProtocol(SSWCommonProtocol) == true && delegate?.respondsToSelector(Selector(methodName!)) == true
}