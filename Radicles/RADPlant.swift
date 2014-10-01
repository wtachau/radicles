//
//  RADPlant.swift
//  Radicles
//
//  Created by William Tachau on 9/18/14.
//  Copyright (c) 2014 Radicles. All rights reserved.
//

import Foundation

class RADPlant : NSObject {
    
    var PFObjectRef = PFObject(className: "RADPlant")
    
    init(name: String) {
        PFObjectRef["name"] = name
        PFObjectRef["user"] = PFUser.currentUser()
        PFObjectRef.saveInBackground()
        NSLog("finished saving")
    }
    
    init (ref: PFObject) {
        PFObjectRef = ref
    }
    
    override init () {
        
    }
    
    func changeName(name:String) {
        PFObjectRef["name"] = name
        PFObjectRef.saveInBackground()
    }
}