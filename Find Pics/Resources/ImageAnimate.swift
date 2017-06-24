//
//  ImageAnimate.swift
//  Find Pics
//
//  Created by Aditya Tanna on 6/22/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import UIKit

class ImageAnimate: UIView {

    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    var statusImageView: UIImageView?
    
    func animateImageView(_ statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            if let keyWindow = UIApplication.shared.keyWindow {
                
                statusImageView.alpha = 0
                
                blackBackgroundView.frame = self.frame
                blackBackgroundView.backgroundColor = UIColor.black
                blackBackgroundView.alpha = 0
                keyWindow.addSubview(blackBackgroundView)
                
                navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
                navBarCoverView.backgroundColor = UIColor.black
                navBarCoverView.alpha = 0
                
                
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
                
                zoomImageView.backgroundColor = UIColor.red
                zoomImageView.frame = startingFrame
                zoomImageView.isUserInteractionEnabled = true
                zoomImageView.image = statusImageView.image
                zoomImageView.contentMode = .scaleAspectFill
                zoomImageView.clipsToBounds = true
                keyWindow.addSubview(zoomImageView)
                
                keyWindow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
                
                UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                    
                    let height = (self.frame.width / startingFrame.width) * startingFrame.height
                    
                    let y = self.frame.height / 2 - height / 2
                    
                    self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.frame.width, height: height)
                    
                    self.blackBackgroundView.alpha = 1
                    
                    self.navBarCoverView.alpha = 1
                    
                    self.tabBarCoverView.alpha = 1
                    
                }, completion: nil)
            }
        }
    }
    
    func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                self.zoomImageView.frame = startingFrame
                
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
                
            }, completion: { (didComplete) -> Void in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCoverView.removeFromSuperview()
                self.statusImageView?.alpha = 1
            })
            
        }
    }

}
