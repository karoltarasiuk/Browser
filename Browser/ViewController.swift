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
    var jsBridge:WebViewJavascriptBridge?
    var _responseCallback:WVJBResponseCallback?
    
    @IBOutlet weak var urlTextField: StretchableUITextField!
    @IBOutlet weak var hideKeyboardButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lrnRecorder: LRNAudioRecorder!

    @IBAction func closeAudio(sender: AnyObject) {
        showRecorder(false)
        jsBridge?.send("webview has loaded")
        if let callback = self._responseCallback {
            callback("Has recorded: \(self.lrnRecorder.currentFileName)")
        }
    }
    
    override func viewDidLoad() {
        showRecorder(true);
        lrnRecorder.hidden = true
        hideKeyboardButton.hidden = true
        lrnRecorder.initialize()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        setupJSBridge()
        self.loadWebViewUrl(self.urlTextField.text)
        return super.viewDidAppear(animated)
    }
    
    func showRecorder(value:Bool) {
        if value {
            var format = NSDateFormatter()
            format.dateFormat="yyyy-MM-dd-HH-mm-ss"
            var fileName = "recording-\(format.stringFromDate(NSDate())).m4a"
            lrnRecorder.setupRecorder(fileName)
        } else {
            lrnRecorder.destroy()

        }
        lrnRecorder.hidden = !value;
    }
    
    func setupJSBridge(){
        WebViewJavascriptBridge.enableLogging();
        jsBridge = WebViewJavascriptBridge(forWebView: self.webView!, webViewDelegate: self, handler: { (data, responseCallback) -> Void in
            self._responseCallback = responseCallback
            println("------------------")
            println(data)
            self.showRecorder(true)
            println("------------------")
        })
        
        
        jsBridge?.callHandler("testJavascriptHandler", data: ["status":"browser app is ready"])
        jsBridge?.send("webview has loaded")
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
