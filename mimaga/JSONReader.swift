//
//  JSONReader.swift
//  LagunasDeRuidera
//
//  Created by ginppian on 31/08/16.
//  Copyright © 2016 ginppian. All rights reserved.
//

import UIKit

class JSONReader: NSObject {
    /*El archivo tiene que estar en MAIN.BUNDLE*/
    
    //Type: By default ".json"
    //Esta clase solo lee un arreglo de tabla hash
    internal static func readJSONToArrayString(fileName: String, type: String, key: String) -> [String]{
        let type = ".json"
        var arrayForKey = [String]()
        
        if let path = Bundle.main.path(forResource: fileName, ofType: type)
        {
            print("path: \(path)")
            if let jsonData = NSData(contentsOfFile: path)
            {
                print("jsonData: \(jsonData)")
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
                    print("jsonResult: \(jsonResult)")
                    if let hashes: [NSDictionary] = jsonResult as? [NSDictionary]{
                        for hash in hashes {
                            if let item = hash[key] as? String {
                                arrayForKey.append(item)
                                print("item added: \(item)")
                            } else {
                                print("La key: \(key)")
                            }
                        }
                    }
                } catch {
                    print("Error")
                }
            }
        }
        return arrayForKey
    }
}
