//
//  GriffinImage.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/28.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

class GriffinImageManager {
    
    private let imageCache = GriffinCache.init(name: "image")
    
    static let instance = {
        return GriffinImageManager()
    }()
    
    func setImage(_ object: UIImage, for key: String) {
        imageCache.setObject(object, for: key)
    }
    
    func image(for key: String) -> UIImage? {
        return imageCache.object(for: key) as? UIImage
    }
}

extension UIImageView {
    func setGriffinImage(with urlString: String) {

        // find in mem.
        // find in disk.
        if let image = GriffinImageManager.instance.image(for: urlString) {
            self.image = image
            return
        }
        
        // download
        guard let url = URL(string: urlString) else {
            return
        }
        
        let downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            if error != nil {
                return
            }

            guard let url = url, let data = try? Data.init(contentsOf: url) else {
                return
            }

            DispatchQueue.main.async {
                let image = UIImage.init(data: data)
                GriffinImageManager.instance.setImage(image!, for: urlString)
                self.image = image
            }
        }
        downloadTask.resume()
    }


}

