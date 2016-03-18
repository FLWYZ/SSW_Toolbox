//
//  ViewController_TextView.swift
//  Touch-Screen-Select-Word
//
//  Created by Fanglei on 16/3/17.
//  Copyright © 2016年 Fanglei. All rights reserved.
//

import UIKit

class ViewController_TextView: UIViewController,SSWCommonProtocol_TextView {
    
    @IBOutlet weak var sswTextView: SSWTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseString = "Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur"
        let attributeString = NSMutableAttributedString(string: baseString)
        let paragraphstyle = NSMutableParagraphStyle()
        paragraphstyle.lineSpacing = 5
        paragraphstyle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        paragraphstyle.alignment = NSTextAlignment.Right
        attributeString.setAttributes([NSFontAttributeName:UIFont.systemFontOfSize(25),
            NSForegroundColorAttributeName:UIColor.blackColor(),
            NSParagraphStyleAttributeName:paragraphstyle
            ], range: NSMakeRange(0, baseString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
        self.sswTextView.attributedText = attributeString
        self.sswTextView.sswDelegate = self
    }
    
    func SSW_TextView_SelectString(string: String?) {
        print(string!)
    }
    
    func SSW_TextView_SelectCenter(word_TextView wordCenter: NSValue, word_Window wordCenter_2: NSValue) {
        print("center 1 == \(wordCenter), center 2 == \(wordCenter_2)")
    }
    
    
}
