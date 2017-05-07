//
//  UIImageView+Extension.swift
//  GeoApp
//
//  Created by Alessandro Manni on 14/07/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import UIKit

extension UIImageView {

    func setImageFromURL(_ url: URL?, placeHolder: UIImage, completion: ((Bool) -> Void)?) {
        NetworkManager.fetchData(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    self.image = placeHolder
                    completion?(false)
                case let .success(data):
                    self.image = UIImage(data: data) ?? placeHolder
                    completion?(true)
                }
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


