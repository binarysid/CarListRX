//
//  APIClientProtocol.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

import RxSwift
import Foundation

protocol APIClientProtocol:RepositoryProtocol where Request == URLRequest, Output == Observable<ArticleData>{
    func getData(_ request:URLRequest) -> Observable<ArticleData>
}
