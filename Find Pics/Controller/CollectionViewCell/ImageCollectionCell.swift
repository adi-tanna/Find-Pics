//
//  ImageCollectionCell.swift
//  Find Pics
//
//  Created by Aditya Tanna on 6/22/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet var imgResult: UIImageView!
    
    var findPicVC: FindPicVC?
    
    var vwImageAnimate : ImageAnimate?
    
    func animate() {

        vwImageAnimate?.animateImageView(imgResult)
    }
    
    override func awakeFromNib() {
        vwImageAnimate = ImageAnimate(frame: UIScreen.main.bounds)
        
        imgResult.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
    }
    
    var character: Characters? {
        didSet {
            if let strImgName = character?.name{
                if let img = UIImage(named: strImgName){
                    imgResult.image = img
                }
            }
        }
    }
}
