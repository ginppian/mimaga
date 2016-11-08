//
//  Random.swift
//  mimaga
//
//  Created by ginppian on 02/11/16.
//  Copyright © 2016 ginppian. All rights reserved.
//

import UIKit

class Random: NSObject {

    internal static func getRandZeroA(tope: Int) -> Int {
        //return min + Int(arc4random_uniform(UInt32(max - min + 1)))
        return Int(arc4random() % UInt32(tope))
    }
    
    internal static func get(number: Int, objectsIn arrayString: [String]) -> [String]{
        var selectedObjects = [String]()
        var rand = Int()
        let tope = arrayString.count-1
        
        for _ in 0..<number {
            rand = Int(arc4random() % UInt32(tope))
            let selected = arrayString[rand]
            selectedObjects.append(selected)
        }
        
        return selectedObjects
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
