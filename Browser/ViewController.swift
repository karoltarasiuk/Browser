//
//  ViewController.swift
//  Browser
//
//  Created by Karol Tarasiuk on 13/02/2015.
//  Copyright (c) 2015 Karol Tarasiuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var keyboardIsVisible = false
    
    @IBOutlet weak var urlTextField: StretchableUITextField!
    @IBOutlet weak var hideKeyboardButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lrnRecorder: LRNAudioRecorder!

    
    override func viewDidLoad() {
        hideKeyboardButton.hidden = true
        lrnRecorder.initialize()
        super.viewDidLoad()
    }

    @IBAction func testRecord(sender: AnyObject) {
        lrnRecorder.setupRecorder("testing.mp3")
    }
    
    @IBAction func blurUrlTextField(sender: StretchableUITextField) {
        hideKeyboard()
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        hideKeyboard()
        toggleHideKeyboardButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebViewUrl(url:NSString) {
        var nsUrl: NSURL? = NSURL(string: url)
        var request = NSURLRequest(URL: nsUrl!)
        webView.loadRequest(request)
    }
    
    func hideKeyboard() {
        urlTextField.resignFirstResponder()
        keyboardIsVisible = false
        toggleHideKeyboardButton()
    }
    
    func toggleHideKeyboardButton() {
        hideKeyboardButton.hidden = !keyboardIsVisible
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

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let start = textField.beginningOfDocument
        let end = textField.endOfDocument
        textField.selectedTextRange = textField.textRangeFromPosition(start, toPosition: end)
        keyboardIsVisible = true
        toggleHideKeyboardButton()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loadWebViewUrl(textField.text)
        return false
    }
    
}
