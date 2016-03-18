//
//  ViewController_Label.swift
//  Touch-Screen-Select-Word
//
//  Created by Fanglei on 16/3/17.
//  Copyright © 2016年 Fanglei. All rights reserved.
//

import UIKit

class ViewController_Label: UIViewController,SSWCommonProtocol {
    
    @IBOutlet weak var sswLabel: SSWLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sswLabel.delegate = self
        
        let baseString = "Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur Lorem ipsum dolor sit amet, consectetur adipisicing elit,  Lorem ipsum dolor sit amet, consectetur"
        let attributeString = NSMutableAttributedString(string: baseString)
        let paragraphstyle = NSMutableParagraphStyle()
        paragraphstyle.lineSpacing = 5
        paragraphstyle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        paragraphstyle.alignment = NSTextAlignment.Right
        attributeString.setAttributes([NSFontAttributeName:UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName:UIColor.blackColor(),
            NSParagraphStyleAttributeName:paragraphstyle
            ], range: NSMakeRange(0, baseString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
        self.sswLabel.attributedText = attributeString
    }
    
    func SSWCurrentSelectedLineAscent_CTCoordinate(ascent_CT: CGFloat) {
        print("CTLine ascent in CT coordinat \(ascent_CT)")
    }
    
    func SSWCurrentSelectedLineDescent_CTCoordinate(descent_CT: CGFloat) {
        print("CTLine descent in CT coordinat \(descent_CT)")
    }
    
    func SSWCurrentSelectedLineAscent_iOSCoordinate(ascent_iOS: CGFloat) {
        print("CTLine ascent in iOS coordinat \(ascent_iOS)")
    }
    
    func SSWCurrentSelectedLineDescent_iOSCoordinate(descent_iOS: CGFloat) {
        print("CTLine descent in iOS coordinat \(descent_iOS)")
    }
    
    func SSWCurrentSelectedString(string: String) {
        print(string)
    }
    
    func SSWCurrentSelectedLitterIndex(litterIndex: CFIndex) {
        print("CTLine select litter index \(litterIndex)")
    }
    
}
