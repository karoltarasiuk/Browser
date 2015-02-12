//
//  StretchableUITextField.swift
//  Browser
//
//  Created by Jack Vo on 13/02/2015.
//  Copyright (c) 2015 Karol Tarasiuk. All rights reserved.
//

import UIKit

class StretchableUITextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func sizeThatFits(size: CGSize) -> CGSize {
        return size;
    }
}
