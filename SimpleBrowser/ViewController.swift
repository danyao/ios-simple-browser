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
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let url = URL(string: "https://www.wikipedia.org")!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

