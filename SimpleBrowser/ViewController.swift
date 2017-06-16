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
  var index: size_t
  var lastAboutUrl: URL?
  
  enum AboutMeState {
    case START
    case LOAD_BLANK(URL)
    case FROM_BLANK(URL)
    case LOAD_CONTENT
  }
  var aboutMeState: AboutMeState
  
  @IBOutlet weak var containerView: UIView!
  
  required init(coder aDecoder: NSCoder) {
    self.webView = WKWebView(frame: CGRect.zero)
    index = 0
    aboutMeState = AboutMeState.START
    super.init(coder: aDecoder)!
  }
  
  @IBAction func textPrimaryActionTriggered(_ sender: UITextField) {
    let text = sender.text!
    print("Primary action triggered \(text)")
    
    if (text == "html") {
      webView.loadHTMLString("<html><body>Hello World!</body></html>", baseURL: URL(string:"https://danyao.github.io/test"))
      print("Text entered. \(debugWV(webView))")
    } else if (text == "reload") {
      webView.reload()
    } else {
      let url = URL(string: sender.text!)!
      webView.load(URLRequest(url: url))
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.webView.navigationDelegate = self
    containerView.addSubview(webView)
    
    webView.translatesAutoresizingMaskIntoConstraints = false
    
    let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1, constant: 0)
    let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 1, constant: 0)
    view.addConstraints([height, width])
    
    let url = URL(string: "https://google.com")!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
    title = webView.title
    print("Finished navigation. \(debugWV(webView)) nav: \(navigation)")
    
    switch (aboutMeState) {
    case .LOAD_BLANK(let url):
      aboutMeState = .FROM_BLANK(url)
      webView.load(URLRequest(url: url))
    default:
      return
    }
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("Started provisional navigation. \(debugWV(webView)) nav: \(navigation)")
    
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let url = navigationAction.request.url!.absoluteString
    
    print("Deciding policy. action: \(url) -- \(debugWV(webView))")
    
    if (url == "about:me") {
      switch (aboutMeState) {
      case .START:
        aboutMeState = .LOAD_BLANK(navigationAction.request.url!)
        decisionHandler(WKNavigationActionPolicy.cancel)
        webView.load(URLRequest(url: URL(string:"about:blank")!))
      case .FROM_BLANK:
        aboutMeState = .LOAD_CONTENT
        decisionHandler(WKNavigationActionPolicy.cancel)
        webView.loadHTMLString("<html><body><h1>about:me</h1></body></html>", baseURL: URL(string:"about:me")!)
      case .LOAD_CONTENT:
        decisionHandler(WKNavigationActionPolicy.allow)
        aboutMeState = .START
      default:
        decisionHandler(WKNavigationActionPolicy.allow)
      }
    }
    
    decisionHandler(WKNavigationActionPolicy.allow)
  }
  
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    print("Commited navigation. \(debugWV(webView)) nav: \(navigation)")
  }
  
  func debugWV(_ webView: WKWebView) -> String {
    index += 1
    var current_url = "nil"
    var initial_url = "nil"
    if let current = webView.backForwardList.currentItem {
      current_url = current.url.absoluteString
      initial_url = current.url.absoluteString
    }
    
    return "[\(index) \(aboutMeState) URL=\(webView.url!) current=(\(current_url) |\(initial_url)) backList=[\(webView.backForwardList.backList.count)]"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
