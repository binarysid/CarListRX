//
//  Config.swift
//  CarListRX
//
//  Created by Linkon Sid on 26/12/22.
//

import Foundation

enum Config {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    static func stringValue(forKey key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String
        else {
          fatalError("Invalid value or undefined key")
        }
        return value
      }
}
