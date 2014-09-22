//
//  RADSharedManager.swift
//  Radicles
//
//  Created by William Tachau on 9/17/14.
//  Copyright (c) 2014 Radicles. All rights reserved.
//
import UIKit

func UIColorFromRGB(red: Int, green:Int, blue:Int) -> UIColor {
    return UIColor(
        red: CGFloat(red) / 255.0,
        green: CGFloat(green) / 255.0,
        blue: CGFloat(blue) / 255.0,
        alpha: CGFloat(1.0)
    )
}

let darkGreen = UIColorFromRGB(38,127,45)
let backgroundColor = UIColorFromRGB(61, 204, 72)
let buttonColor = UIColorFromRGB(153, 255, 161)