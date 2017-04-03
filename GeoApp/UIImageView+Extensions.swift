//
//  UIImageView+Extension.swift
//  GeoApp
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func imageFromUrl(_ url: URL) {
        let request = URLRequest(url: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
            (response: URLResponse?, data: Data?, error: Error?) -> Void in
                if let imageData = data as Data? {
                    self.image = UIImage(data: imageData)
                    if self.image == nil {
                        self.image = #imageLiteral(resourceName: "placeholder")
                    }
                } else {
                    self.image = #imageLiteral(resourceName: "placeholder")
                }
        }
    }
    
    func setActive() {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = UIColor.white
    }
    
    func setInactive() {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}


