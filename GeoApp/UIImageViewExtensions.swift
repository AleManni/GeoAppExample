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
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            DispatchQueue.main.async {
                if let imageData = data as Data? {
                    self.image = UIImage(data: imageData) ?? placeHolder
                } else {
                    self.image = placeHolder
                }
            }
        })
        task.resume()
    }

    func setActive() {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = UIColor.white
    }

    func setInactive() {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}


