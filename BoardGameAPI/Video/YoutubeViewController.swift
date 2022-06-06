//
//  YoutubeViewController.swift
//  BoardGameAPI
//
//  Created by Shien on 2022/6/2.
//

import UIKit
import WebKit

class YoutubeViewController: UIViewController {
    var url: URL?
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            webView.load(URLRequest(url: url))
        }
        
    }

}
