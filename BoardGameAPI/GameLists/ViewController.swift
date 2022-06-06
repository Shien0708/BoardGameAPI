//
//  ViewController.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/2.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var webUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let webUrl = webUrl {
            webView.load(URLRequest(url: webUrl))
            print("has url")
        }
    }
}

