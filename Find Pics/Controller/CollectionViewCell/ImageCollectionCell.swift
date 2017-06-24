//
//  ImageCollectionCell.swift
//  Find Pics
//
//  Created by Aditya Tanna on 6/22/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    var image: Image? {
        didSet {
            if let strImgUrl = image?.link{
                if let urlImage = URL(string: strImgUrl){
                    imgResult.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "placeholder"), options: .refreshCached)
                }
            }
        }
    }
}
