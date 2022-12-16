//
//  APIWorker.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 6/11/22.
//

import RxSwift
import Foundation

protocol NetWorkerProtocol{
    var resultPublisher:PublishSubject<[Article]>{
        get set
    }
    func requestForDomainData()
}
final class APIWorker<T:APIClientProtocol>:NetWorkerProtocol{
    private let disposeBag = DisposeBag()
    var resultPublisher: PublishSubject<[Article]> = .init()
    var apiRepository:T?
    init(client:T) {
        self.apiRepository = client
    }
    func requestForDomainData(){
        guard let url = API.EndPoints.carlist.url else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = API.HTTPMethods.GET
        apiRepository?.getData(urlRequest)
            .subscribe(onNext: {[weak self] data in
                guard let self = self else{return}
                self.resultPublisher.onNext(data.content)
            }, onError: {[weak self] in
                guard let self = self else{return}
                self.resultPublisher.onError($0)
            }, onCompleted: {[weak self] in
                guard let self = self else{return}
                self.resultPublisher.onCompleted()
            })
            .disposed(by: disposeBag)
    }
}
