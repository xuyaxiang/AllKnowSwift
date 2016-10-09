//
//  ThirdSDKRegister.swift
//  SwiftForAllKnow
//
//  Created by enghou on 16/10/8.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import UIKit

class ThirdSDKRegister: NSObject {
    public class func registerAllSDK()->Bool{
        ShareSDK.registerApp("8a09889e2b69", activePlatforms: [NSNumber.init(value: 1),NSNumber.init(value: 997),NSNumber.init(value: 998)], onImport: { (platType) in
            switch platType{
            case SSDKPlatformType.typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                break
            case SSDKPlatformType.typeQQ:
                ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                break
            case SSDKPlatformType.typeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                break
            default:
                break
            
            }
            }) { (platform, appInfo) in
                switch platform{
                case SSDKPlatformType.typeSinaWeibo:
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: "2073241577", appSecret: "224a4884760e316f41fd2e5a18d43a41", redirectUri: "http://www.baidu.com", authType: SSDKAuthTypeBoth)
                    break
                case SSDKPlatformType.typeWechat:
                    appInfo?.ssdkSetupWeChat(byAppId: "wxbd0c773211c1e17c", appSecret: "6e709f980840ce68e42a9807693acd52")
                    break
                case SSDKPlatformType.typeQQ:
                    appInfo?.ssdkSetupQQ(byAppId: "1104775583", appKey: "heA8k2g8uG6LDhyK", authType: SSDKAuthTypeBoth)
                    break
                default:
                    break
                }
        }
        return true
    }
}
