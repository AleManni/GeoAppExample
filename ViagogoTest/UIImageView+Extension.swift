//
//  UIImageView+Extension.swift
//  ViagogoTest
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit


extension UIImageView {
        func imageFromUrl(url: NSURL) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        self.image = UIImage(data: imageData)
                    } else {
                        self.image = UIImage(named: "placeholder")
                    }
                }
            }
        }
    
    
