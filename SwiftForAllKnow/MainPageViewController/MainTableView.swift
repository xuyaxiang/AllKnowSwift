//
//  MainTableView.swift
//  SwiftAllKnow
//
//  Created by enghou on 16/9/29.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import UIKit
protocol helpTurn  {
    func turn(viewCtl : RootViewController) -> Void
}

class MainTableView: UIView , UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    public var dtSource : Array<MainCellModel> = []
    
    public var imageSource : Array<CollectionCellModel> = []
    
    private var tableView : UITableView = UITableView.init()
    
    private var headerView : HeaderView? = nil
    
    private var delegate : helpTurn? = nil
    override init(frame : CGRect){
        super.init(frame: frame)
         NotificationCenter.default.addObserver(self, selector: #selector(self.refreshOne(not:)), name: NSNotification.Name("refreshOne"), object: nil)
        tableView = UITableView.init(frame: self.bounds, style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MainCell.classForCoder(), forCellReuseIdentifier: "MainCell")
        tableView.tableFooterView = UIView.init()
        headerView = HeaderView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kScreenWid, height: 200))
        tableView.tableHeaderView = headerView
        self.addSubview(tableView)
    }
    func refreshOne(not : Notification) -> Void {
        let target = not.object as! Int
        let dt = dtSource[target]
        dt.isToShare = "3"
        dtSource[target] = dt
        let idx = IndexPath.init(row: target, section: 0)
        tableView.reloadRows(at: [idx], with: UITableViewRowAnimation.none)
    }
    func setDelegate(dele : helpTurn) -> Void {
        self.delegate = dele
        self.headerView?.delegate = dele
    }
    
    func feedImageSource(imgSource : Array<CollectionCellModel>?)->Void{
        guard imgSource != nil else {
            return
        }
        imageSource = imgSource!
        headerView!.feedData(dtSource: imageSource)
    }
    
    func feedDataSource(dataSource : Array<MainCellModel>?) -> Void {
        guard dataSource != nil else {
            return
        }
        dtSource =  dataSource!
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //-MARK tableView代理方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dtSource[indexPath.row]
        model.changed = true
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        let target = dtSource[indexPath.row]
        let conditionId = target.conditionId
        let param = ["conditionId":conditionId]
        NetWorkTool.sharedInstance().getAdvertorialDetail(param: param, success: { (src) in
            if src["status"] as! String == "success"{
                let result = src["results"]! as! Dictionary<String,Any>
                let url = result["savepath"] as! String
                let articleCtl = ArticleViewController.init()
                articleCtl.articleUrl = url
                print(result)
                articleCtl.title = "知道详情"
                let shareMode = result["shareMode"] as! String
                let isToShare = result["isToShare"] as! String
                let savePath = result["savepath"] as! String
                let count = result["amount"] as! CGFloat
                let aID = result["id"] as! String
                let des = result["description"] as! String
                let pic = result["pic"] as! String
                let title = result["title"] as! String
                let info = ArticleInfo.init(shareMode : shareMode,isToShare : isToShare,savePath: savePath,amount: count,aId: aID,description: des,picUrl:pic,title:title)
                articleCtl.info = info
                articleCtl.index = indexPath.row
                self.delegate?.turn(viewCtl: articleCtl)
            }
            }) { (errorCode) in
                
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let mainCell : MainCell = cell as! MainCell
        mainCell.feedData(source: dtSource[indexPath.row])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dtSource.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    //mark-scrolldelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.y < (-scrollView.contentSize.height + kScreenHeigh-offSetY)){
            //加载新数据
        }
        if(scrollView.contentOffset.y > offSetY) {
            //刷新数据
        }
    }
}


class MainCellModel {
    public var imageURL : String = ""
    public var title : String = ""
    public var origin : String = ""
    public var dateStr : String = ""
    public var state : String = ""
    public var isToShare : String = ""
    public var shareMode : String = ""
    public var conditionId : String = ""
    public var changed : Bool = false
    init() {
        
    }
}

