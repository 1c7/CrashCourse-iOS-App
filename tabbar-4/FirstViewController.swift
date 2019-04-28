//
//  FirstViewController.swift
//
//  Created by @糖醋陈皮 on 2019/4/22.
//  Copyright © 2019 1c7. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import Kingfisher

// 系列
class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var items: [JSON] = []
    var selected_serie_number: Int? = nil
    var selected_serie_title: String? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        selected_serie_number = item["id"].int
        selected_serie_title = item["title"].string
        performSegue(withIdentifier: "toSerieDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSerieDetail" {
            if let viewController = segue.destination as? SecondViewController {
                    viewController.serie_number = selected_serie_number
                    viewController.page_title = selected_serie_title
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! SerieCollectionViewCell
        let item = items[indexPath.row]
        
        cell.name.text = item["title"].string
        cell.englishName.text = item["english_name"].string
        cell.desc.text = item["subtitle"].string
        
        // 设置图片
        let urlString = item["image"].string!.replacingOccurrences(of: "http://", with: "https://")
        let url = URL(string: urlString)
        cell.backgroundImage.kf.setImage(with: url)
        
        cell.layer.borderWidth = 1
        cell.layer.masksToBounds = true
        let borderColor: UIColor =  UIColor(red: 64.0, green: 67.0, blue: 70.0, alpha: 1.0)
        cell.layer.borderColor = borderColor.cgColor
        
        return cell
    }
    
    // 2 column
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width) / 2
        return CGSize(width: width, height: width-20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置返回按钮用"返回"中文，而不是英文"Back"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
        
        Alamofire.request(API.serie).responseJSON { response in
            if let data = response.data{
                if let json = try? JSON(data: data) {
                    if let data = json.arrayValue as [JSON]?{
                        self.items = data
                        self.collectionView.reloadData()
                    }
                }

            }
        }
    }
        

}
