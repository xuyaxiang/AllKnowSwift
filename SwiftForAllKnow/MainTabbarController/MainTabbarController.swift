//
//  MainTabbarController.swift
//  SwiftForAllKnow
//
//  Created by enghou on 16/9/30.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import UIKit
class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let ret = userShouldAutoLogin()
//        if ret {
//            loginWithRecentUser()
//        }
        loginWithRecentUser()
        // Do any additional setup after loading the view.
    }

    func userShouldAutoLogin()->Bool{
        guard UserInfoReader.allUsers() != nil else {
            return false
        }
        return UserInfoReader.allUsers()!.count > 0 ? true : false
    }
    
    func loginWithRecentUser()->Void{
//        let usrNm = UserInfoReader.recentUser()
//        guard usrNm != nil else {
//            return
//        }
//        let passwd = UserInfoReader.passWordForAccount(account: usrNm!)
//        guard  passwd != nil else {
//            return
//        }
//        //login
//        let param = [USR_TEL:usrNm!,USR_PWD:passwd!];
        let param = [USR_TEL:"15956979556",USR_PWD:"e10adc3949ba59abbe56e057f20f883e","ismd5":"true"];
        NetWorkTool.sharedInstance().userLogin(param: param, success: { (source) in
            //postNotification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMainPageData"), object: nil)
//            let status = source["status"] as! String
//            if status == "success"{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadMainPageData"), object: nil)
//            }else{
//                //alert 重新登录
//            }
            }) { (errorCode) in
                //NothingToDo
        }
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
