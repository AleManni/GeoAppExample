//
//  UIImageView+Extension.swift
//  GeoApp
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageFromURL(_ url: URL?, placeHolder: UIImage) {
        guard let url = url else {
            self.image = placeHolder
            return
        }

        NSURLConnection.sendAsynchronousRequest(URLRequest(url: url), queue: OperationQueue.main) {
            (response: URLResponse?, data: Data?, error: Error?) -> Void in
            if let imageData = data as Data? {
                self.image = UIImage(data: imageData) ?? placeHolder
            } else {
                self.image = placeHolder
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


