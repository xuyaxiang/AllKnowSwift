//
//  ArticleViewController.swift
//  SwiftForAllKnow
//
//  Created by enghou on 16/10/5.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import UIKit
struct ArticleInfo {
    var shareMode : String
    var isToShare : String
    var savePath : String
    var amount : CGFloat
    var aId : String
    var description : String
    var picUrl : String
    var title : String
}
class ArticleViewController: RootViewController {
    var articleTitle : String?
    var articleUrl : String?
    var info : ArticleInfo?
    var web : UIWebView?
    var shareBtn : UIButton?
    var forwardBtn : UIButton?
    var nextBtn : UIButton?
    var articleStatus : Int = -2
    var index : Int = 0 
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        web = UIWebView.init(frame: CGRect.init(x: 0.0, y: diyNavigationHeight-20, width: kScreenWid, height: kScreenHeigh-diyNavigationHeight-webViewTrayHeight+20))
        let urlRequest = URLRequest.init(url: URL.init(string: articleUrl!)!)
        web?.loadRequest(urlRequest)
        self.view.addSubview(web!)
        self.publicNavigationBar(title: self.title!, popSelector: #selector(goForwardAction))
        bottomTray()
        determineArticleState();
    }
    
    private func registerNotification()->Void{
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: NSNotification.Name("showAlert"), object: nil)
    }
    
    @objc func showAlert()->Void{
        self.alertSomeMessage(title: defaultAlertTitle, content: "打开微信复制文章连接开始赚钱?", sureTitle: defaultSureTitle, cancelTitle: defaultCancelTitle, ensureAction: { (alert) in
            UIApplication.shared.open(URL.init(string: "weixin://qr/JnXv90fE6hqVrQOU9yA0")!, options: ["n":"n"], completionHandler: nil)
            }) { (alert) in
                
        }
    }
    
    private func bottomTray()->Void{
        let trayView = UIView.init(frame: CGRect.init(x: zero, y: kScreenHeigh-webViewTrayHeight, width: kScreenWid, height: webViewTrayHeight))
        let lineView = UIView.init(frame: CGRect.init(x: zero, y: zero, width: kScreenWid, height: lineHeight))
        lineView.backgroundColor = UIColor.defaultGrayColor()
        trayView.addSubview(lineView)
        trayView.backgroundColor = UIColor.colorWithHexString(hex: "FAFAFA")
        shareBtn = UIButton.init(type: UIButtonType.system)
        shareBtn?.tintColor = UIColor.white
        forwardBtn = UIButton.init(type: UIButtonType.system)
        nextBtn = UIButton.init(type: UIButtonType.system)
        if kScreenWid == 320{
            shareBtn?.frame = CGRect.init(x: kScreenWid-210.0, y: 7.0, width: 200.0, height: 36)
            forwardBtn?.frame = CGRect.init(x: 0.0, y: 10.0, width: 46.0, height: 30.0)
            nextBtn?.frame = CGRect.init(x: 80.0, y: 10.0, width: 36.0, height: 30.0)
            forwardBtn?.imageEdgeInsets = UIEdgeInsetsMake(0.0, -15.0, 0.0, 0.0)
            nextBtn?.imageEdgeInsets = UIEdgeInsetsMake(0.0, -20.0, 0.0, 0.0)
            shareBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        }else{
            shareBtn?.frame = CGRect.init(x: kScreenWid-234.0, y: 7.0, width: 224.0, height: 36)
            forwardBtn?.frame = CGRect.init(x: 20.0, y: 10.0, width: 56.0, height: 30.0)
            nextBtn?.frame = CGRect.init(x: 110.0, y: 10.0, width: 36.0, height: 30.0)
            forwardBtn?.imageEdgeInsets = UIEdgeInsetsMake(0.0, -30.0, 0.0, 0.0)
            nextBtn?.imageEdgeInsets = UIEdgeInsetsMake(0.0, -20.0, 0.0, 0.0)
            shareBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        }
        shareBtn?.layer.cornerRadius = 2.0
        shareBtn?.addTarget(self, action: #selector(share), for: UIControlEvents.touchUpInside)
        forwardBtn?.setImage(UIImage.init(named: "canForward"), for: UIControlState.normal)
        forwardBtn?.addTarget(self, action:#selector(goForwardAction) , for: UIControlEvents.touchUpInside)
        nextBtn?.setImage(UIImage.init(named: "canNotNext"), for: UIControlState.normal)
        nextBtn?.addTarget(self, action: #selector(goNextAction), for: UIControlEvents.touchUpInside)
        trayView.addSubview(forwardBtn!)
        trayView.addSubview(nextBtn!)
        trayView.addSubview(shareBtn!)
        self.view.addSubview(trayView)
    }
    
    @objc private func share()->Void{
        //抢钱接口
        switch articleStatus {
        case 0:
            let param = ["conditionId":info!.aId]
            shareBtn?.isEnabled = false
            NetWorkTool.sharedInstance().confirmToShare(param: param, success: { (source) in
                let status = source["status"] as! String
                self.shareBtn?.isEnabled = true
                NotificationCenter.default.post(name: NSNotification.Name("refreshOne"), object: self.index)
                if status == "success"{
                    let dict = source["results"] as! Dictionary<String,String>
                    self.info!.savePath = dict["savepath"]!
                    self.shareAction()
                    self.firstLogin()
                    if self.info?.shareMode == "1"{
                        self.shareBtn?.backgroundColor = UIColor.defaultBackGroundColor()
                        self.shareBtn?.setTitle("分享 封顶"+String(describing: self.info?.amount)+"元", for: UIControlState.normal)
                    }else if self.info?.shareMode == "2"{
                        self.shareBtn?.backgroundColor =  UIColor.defaultBackGroundColor()
                        self.shareBtn?.setTitle("欢迎分享", for: UIControlState.normal)
                        self.shareBtn?.backgroundColor = UIColor.init(red: 0.494, green: 0.471, blue: 0.89, alpha: 1)
                        self.articleStatus = 1
                    }
                }else{
                    self.alertSomeMessage(title: "提示", content: source["message"] as? String, sureTitle: defaultSureTitle, cancelTitle: defaultCancelTitle, ensureAction: { (alert) in
                        
                        }, cancelAction: { (alert) in
                            
                    })
                }
                }, failure: { (errorCode) in
                    
            })
            break
        case 1:
            self.shareAction()
            break;
        case -2:
            self.callLoginVC()
            break
        default:
            break
        }
    }
    private func shareAction()->Void{
        guard UserInfoReader.recentUser() != nil else {
            self.callLoginVC()
            return
        }
        let shareParams = NSMutableDictionary.init()
        var wxDetail : String?
        if (info!.description as NSString).length == 0{
            wxDetail = "都知道"
        }else{
            wxDetail = info?.description
        }
        shareParams.ssdkSetupShareParams(byText: wxDetail, images: NSURL.init(string: info!.picUrl), url: URL.init(string: info!.savePath), title: info!.title, type: SSDKContentType.auto)
        ShareCustom.shareWithContent(publishContent: shareParams)
        
    }
    
    private func callLoginVC()->Void{
        
    }
    
    private func firstLogin()->Void{
        let page1 : String? = UserDefaults.standard.value(forKey: "page1") as? String
        if page1 == "newUser"{
            if info?.shareMode == "1"{
                UserDefaults.standard.set("1", forKey: "showHud")
            }else if info?.shareMode == "2"{
                UserDefaults.standard.set("2", forKey: "showHud")
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    @objc private func goNextAction()->Void{
        if web!.canGoForward {
            web?.goForward()
        }
    }
    @objc private func goForwardAction()->Void{
        if web!.canGoBack {
            web?.goBack()
        }else{
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    private func determineArticleState()->Void{
        let amount = self.info!.amount
        if UserInfoReader.recentUser() != nil {
            if self.info?.shareMode == "1"{
                if(self.info?.isToShare == "0"){
                    articleStatus = 0
                    shareBtn?.setTitle("抢单分享 封顶"+String(describing: amount)+"元", for: UIControlState.normal)
                    shareBtn?.backgroundColor = UIColor.colorWithHexString(hex: "ff5c61")
                }else if(self.info?.isToShare == "-1"){
                    articleStatus = 1
                    shareBtn?.setTitle(String(describing: amount)+"元抢单结束 欢迎分享", for: UIControlState.normal)
                    shareBtn?.backgroundColor = UIColor.defaultBackGroundColor()
                }else if(self.info?.isToShare == "1"){
                    articleStatus = 1
                    shareBtn?.setTitle("分享  封顶"+String(describing: amount)+"元", for: UIControlState.normal)
                    shareBtn?.backgroundColor = UIColor.defaultBackGroundColor()
                }
            }else if self.info?.shareMode == "2"{
                if(self.info?.isToShare == "0"){
                    articleStatus = 0
                    shareBtn?.setTitle("欢迎分享攒积分", for: UIControlState.normal)
                    shareBtn?.backgroundColor = UIColor.init(red: 0.494, green: 0.471, blue: 0.890, alpha: 1)
                }else{
                    articleStatus = 1
                    shareBtn?.setTitle("欢迎分享", for: UIControlState.normal)
                    shareBtn?.backgroundColor = UIColor.init(red: 0.494, green: 0.471, blue: 0.890, alpha: 1)
                }
            }
        }else{
            shareBtn?.setTitle("分享", for: UIControlState.normal)
            shareBtn?.backgroundColor = UIColor.colorWithHexString(hex: "ff5c61")
        }
    }
}
