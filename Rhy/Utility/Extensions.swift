//
//  Extensions.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 28.02.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

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

// Color palette

extension UIColor {
    
    @nonobjc class var lightblue: UIColor {
        return UIColor(red: 91.0 / 255.0, green: 195.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var darkSeafoamGreen: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 178.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dustyOrange: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 100.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var battleshipGrey: UIColor {
        return UIColor(red: 120.0 / 255.0, green: 121.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dark: UIColor {
        return UIColor(red: 29.0 / 255.0, green: 31.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var white: UIColor {
        return UIColor(white: 216.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var perrywinkle: UIColor {
        return UIColor(red: 159.0 / 255.0, green: 159.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
    
}

// Text styles

extension UIFont {
    
    class var textStyle: UIFont {
        return UIFont(name: "HelveticaNeue-Thin", size: 60.0)!
    }
    
}

extension CGFloat{
    var abs : CGFloat{
        get{
            return (self > 0 ? self : -self)
        }
    }
}

extension SKShapeNode{
    func setColor(line: Int){
        switch line{
        case 0:
            self.fillColor = UIColor.lightblue
            self.strokeColor = UIColor.lightblue
        case 1:
            self.fillColor = UIColor.darkSeafoamGreen
            self.strokeColor = UIColor.darkSeafoamGreen
        case 2:
            self.fillColor = UIColor.dustyOrange
            self.strokeColor = UIColor.dustyOrange
        default:
            ()
        }
    }
}

extension Int {
    var double : Double{
        get{
            return Double(self)
        }
    }
}

extension Double {
    var int : Int{
        get{
            return Int(self)
        }
    }
}
