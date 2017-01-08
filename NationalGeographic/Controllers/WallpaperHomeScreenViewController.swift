//
//  WallpaperHomeScreenViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/29.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class WallpaperHomeScreenViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var iconImages: [UIImage]!
    private var iconNames: [String]!
    
    var snapshotImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = snapshotImage

        // Do any additional setup after loading the view.
        iconImages = [#imageLiteral(resourceName: "icon_phones"), #imageLiteral(resourceName: "icon_music"), #imageLiteral(resourceName: "icon_photos"), #imageLiteral(resourceName: "icon_camera"), #imageLiteral(resourceName: "icon_weather"), #imageLiteral(resourceName: "icon_safari"), #imageLiteral(resourceName: "icon_messages"), #imageLiteral(resourceName: "icon_mail"), #imageLiteral(resourceName: "icon_app_store"), #imageLiteral(resourceName: "icon_settings")]
        iconNames = ["电话", "音乐", "相册", "相机", "天气", "Safari", "信息", "邮件", "App Store", "设置"]
        collectionView.dataSource = self
        collectionView.reloadData()
        
        let tapGesture = UITapGestureRecognizer { (gesture) in
            self.dismiss(animated: true, completion: nil)
        }
        self.view.addGestureRecognizer(tapGesture)
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
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iconViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconViewCell", for: indexPath) as! IconViewCell
        iconViewCell.iconImageView.image = iconImages[indexPath.row]
        iconViewCell.iconNameLabel.text = iconNames[indexPath.row]
        return iconViewCell
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}