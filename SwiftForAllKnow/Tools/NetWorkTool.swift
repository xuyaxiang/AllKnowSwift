//
//  NetWorkTool.swift
//  SwiftForAllKnow
//
//  Created by enghou on 16/9/30.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import UIKit
typealias successCallBack = (_ responseObject : Dictionary<String,AnyObject>)->Void
typealias failureCallBack = (_ errorCode : Int)->Void
class NetWorkTool: NSObject {
    let manager : AFHTTPSessionManager = AFHTTPSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
    static let  m = NetWorkTool()
    
    //单例模式
    public class func sharedInstance()->NetWorkTool{
        return m;
    }
    //用户登录
    func userLogin(param : Dictionary<String,String>?,success : @escaping successCallBack,failure : @escaping failureCallBack) -> Void {
        self.baseMethod(requestPath: kUserLogin, param: param, success: { (source) in
            success(source)
            }) { (errorCode) in
                failure(1)
        }
    }
    //获取appbanner信息
    func getBannerInfo(param : Dictionary<String,String>?,success : @escaping successCallBack,failure : @escaping failureCallBack)->Void{
        self.baseMethod(requestPath: kFriendLink, param: param, success: { (source) in
            success(source)
            }) { (code) in
                failure(code)
        }
    }
    
    //获取列表信息
    func getAdvertorialInfo(param : Dictionary<String,String>?,success : @escaping successCallBack,failure : @escaping failureCallBack)->Void{
        self.baseMethod(requestPath: kfindAdvertorialPushList, param: param, success: { (source) in
            success(source);
            }) { (code) in
                failure(code)
        }
    }
    
    func getAdvertorialDetail(param : Dictionary<String,String>?,success : @escaping successCallBack,failure : @escaping failureCallBack) -> Void {
        self.baseMethod(requestPath: kGetAdvertorialPush, param: param, success: { (source) in
            success(source)
            }) { (code) in
                failure(code)
        }
    }
    
    func confirmToShare(param : Dictionary<String,String>?,success : @escaping successCallBack,failure : @escaping failureCallBack)->Void{
        self.baseMethod(requestPath: kShareConfirm, param: param, success: success, failure: failure)
    }
    
    private func baseMethod(requestPath : String,param : Dictionary<String,String>?,success : @escaping successCallBack,failure : @escaping failureCallBack) -> Void {
        manager.requestSerializer = AFHTTPRequestSerializer.init()
        manager.responseSerializer = AFHTTPResponseSerializer.init()
        manager.requestSerializer.timeoutInterval = TimeInterval(kTimeOut)
        let absolutePath = kServerUrl + requestPath
        manager.post(absolutePath, parameters: param, success: { (task, object) in
            do{
                let source = try JSONSerialization.jsonObject(with: object as! Data, options: JSONSerialization.ReadingOptions.allowFragments)
                success(source as! Dictionary<String,AnyObject>)
            }catch{
                
            }
            }) { (task, error) in
                failure(1);
        }
    }
}
