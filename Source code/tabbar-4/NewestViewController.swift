//
//  SecondViewController.swift
//  tabbar-4
//
//  Created by remote_edit on 2019/4/22.
//  Copyright © 2019 1c7. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

// 最新 / 系列详情页
class NewestViewController: UITableViewController{
    
    @IBOutlet var cc_tableView: UITableView!
    var video_link: String? = nil // 跳转到视频详情页，显示网页时需要的链接
    var serie_number: Int? = nil // 用于显示系列详情页列表
    var page_title: String? = nil // 页面标题
    var current_page: Int = 0 // 第几页
    
    var items: [JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        cc_tableView.tableFooterView = UIView()
        // 这个页面在最新和系列详情页都用到了
        if let serie_number = serie_number {
            loadSerie(serie_number)
        } else {
            loadNewest()
        }
        
        setBackButton()
    }
    
    // 设置返回按钮用"返回"中文，而不是英文"Back"
    func setBackButton(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
    }
    
    // 有标题就设置标题
    func setTitle(){
        if let title = page_title {
            self.title = title
            self.navigationController!.navigationBar.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.isHidden = true
        setTitle()
    }
    
    // 载入1个系列
    func loadSerie(_ serie_number: Int){
        let url = API.single_serie + String(serie_number)
        Alamofire.request(url).responseJSON { response in
            if let data = response.data{
                if let json = try? JSON(data: data) {
                    if let data = json.arrayValue as [JSON]?{
                        self.items = data
                        self.cc_tableView.reloadData()
                    }
                }
                
            }
        }
    }
    
    // 载入"最新"
    func loadNewest(){
        let url = API.newest + "?page=\(current_page)"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                if let json = try? JSON(data: data) {
                    if let data = json.arrayValue as [JSON]?{
                        self.items = self.items + data
                        self.cc_tableView.reloadData()
                        self.current_page = self.current_page + 1
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        video_link = items[indexPath.row]["video_link"].string
        performSegue(withIdentifier: "toWatchSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWatchSegue" {
            if let viewController = segue.destination as? WebViewController {
                if let link = video_link {
                    viewController.webview_link = link
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = items.count - 1
        if indexPath.row == lastElement {
            print("载入下一页")
            loadNewest()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! NewestTableViewCell
        let item = items[indexPath.row]
        cell.episodeNumber.text = "第\(item["number"].int!)集"
        cell.title.text = item["title"].string
        cell.serieName.text = item["serie_title"].string
        // 设置图片
        let urlString = item["image"].string!.replacingOccurrences(of: "http://", with: "https://")
        let url = URL(string: urlString)
        cell.cc_image.kf.setImage(with: url)
        return cell
    }
    
    // 高 112
    // 这样左侧的图片比例是对的
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112.0
    }

}
