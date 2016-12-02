//
//  UIViewController+NGP.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/2.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import Foundation

private let loadingImageViewTag = 10000

extension UIViewController {
    var loadingImageView: UIImageView {
        if let imageView = self.view.viewWithTag(loadingImageViewTag) {
            return imageView as! UIImageView
        }
        let loadingImageView = UIImageView()
        loadingImageView.tag = loadingImageViewTag
        self.view.addSubview(loadingImageView)
        var animationImages = [UIImage]()
        for index in 1...32 {
            
            if let image = UIImage(named: "loading_\(index)") {
                animationImages.append(image)
            }
        }
        loadingImageView.animationImages = animationImages
        
        loadingImageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.view)
        }
        return loadingImageView
    }
}
