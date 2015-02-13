//
//  LRNAudioRecorder.swift
//  Browser
//
//  Created by Jack Vo on 13/02/2015.
//  Copyright (c) 2015 Karol Tarasiuk. All rights reserved.
//

import UIKit
import AVFoundation
class LRNAudioRecorder: UIView {
    
    // Non-UI Component
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        //setup audio session
        var session: AVAudioSession? = AVAudioSession.sharedInstance()
        session?.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil);
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
