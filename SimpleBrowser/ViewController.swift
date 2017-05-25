//
//  ViewController.swift
//  SimpleBrowser
//
//  Created by Danyao Wang on 5/25/17.
//  Copyright © 2017 Danyao Wang. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

  var webView: WKWebView!
  
  @IBOutlet weak var containerView: UIView!
  
  required init(coder aDecoder: NSCoder) {
    self.webView = WKWebView(frame: CGRect.zero)
    super.init(coder: aDecoder)!
  }
  
  @IBAction func textPrimaryActionTriggered(_ sender: UITextField) {
    print("Primary action triggered \(sender.text!)")
    let url = URL(string: sender.text!)!
    webView.load(URLRequest(url: url))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.webView.navigationDelegate = self
    containerView.addSubview(webView)
    
    webView.translatesAutoresizingMaskIntoConstraints = false
    
    let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1, constant: 0)
    let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 1, constant: 0)
    view.addConstraints([height, width])
    
    let url = URL(string: "https://www.wikipedia.org")!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
    title = webView.title
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("Started provisional navigation for \(webView.url!)")
  }
  
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    print("Commited navigation to \(webView.url!)")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
