//
//  Extensions.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 28.02.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(hex: String){
        let hex = hex.trimmingCharacters(in: ["#", " "])
        switch hex.count {
        case 6:
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                let b = CGFloat(hexNumber & 0x0000ff) / 255
                let a = CGFloat(255) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        case 8:
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                let r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                let g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                let b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                let a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        default:
            self.init()
            return
        }
        self.init()
    }
}

extension UIImageView{
    func setImageInBackground(url: URL?){
        DispatchQueue.global().async {
            if let url = url{
                
                if let image = ImageCache.Instance.images[url]{
                    DispatchQueue.main.async {
                        self.image = image
                    }
                    return
                }
                
                let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                if let data = data{
                    DispatchQueue.main.async {
                        if let im = UIImage(data: data){
                            ImageCache.Instance.images[url] = im
                            self.image = im
                        }
                    }
                }
                
            }
        }
    }
}

class ImageCache{
    private init(){}
    static let Instance = ImageCache()
    var images : [URL : UIImage] = [:]
}
