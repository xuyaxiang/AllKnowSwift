//
//  ShareCustom.swift
//  SwiftForAllKnow
//
//  Created by enghou on 16/10/8.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import UIKit

let KWidth_Scale = UIScreen.main.bounds.size.width / 375.0
class ShareCustom: NSObject {
    static var _publishContent : NSMutableDictionary = NSMutableDictionary.init()
    public class func shareWithContent(publishContent : NSMutableDictionary)->Void{
        _publishContent = publishContent
        let window = UIApplication.shared.keyWindow
        let shareView = UIView.init(frame: CGRect.init(x: zero, y: kScreenHeigh+20, width: kScreenWid, height: 300))
        shareView.backgroundColor = UIColor.white
        shareView.tag = 441
        shareView.layer.borderWidth = 1
        shareView.layer.borderColor = UIColor.init(red: 0.929, green: 0.929, blue: 0.929, alpha: 1).cgColor
        window!.addSubview(shareView)
        let titleLabel = UILabel.init(frame: CGRect.init(x: zero, y: zero, width: shareView.frame.size.width, height: 45*KWidth_Scale))
        titleLabel.text = "分享到"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 15*KWidth_Scale)
        titleLabel.textColor = UIColor.init(red: 0.486, green: 0.447, blue: 0.447, alpha: 1)
        titleLabel.backgroundColor = UIColor.clear
        shareView.addSubview(titleLabel)
        let btnImages = ["weixin","pengyouquan","weibo","qq","qzone","more"]
        let btnTitles = ["微信好友","微朋友圈","新浪微博","QQ","QQ空间","更多"]
        for i in 0...5 {
            var top : CGFloat = 0.0
            if(i<3){
                top = 10
            }else{
                top = 110
            }
            let button = UIButton.init(type: UIButtonType.custom)
            let x : CGFloat = (kScreenWid-180)/4+(60+(kScreenWid-180)/4)*CGFloat((i%3))
            button.frame = CGRect.init(x: x, y: titleLabel.frame.origin.y+titleLabel.frame.size.height+top, width: 60, height: 100)
            let image = UIImage.init(named: btnImages[i])
            button.setImage(image, for: UIControlState.normal)
            button.setTitle(btnTitles[i], for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -60, -80, 0)
            button.setTitleColor(UIColor.init(red: 0.47, green: 0.47, blue: 0.47, alpha: 1), for: UIControlState.normal)
            button.tag = 331+i
            button.addTarget(self, action: #selector(shareBtnClick(btn:)), for: UIControlEvents.touchUpInside)
            shareView.addSubview(button)
        }
        let cancelBtn = UIButton.init(type: UIButtonType.custom)
        cancelBtn.frame = CGRect.init(x: zero, y: shareView.frame.size.height-40, width: shareView.frame.size.width, height: 40)
        cancelBtn.tag = 339
        cancelBtn.setTitleColor(UIColor.init(red: 0.47, green: 0.47, blue: 0.47, alpha: 1), for: UIControlState.normal)
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.addTarget(self, action: #selector(shareBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        shareView.addSubview(cancelBtn)
        let separator = UIView.init(frame: CGRect.init(x: zero, y: shareView.frame.size.height-40, width: kScreenWid, height: 0.5))
        separator.backgroundColor = UIColor.init(red: 0.929, green: 0.929, blue: 0.929, alpha: 1)
        shareView.addSubview(separator)
        UIView.animate(withDuration: 0.35) { 
            shareView.frame = CGRect.init(x: zero, y: kScreenHeigh - 300, width: kScreenWid, height: 300)
        }
        
    }
    @objc private class func shareBtnClick(btn : UIButton)->Void{
        let window = UIApplication.shared.keyWindow
        let shareView = window?.viewWithTag(441)
        UIView.animate(withDuration: 0.35, animations: { 
            shareView?.frame = CGRect.init(x: zero, y: kScreenHeigh-20, width: kScreenWid, height: 300)
            }) { (result) in
                shareView?.removeFromSuperview()
        }
        var shareType : UInt = 0
        switch btn.tag {
        case 331:
            shareType = SSDKPlatformType.subTypeWechatSession.rawValue
            let past = UIPasteboard.general
            let content = (_publishContent["title"] as! String)+(_publishContent["url"] as! URL).absoluteString
            past.string = content
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showAlert"), object: nil)
            return
        case 332:
            shareType = SSDKPlatformType.subTypeWechatTimeline.rawValue
            let past = UIPasteboard.general
            let content = (_publishContent["title"] as! String)+(_publishContent["url"] as! URL).absoluteString
            past.string = content
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showAlert"), object: nil)
            return
        case 333:
            shareType = SSDKPlatformType.typeSinaWeibo.rawValue
            _publishContent["text"] = (_publishContent["text"] as! String)+(_publishContent["url"] as! URL).absoluteString
            break
        case 334:
            shareType = SSDKPlatformType.subTypeQQFriend.rawValue
            break
        case 335:
            shareType = SSDKPlatformType.subTypeQZone.rawValue
            break
        case 336:
            break
        case 339:
            break;
        default:
            break
        }
        ShareSDK.share(SSDKPlatformType(rawValue: shareType)!, parameters: _publishContent) { (state, userData, contentEntity, error) in
            
        }
        
    }
    
}
