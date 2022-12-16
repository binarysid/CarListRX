//
//  AppConstants.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 14/10/22.
//

import Foundation

enum AppConstants{
    enum Config{
        static var APPID:String{
            guard let id = Bundle.main.infoDictionary?["APP_ID"] as? String else{ return ""}
            return id
        }
    }
}
