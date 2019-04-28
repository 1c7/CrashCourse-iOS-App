//
//  WebViewController.swift
//
//  Created by @糖醋陈皮 on 2019/4/22.
//  Copyright © 2019 1c7. All rights reserved.
//

import UIKit
import WebKit

// 详情页
class WebViewController: UIViewController {

    @IBOutlet weak var cc_webview: WKWebView!
    var webview_link: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        setTopRightItem()
        self.navigationController!.navigationBar.isHidden = false
    }
    
    // 设置网址
    func setWebView(){
        if let link = webview_link {
            let url = URL(string: link)
            cc_webview.load(URLRequest(url: url!))
        }
    }
    
    // 设置右上角按钮
    func setTopRightItem(){
        if let _ = webview_link {
            let bar = UIBarButtonItem(title: "浏览器打开", style: .done, target: self, action: #selector(openURLOutside))
            self.navigationItem.rightBarButtonItem = bar
        }
    }
    
    // "浏览器打开"
    @objc func openURLOutside(){
        print(webview_link!)
        guard let url = URL(string: webview_link!), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
