//
//  APIClient.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

import RxSwift
import Foundation
final class APIRepository:APIClientProtocol{
    func getData(_ request:URLRequest) -> Observable<ArticleData> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: request) { (data,response, error) in
              if let httpResponse = response as? HTTPURLResponse{
              let statusCode = httpResponse.statusCode
              do {
                  guard let data = data else{
                      return
                  }
                if statusCode == 200 {
                  let articleData = try JSONDecoder().decode(ArticleData.self, from:data)
                  //MARK: observer onNext event
                  observer.onNext(articleData)
                }
                else {
                  observer.onError(error!)
                }
              } catch {
                  //MARK: observer onNext event
                  observer.onError(error)
                 }
               }
                 //MARK: observer onCompleted event
                 observer.onCompleted()
               }
             task.resume()
             //MARK: return our disposable
             return Disposables.create {
               task.cancel()
             }
        }
    }
}
