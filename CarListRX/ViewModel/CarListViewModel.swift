//
//  ViewModel.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 14/10/22.
//

import RxSwift
import Swinject

final class CarListViewModel{

    @Inject
    private var apiWorker: NetWorkerProtocol
    @Inject
    private var persistenceWorker: PersistenceWorkerProtocol
    @Inject
    private var dataWorker:DataWorkerProtocol
    @Published var viewObject:PublishSubject<[ViewData]> = .init()
    public let netWorkError: PublishSubject<API.ErrorType> = .init()
    public let loading: PublishSubject<Bool> = .init()
    private let disposeBag = DisposeBag()

    func getCarListFromAPI(){
        self.loading.onNext(true)
        self.apiWorker.resultPublisher
            .map{[weak self] item->[ViewData]? in
                guard let self = self else{
                    return nil
                }
                return self.dataWorker.processViewDataFrom(articles: item)
            }
            .subscribe(onNext: {[weak self] data in
                guard let data = data, let self = self else{return}
                self.loading.onNext(false)
                self.viewObject.onNext(data)
            }, onError: {
                print($0)
//                guard let self = self else{return}
//                self.resultPublisher.onError($0)
            }, onCompleted: {
//                guard let self = self else{return}
//                self.resultPublisher.onCompleted()
            })
            .disposed(by: disposeBag)
        self.apiWorker.requestForDomainData()
    }
    func getCarListFromLocalDB(){
//        self.loading.onNext(true)
        self.persistenceWorker.publisher
            .map{ [unowned self] data in
                self.dataWorker.processViewDataFrom(cars: data)
            }
            .subscribe(onNext: {[unowned self] data in
                self.viewObject.onNext(data)
            }, onError: {
                print($0)
            }, onCompleted: {
                print("completed")
            })
            .disposed(by: disposeBag)
        self.persistenceWorker.getDomainData()
    }
}
