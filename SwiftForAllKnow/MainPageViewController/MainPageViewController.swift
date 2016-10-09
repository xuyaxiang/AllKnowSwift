//
//  MainPageViewController.swift
//  SwiftAllKnow
//
//  Created by enghou on 16/9/29.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import UIKit

class MainPageViewController: RootViewController,helpTurn {

    var table : MainTableView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MainPageViewController.feedTableViewData), name: NSNotification.Name("loadMainPageData"), object: nil)
        table = MainTableView.init(frame: CGRect.init(x: zero, y: zero-20, width: kScreenWid, height: kScreenHeigh+20))
        self.view.addSubview(table!)
        table?.setDelegate(dele: self)
    }
    
    
    func feedTableViewData()->Void{
        NetWorkTool.sharedInstance().getBannerInfo(param: nil, success: { (source) in
            let array = source["results"]?["result"] as! Array<Dictionary<String,String>>
            var imageSource : Array<CollectionCellModel> = Array.init()
            for dict in array{
                let model = CollectionCellModel.init()
                model.name = dict["name"]!
                model.pic = dict["pic"]!
                model.url = dict["url"]!
                imageSource.append(model)
            }
            self.table!.feedImageSource(imgSource: imageSource)
            }) { (errorCode) in
        }
        NetWorkTool.sharedInstance().getAdvertorialInfo(param: [PAGE_NUM:"1",PAGE_SIZE:"10"], success: { (src) in
            let result = (src["results"] as! Dictionary<String,AnyObject>?)!["result"] as! Array<Dictionary<String,String>>?
            var feedData : Array<MainCellModel> = Array.init()
            for dict in result!{
                let mainModel = MainCellModel.init()
                mainModel.dateStr = dict["pushTime"]!
                mainModel.origin = dict["origin"]!
                mainModel.title = dict["title"]!
                mainModel.imageURL = dict["pic"]!;
                mainModel.isToShare = dict["isToShare"]!
                mainModel.shareMode = dict["shareMode"]!
                mainModel.conditionId = dict["id"]!
                feedData.append(mainModel)
            }
            self.table!.feedDataSource(dataSource: feedData)
            }) { (code) in
                
        }
    }
    
    func turn(viewCtl : RootViewController) {
        viewCtl.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewCtl, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
