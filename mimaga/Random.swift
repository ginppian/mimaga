//
//  Random.swift
//  mimaga
//
//  Created by ginppian on 02/11/16.
//  Copyright © 2016 ginppian. All rights reserved.
//

import UIKit

class Random: NSObject {

    internal static func getRand0A(tope: Int) -> Int {
        //return min + Int(arc4random_uniform(UInt32(max - min + 1)))
        return Int(arc4random() % UInt32(tope))
    }
}
