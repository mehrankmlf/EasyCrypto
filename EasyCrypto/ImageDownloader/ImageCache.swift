//
//  ImageCache.swift
//  DrinkApp
//
//  Created by Mehran on 5/28/1401 AP.
//

import UIKit

final class DownloadedImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension DownloadedImageCache {
    private static var imageCache = DownloadedImageCache()
    static func getImageCache() -> DownloadedImageCache {
        return imageCache
    }
}
