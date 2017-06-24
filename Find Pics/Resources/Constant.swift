//
//  Constant.swift
//  Find Pics
//
//  Created by Aditya Tanna on 1/4/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire
import CoreLocation

struct DC  //DefaultConstant
{
    static let appName = "Find Pic"
    
    static let NoInternetMsg = "Looks like you're not connected to Internet."
    
    static let baseURL = "https://techblog.expedia.com/utility/"
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
            
        return viewController
    }
}
extension String {
    func heightWithConstrainedHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height + 20
    }
    
    func widthWithConstrainedWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: ScreenSize.SCREEN_WIDTH - 105, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width + 20
    }
}

//MARK:- Show Alert
extension UIViewController {
    
    func showAlertWithErrorMsg(_ alertMsg: String) {
        let alert = UIAlertController(title: "", message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithErrorMsgAndPopUponOK(_ alertMsg: String) {
        
        let alert = UIAlertController(title: "Error", message: alertMsg, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { void in
            _ = self.navigationController?.popViewController(animated: true)
        });
        alert.addAction(action)
            
        self.present(alert, animated: true, completion: nil)
    }
    
    func addCustomBackButton(){
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func backAction(_ sender: UIButton) {
        if let vc = UIApplication.topViewController(){
            
            vc.navigationController?.popViewController(animated: true)
        }
    }
    
    class func loadStoryboard(storyboardName: String, storyboardId: String) -> Self
    {
        return instantiateFromStoryboardHelper(storyboardName: storyboardName, storyboardId: storyboardId)
    }
    
    class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T
    {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
}

//MARK:- Global App Delegate
func getAppDelegate()  -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

//MARK:- Download Image with URL
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                
                self.image = image
            })
        }).resume()
    }
}


//MARK:- Common Web Service call & Show & Hide Activity Indicator with message
func callWebService(_ url: String, parameters: [String: AnyObject]?, methodHttp: HTTPMethod , completion: @escaping (_ result: AnyObject) -> Void, failure: @escaping (_ result: AnyObject) -> Void) {
    
    if (Reachability.isConnectedToNetwork()){
        
        showActivityIndicator()
        
        Alamofire.request(url, method: methodHttp, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("Status code : \(status)")
                case 201:
                    print("Status code : \(status)")
                default:
                    print("Status code : \(status)")
                }
            }
            
            switch( response.result){
            case .failure(let error):
                print(error)
                
                if let vc = UIApplication.topViewController(){
                    vc.showAlertWithErrorMsg("Looks like something went wrong")
                    print("This is the URL: \(url)")
                }
            case .success(let json):
                
                if let response = (json as? [String:Any]){
                    completion(response["hotels"] as AnyObject)
                }else{
                    if let vc = UIApplication.topViewController(){
                        vc.showAlertWithErrorMsg("Looks like something went wrong")
                        print("This is the URL: \(url)")
                    }
                }
            }
            DispatchQueue.main.async {
                hideActivityIndicator()
            }
        }
    }else{
        if let vc = UIApplication.topViewController(){
            vc.showAlertWithErrorMsg(DC.NoInternetMsg)
        }
    }
}

//MARK:- SHOW & HIDE ACTIVITY INDICATOR
func showActivityIndicator() {
    
    if((getAppDelegate().viewActivity == nil)){
        getAppDelegate().viewActivity = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        getAppDelegate().viewActivity?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        getAppDelegate().indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        getAppDelegate().indicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        getAppDelegate().indicator?.startAnimating()
        
        let lbl:UILabel = UILabel(frame: CGRect(x: 3, y: 0, width: (getAppDelegate().viewActivity?.frame.size.width)! - 6, height: 30))
        lbl.numberOfLines = 0
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 15.0)
        lbl.textAlignment = NSTextAlignment.center
        lbl.text = "Loading..."
        
        getAppDelegate().indicator!.center = CGPoint(x: (getAppDelegate().viewActivity?.center.x)!, y: (getAppDelegate().viewActivity?.center.y)! - ((getAppDelegate().indicator?.frame.size.height)! / 4))
        
        lbl.center = CGPoint(x: (getAppDelegate().viewActivity?.center.x)!, y: (getAppDelegate().indicator?.frame)!.maxY + ((getAppDelegate().indicator?.frame.size.height)! / 4))
        
        getAppDelegate().viewActivity?.addSubview(lbl)
    }else{
        getAppDelegate().indicator?.center = (getAppDelegate().viewActivity?.center)!
    }
    
    getAppDelegate().viewActivity?.addSubview(getAppDelegate().indicator!)
    getAppDelegate().viewActivity?.layer.cornerRadius = 10
    getAppDelegate().viewActivity?.center = (getAppDelegate().window?.center)!
    
    getAppDelegate().window?.addSubview((getAppDelegate().viewActivity)!)
}

func hideActivityIndicator(){
    if(getAppDelegate().viewActivity != nil){
        getAppDelegate().indicator?.stopAnimating()
        getAppDelegate().viewActivity?.removeFromSuperview()
        getAppDelegate().indicator = nil
        getAppDelegate().viewActivity = nil
    }
}

// MARK:- Animation
func popUpAnimation(view: UIView){
    view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { 
        view.transform = .identity
    },completion: { (finished) in
        // do something once the animation finishes, put it here
    })
}

func endPopupAnimation(view: UIView){
    
    view.transform = .identity
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations:{
        view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    },completion: { (finished) in
        
    })
}
