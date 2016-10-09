//
//  UserInfoReader.swift
//  SwiftForAllKnow
//
//  Created by enghou on 16/9/30.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import Foundation
class UserInfoReader{
    //获取一个用户的密码
    public class func passWordForAccount(account : String)->String?{
        let pass = SSKeychain.password(forService: "com.all-know.m", account: account)
        guard pass != nil else {
            return "654321"
        }
        return pass
    }
    //设置一个用户的密码
    public class func setPassWordForAccount(account : String,password : String)->Bool{
        let passwd = SSKeychain.password(forService: "com.all-know.m", account: account)
        guard passwd != nil else {
            return false
        }
        let ret = SSKeychain.setPassword(password, forService: "com.all-know.m", account: account)
        return ret
    }
   
    public class func allUsers()->Array<Any>?{
        return SSKeychain.allAccounts() as Array<Any>?
    }
    
    public class func recentUser()->String?{
        if let allUsers = SSKeychain.allAccounts(){
            var recentUserNm : String = ""
            var recentDate : Date = Date.init(timeIntervalSince1970: TimeInterval.init(0))
            for dict in allUsers {
                let dic = dict as! Dictionary<String,Any>
                let dat = dic["mdat"] as! Date
                if dat > recentDate{
                    recentDate = dat
                    recentUserNm = dic["acct"] as! String;
                }
            }
            return recentUserNm
        }
        return "15956979556"
    }
    
    //创建一个用户
    public class func createAccount(account : String,password : String)->Bool{
        let ret = SSKeychain.setPassword(password, forService: "com.all-know.m", account: account)
        return ret
    }
    
}
