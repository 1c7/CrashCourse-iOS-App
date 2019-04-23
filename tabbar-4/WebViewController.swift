//
//  WebViewController.swift
//  tabbar-4
//
//  Created by remote_edit on 2019/4/23.
//  Copyright © 2019 1c7. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var cc_webview: WKWebView!
    var webview_link: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let link = webview_link {
            let url = URL(string: link)
            cc_webview.load(URLRequest(url: url!))
        }
    }
}
