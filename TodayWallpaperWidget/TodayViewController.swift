//
//  TodayViewController.swift
//  TodayWallpaperWidget
//
//  Created by Chaosky on 2016/12/12.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import Kingfisher

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    var todayPictorialModel: NiceWallpaperImageModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        print(NSHomeDirectory())
        setupViews()
        requestTodayPictorial()
    }
    
    func requestTodayPictorial() {
        
        loadingImageView.startAnimating()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayStr = dateFormatter.string(from: Date())
        
        let sharedUserDefaults = UserDefaults(suiteName: "group.WorldPicture.sharedDatas")
        let shareData = sharedUserDefaults?.data(forKey: todayStr)
        
        let pixelSize = UIScreen.main.nativeBounds
        let resolution = "{\(Int(pixelSize.width)), \(Int(pixelSize.height))}"
        let urlParams = [
            "time": "\(Int(Date().timeIntervalSince1970))",
            "platform":"iphone",
            "resolution": resolution,
            "page_size":"20",
            ]
        
        let url = URL(string: NGPAPI_ZUIMEIA_EVERYDAY_WALLPAPER)!
        
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 15)
        
        let encodedRequest = try! URLEncoding.default.encode(request, with: urlParams)
        
        let cacheResponse = URLCache.shared.cachedResponse(for: encodedRequest)
        let cacheData = cacheResponse?.data
        
        if shareData != nil && cacheData == nil {
            let response = URLResponse(url: url, mimeType: "applcation/json", expectedContentLength: shareData!.count, textEncodingName: "utf-8")
            let cacheResponse = CachedURLResponse(response: response, data: shareData!)
            URLCache.shared.storeCachedResponse(cacheResponse, for: request)
        }
        
        AF.request(encodedRequest).responseJSON { [weak self] (response) in
            guard let self = self else { return }
            
            if let JSON = try? response.result.get(), let model = NiceWallpaperModel.yy_model(withJSON: JSON), let images = model.data?.images {
                self.todayPictorialModel = images.first
                if shareData == nil {
                    sharedUserDefaults?.set(self.todayPictorialModel.yy_modelToJSONData(), forKey: todayStr)
                    sharedUserDefaults?.synchronize()
                }
                
                DispatchQueue.main.async {
                    self.updateViews()
                    self.loadingImageView.stopAnimating()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.loadingImageView.stopAnimating()
                }
            }
        }
    }
    
    func setupViews() {
        
        view.backgroundColor = UIColor.clear
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        topView.layer.contents = KFCrossPlatformImage(named: "Pictorial/Navbar_mask")?.cgImage
        
        todayLabel.textColor = .white
        monthLabel.textColor = .white
        titleLabel.textColor = .white
        
        let dateFormatter = DateFormatter()
        let todayDate = Date()
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: todayDate)
        
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: todayDate)
        
        todayLabel.text = day
        monthLabel.text = month
        titleLabel.text = "今日壁纸"
        
        wallpaperImageView.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        wallpaperImageView.isUserInteractionEnabled = true
        wallpaperImageView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func onTap() {
        extensionContext?.open(URL(string: "worldpicture://TodayWallpaper")!, completionHandler: nil)
    }
    
    func updateViews() {
        titleLabel.text = todayPictorialModel.desc
        
        if let imageURL = todayPictorialModel.image_url {
            wallpaperImageView.kf.setImage(with: URL(string: "\(NGPAPI_ZUIMEIA_BASE_URL)\(imageURL)"), options: [.transition(.fade(0.5))])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets()
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .compact) {
            preferredContentSize = maxSize
        }
        else {
            preferredContentSize = CGSize(width: 0, height: UIScreen.main.bounds.size.height)
        }
    }
    
}
