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
        lrnRecorder.setupRecorder("testing.m4a")
    }
    
    @IBAction func blurUrlTextField(sender: StretchableUITextField) {
        hideKeyboard()
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        webView.goBack()
        updateUrlText()
    }
    
    @IBAction func goForward(sender: UIBarButtonItem) {
        webView.goForward()
        updateUrlText()
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        hideKeyboard()
        toggleHideKeyboardButton()
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func stopLoading(sender: UIBarButtonItem) {
        webView.stopLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebViewUrl(url:NSString) {
        let nsUrl: NSURL? = NSURL(string: url)
        let request = NSURLRequest(URL: nsUrl!)
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
    
    func generateUrlFromText(urlString: String) -> String {
        let doesNotHaveHttpPrefix = !(urlString.hasPrefix("http://") ||
                                      urlString.hasPrefix("https://"))
        var url = urlString
        if (doesNotHaveHttpPrefix) {
            url = "http://\(urlString)"
        }
        return url
    }
    
    func updateUrlText() {
        let url = webView.request?.URL
        if let urlString = url?.absoluteString {
            if !urlString.isEmpty {
                urlTextField.text = urlString
            }
        }
    }

    // check if url is valid like missing .com ---> append http://google.com/?q=
        
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
        let url = generateUrlFromText(textField.text)
        textField.resignFirstResponder()
        keyboardIsVisible = false
        toggleHideKeyboardButton()
        textField.text = url
        loadWebViewUrl(url)
        return false
    }
    
}

extension ViewController: UIWebViewDelegate {

    func webViewDidStartLoad(webView: UIWebView) {
        updateUrlText()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        updateUrlText()
    }

}