class MainCell: UITableViewCell {
    private var TitleImageView : UIImageView = UIImageView.init()
    private var TitleLabel : UILabel = UILabel.init()
    private var OriginLabel : UILabel = UILabel.init()
    private var TimeLabel : UILabel = UILabel.init()
    private var StateImageView : UIImageView = UIImageView.init()
    let ImageSpaceToBorder = 10
    let TitleToImage = 10
    let ImageWid = 100
    let ImageHei = 56
    let RightMarginToBorder = 5
    let TitleHeigh =  40
    let OriginHei = 10.0
    let ZJFWid : CGFloat = 50
    let ZJFHeigh : CGFloat = 15
    private var Data : MainCellModel? = nil
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWid, height: 75)
        TitleImageView = UIImageView.init(frame: CGRect.init(x: ImageSpaceToBorder, y: ImageSpaceToBorder, width: ImageWid, height: ImageHei))
        TitleImageView.contentMode = UIViewContentMode.scaleToFill
        self.contentView.addSubview(TitleImageView)
        TitleLabel = UILabel.init(frame: CGRect.init(x: Int(TitleImageView.frame.origin.x+TitleImageView.frame.size.width)+TitleToImage, y: ImageSpaceToBorder, width:Int(kScreenWid)-2*ImageSpaceToBorder-ImageWid-RightMarginToBorder , height: TitleHeigh))
        TitleLabel.font = UIFont.systemFont(ofSize: 16)
        TitleLabel.textColor = UIColor.black
        TitleLabel.numberOfLines = 2
        self.contentView.addSubview(TitleLabel)
        OriginLabel = UILabel.init(frame: CGRect.init(x: TitleLabel.frame.origin.x, y: self.frame.size.height-20, width: 0, height: 0))
        OriginLabel.font = UIFont.systemFont(ofSize: 12)
        OriginLabel.textColor = UIColor.colorWithHexString(hex: "9E9E9E")
        self.contentView.addSubview(OriginLabel)
        TimeLabel = UILabel.init()
        TimeLabel.textColor = UIColor.colorWithHexString(hex: "9E9E9E")
        TimeLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(TimeLabel)
        StateImageView = UIImageView.init(frame: CGRect.init(x: kScreenWid-CGFloat(ImageSpaceToBorder)-ZJFWid, y: self.bounds.size.height-CGFloat(RightMarginToBorder)-ZJFHeigh, width: ZJFWid, height: ZJFHeigh))
        StateImageView.contentMode=UIViewContentMode.scaleAspectFill
        self.contentView.addSubview(StateImageView)
    }
    
    
    func feedData(source : MainCellModel?) -> Void {
        guard source != nil else {
            return
        }
        Data = source
        TitleImageView.sd_setImage(with: URL.init(string: Data!.imageURL))
        TitleLabel.text = Data!.title
        OriginLabel.text = Data!.origin
        let size = OriginLabel.text?.StringSize(font: OriginLabel.font, maxSize: CGSize.init(width: 100, height: 10))
        OriginLabel.frame = CGRect.init(origin: OriginLabel.frame.origin, size: size!)
        TimeLabel.text = Data!.dateStr
        if Data!.changed {
            TitleLabel.textColor = UIColor.colorWithHexString(hex: "#969696")
        }
        let sizeTime = TimeLabel.text?.StringSize(font: TimeLabel.font, maxSize: CGSize.init(width: 100, height: 10))
        TimeLabel.frame = CGRect.init(x: OriginLabel.frame.origin.x+OriginLabel.frame.size.width+5, y: OriginLabel.frame.origin.y, width: sizeTime!.width, height: sizeTime!.height)
        if(Data?.isToShare == "0" && Data!.shareMode == "1"){
            StateImageView.image = UIImage.init(named: "zhidao");
        }else if(Data?.isToShare == "0" && Data!.shareMode == "2"){
            StateImageView.image = UIImage.init(named: "zanjifen");
        }else {
            StateImageView.image = nil
        }
    }
}



