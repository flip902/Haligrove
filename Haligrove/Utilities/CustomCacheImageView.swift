//
//  CustomCacheImageView.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

class CustomCacheImageView: UIImageView {
    
    var imageUrlString: String?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    func loadImageUsingUrlString(urlString: String) {
        activityIndicator.center = center
        addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if err != nil {
                print("Could not download image data: ", err ?? "")
                return
            }
            DispatchQueue.main.async {
                guard let data = data else { return }
                guard let imageToCache = UIImage(data: data) else { return }
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                self.activityIndicator.stopAnimating()
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
            }
            }.resume()
    }
}
