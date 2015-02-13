//
//  ViewController.swift
//  Browser
//
//  Created by Karol Tarasiuk on 13/02/2015.
//  Copyright (c) 2015 Karol Tarasiuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var urlTextField: StretchableUITextField!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var lrnRecorder: LRNAudioRecorder!

    
    override func viewDidLoad() {
        
        lrnRecorder.initialize()
        
        super.viewDidLoad()
    }

    @IBAction func testRecord(sender: AnyObject) {
        lrnRecorder.setupRecorder("testing.mp3")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadWebViewUrl(url:NSString) {
        var nsUrl: NSURL? = NSURL(string: url)
        var request = NSURLRequest(URL: nsUrl!)
        self.webView.loadRequest(request)
    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        //select the entire text
//        return false
//    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loadWebViewUrl(textField.text)
        return false
    }
    
    func isValidProtocol(urlString: String) -> Bool {
        return false
    }
    
    // add go back function
    
    // add go next function
    
    // add stop function
    
    // add reload function
    
    // auto handle http protocol
    
    // check if url is valid like missing .com ---> append http://google.com/?q=
    
    // select entire url string when focus
    
    // listen to web view change event to reflect change
    
    // TODO
    // Import the Javascript library bridge 
    // Send message to record - playback to the page <---> this app
    // Build Record View Controller
    // Build Playback View Controller
    
}

