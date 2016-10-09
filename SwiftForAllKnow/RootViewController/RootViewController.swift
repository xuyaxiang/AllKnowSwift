//
//  RootViewController.swift
//  SwiftAllKnow
//
//  Created by enghou on 16/9/29.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import UIKit

typealias messageHandler = (_ action : UIAlertAction)->Void

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    public func alertSomeMessage(title : String?,content : String?,sureTitle : String?,cancelTitle :String?,ensureAction : @escaping messageHandler,cancelAction : @escaping messageHandler) -> Void {
        let alertConCtl = UIAlertController.init(title: title, message: content, preferredStyle: UIAlertControllerStyle.alert)
        let ensureAction = UIAlertAction.init(title: sureTitle, style: UIAlertActionStyle.default, handler: ensureAction)
        let cancelAction = UIAlertAction.init(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: cancelAction)
        alertConCtl.addAction(ensureAction)
        alertConCtl.addAction(cancelAction)
        self.present(alertConCtl, animated: true) { 
            
        }
    }
    
    
    public func publicNavigationBar(title : String,popSelector : Selector)->Void{
        let bar = UIView.init(frame: CGRect.init(x: zero, y: zero, width: kScreenWid, height: diyNavigationHeight))
        bar.backgroundColor = UIColor.defaultBackGroundColor()
        let titleLabel = UILabel.init(frame: CGRect.init(x: zero, y: 20.0, width: kScreenWid, height: 44))
        titleLabel.font = UIFont.init(name: "Arial-Bold", size: titleFontSize)
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.center
        bar.addSubview(titleLabel)
        let backBtn = UIButton.init(type: UIButtonType.custom)
        backBtn.setImage(UIImage.init(named: "backImg"), for: UIControlState.normal)
        backBtn.frame = CGRect.init(x: 10.0, y: 23.0, width: 60.0, height: 40.0)
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0)
        backBtn.addTarget(self, action: popSelector, for: UIControlEvents.touchUpInside)
        bar.addSubview(backBtn)
        let tray = UIView.init(frame: CGRect.init(x: zero, y: zero, width: kScreenWid, height: diyNavigationHeight))
        tray.backgroundColor = UIColor.defaultBackGroundColor()
        tray.addSubview(bar)
        self.view.addSubview(tray)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
