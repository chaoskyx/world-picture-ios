//
//  PictureCell.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/16.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher

class PictureCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet weak var pictureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: PictureModel? {
        didSet {
            if let url = model?.url {
                pictureImageView.kf.setImage(with: URL(string: url), placeholder: Asset.Assets.Dili.nopic.image, options: [.transition(.fade(0.5))])
                pictureImageView.kf.indicatorType = .activity
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pictureImageView
    }
}
