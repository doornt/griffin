//
//  View.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

private var eventKey: Void?

extension UIView {
    
    var events: Dictionary<String, Array<String>>? {
        get {
            guard let value = objc_getAssociatedObject(self, &eventKey) as? Dictionary<String, Array<String>> else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &eventKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func config(dict:Dictionary<String,Any>){
        
        let w:CGFloat = Utils.any2CGFloat(obj: dict["width"]) ?? 0
        let h:CGFloat = Utils.any2CGFloat(obj: dict["height"]) ?? 0
        let y:CGFloat = Utils.any2CGFloat(obj: dict["top"]) ?? 0
        let x:CGFloat = Utils.any2CGFloat(obj: dict["left"]) ?? 0
        self.frame = CGRect(x: x, y: y, width: w, height: h)
        
        if Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["backgroundColor"])) != nil {
            self.backgroundColor = Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["backgroundColor"]))
        }
        
        self.clipsToBounds = Utils.any2Bool(obj: dict["overflow"]) ?? false
        self.alpha = Utils.any2CGFloat(obj: dict["opacity"]) ?? 1.0
        
        self.layer.borderWidth = Utils.any2CGFloat(obj: dict["borderWidth"]) ?? 0
        
        if Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["borderColor"])) != nil {
            self.layer.borderColor = Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["borderColor"]))!.cgColor
        }

        self.layer.cornerRadius = Utils.any2CGFloat(obj: dict["cornerRadius"]) ?? 0
    
        for child in Utils.any2Array(obj: dict["children"]) {
            let rChild = child as? Dictionary<String, Any>
            guard let realChild = rChild else {
                continue
            }
            let childView: View = View(dict: realChild)
            addSubview(childView)
        }
        
        self.isUserInteractionEnabled = true
        
        // add tap gensture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let events = self.events, let clicks = events["click"] else {
            return
        }
        for click in clicks {
            JSCoreBridge.instance.executeAnonymousJSFunction(script: click)
        }
    }
    
}

public class View :UIView{
    
    public var id:String?
    
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        self.id = dict["class"] as? String

        config(dict: dict)
    }
    

}

public class Label :UILabel{
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        
        config(dict: dict)
        
        self.text = Utils.any2String(obj: dict["text"])
        
        if Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["textColor"])) != nil {
           self.textColor = Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["textColor"]))
        }
    
        if self.layer.cornerRadius > 0 {
            self.layer.masksToBounds = true
        }
        self.sizeToFit()
    }
}

public class ImageView :UIImageView{
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        
        config(dict: dict)
        
        let url = URL.init(string: "https://op.meituan.net/oppkit_pic/2ndfloor_portal_headpic/157e291c008894a2db841f0dda0d64c.png")!
        guard let data = try? Data.init(contentsOf: url)  else {
            return
        }
        self.image = UIImage.init(data: data, scale: UIScreen.main.scale)
        
        if self.layer.cornerRadius > 0 {
            self.layer.masksToBounds = true
        }
    }
}