//HeaderViewRelated
class HeaderView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    
    private var collection : UICollectionView? = nil
    private var dataSource : Array<CollectionCellModel>? = nil
    private var indexIndicator : UIPageControl? = nil
    public var delegate : helpTurn? = nil
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let topView = UIImageView.init(frame: CGRect.init(x: (kScreenWid-13)/2, y: zero, width: 13, height: 13))
        topView.image = UIImage.init(named: "sr_refresh")
        topView.backgroundColor = UIColor.red
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = self.frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collection = UICollectionView.init(frame: CGRect.init(x: 0, y: topView.frame.size.height, width: kScreenWid, height: 200), collectionViewLayout: flowLayout)
        collection?.isPagingEnabled = true
        collection?.showsHorizontalScrollIndicator = false
        collection?.showsVerticalScrollIndicator = false
        collection?.register(HeadCell.classForCoder(), forCellWithReuseIdentifier: "HeadCell")
        collection?.delegate = self
        collection?.dataSource = self
        self.addSubview(collection!)
        indexIndicator = UIPageControl.init()
        indexIndicator?.pageIndicatorTintColor = UIColor.white
        indexIndicator?.currentPageIndicatorTintColor = UIColor.colorWithHexString(hex: "#00A5EE")
        self.addSubview(indexIndicator!)
        self.addSubview(topView)
    }
    
    func feedData(dtSource : Array<CollectionCellModel>?) -> Void {
        guard dtSource != nil else {
            return
        }
        let totalCount = dtSource!.count * 100
        let currentIndex = totalCount / 2
        dataSource = dtSource
        collection!.reloadData()
        indexIndicator?.numberOfPages = dataSource!.count
        let wid = (2 * dataSource!.count - 1) * 8
        indexIndicator?.frame = CGRect.init(x: kScreenWid - CGFloat(wid) - 10.0, y: self.frame.size.height - 15.0, width: CGFloat(wid), height: 8.0)
        self.collection!.contentOffset.x = CGFloat(currentIndex) * kScreenWid
        Timer.scheduledTimer(withTimeInterval: TimeInterval.init(5.0), repeats: true) { (timer) in
            if self.dataSource!.count>0 {
                let currentIndex = Int(self.collection!.contentOffset.x) / Int(self.frame.size.width)
                var target = currentIndex+1
                let count = self.dataSource!.count * 100
                if target == count {
                    target = 0
                }
                self.collection!.scrollToItem(at: IndexPath.init(row: target, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
            }
        }
    }
    
    //collectiondelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collection?.deselectItem(at: indexPath, animated: true)
        let articleCtl = ArticleViewController.init()
        articleCtl.articleTitle = "知道头条"
        let  idx = indexPath.row % dataSource!.count
        let model = dataSource![idx];
        if model.url.hasPrefix("http"){
            articleCtl.articleUrl = model.url
            self.delegate?.turn(viewCtl: articleCtl)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection?.dequeueReusableCell(withReuseIdentifier: "HeadCell", for: indexPath)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! HeadCell
        let  idx = indexPath.row % dataSource!.count
        cell.feedModel(modl: dataSource![idx])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard dataSource != nil else {
            return 0
        }
        return dataSource!.count * 100
    }
    //scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let idex = scrollView.contentOffset.x / kScreenWid
        let page = Int(idex) % dataSource!.count
        indexIndicator!.currentPage = page
    }
}
class CollectionCellModel{
    var name : String = ""
    var pic : String = ""
    var url : String = ""
}
class HeadCell: UICollectionViewCell {
    private var model : CollectionCellModel? = nil
    var gradientLayer : CAGradientLayer? = nil
    var title : CATextLayer? = nil
    var mainImage : UIImageView? = nil
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainImage = UIImageView.init(frame: self.bounds)
        mainImage?.contentMode = UIViewContentMode.scaleToFill
        self.contentView.addSubview(mainImage!)
        gradientLayer = CAGradientLayer.init()
        gradientLayer!.frame = CGRect.init(x: 0.0, y: mainImage!.frame.size.height-35, width: kScreenWid, height: 35.0)
        gradientLayer!.colors = [UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0).cgColor,UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.45).cgColor]
        gradientLayer?.startPoint = CGPoint.init(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint.init(x: 0.0, y: 1.0)
        gradientLayer?.opacity = 0.6
        title = CATextLayer.init()
        title?.frame = CGRect.init(x: 10, y: mainImage!.frame.size.height-20, width: kScreenWid, height: 35)
        title?.foregroundColor = UIColor.white.cgColor
        title?.alignmentMode = kCAAlignmentJustified
        title?.isWrapped = false
        let font = UIFont.boldSystemFont(ofSize: 14)
        let fontName = CFBridgingRetain(font.fontName)
        let fontRef = CGFont.init(fontName! as! CFString)
        title?.font = fontRef
        title?.fontSize = font.pointSize
        title?.contentsScale = UIScreen.main.scale
        mainImage?.layer.addSublayer(gradientLayer!)
        mainImage?.layer.addSublayer(title!)
    }
    func feedModel(modl : CollectionCellModel)->Void{
        model = modl
        let url = URL.init(string: model!.pic)
        mainImage?.sd_setImage(with: url!)
        title?.string = model?.name
    }
}




