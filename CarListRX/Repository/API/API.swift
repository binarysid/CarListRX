//
//  API.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 2/11/22.
//

import Foundation
struct API{
    enum HTTPMethods{
        static let GET = "GET"
        static let POST = "POST"
    }
    enum ErrorType:Error{
        case Service
        case BadURL
        case NoDataFound
        case duplicate
        case invalidResponse(URLResponse?)
        case invalidJSON(Error)
        var notFound: API.ErrorType{
            .NoDataFound
        }
        
        var duplicate: API.ErrorType{
            .duplicate
        }
        
        var errorDescription: String? {
          switch self {
          case .Service: return "Service unreachable"
          case .BadURL: return "Invalid URL"
          case .NoDataFound: return "No data found"
          case .duplicate: return "Duplicate found"
          case .invalidResponse(let err): return err?.description
          case .invalidJSON(let err): return err.localizedDescription
          }
        }
    }
    enum EndPoints{
        static let baseURL = "https://" + Config.stringValue(forKey: "BASE_URL")
        case carlist
        var url:URL?{
            switch self{
            case .carlist:
                let url = EndPoints.baseURL + "carlist"
                guard let urlComponents = URLComponents(string: url) else{
                    return nil
                }
                guard let urlStr = urlComponents.url else{
                    return nil
                }
                return urlStr
            }
        }
    }
}
