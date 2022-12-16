//
//  PersistenceWorker.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 6/11/22.
//

import RxSwift

protocol PersistenceWorkerProtocol{
    var publisher:PublishSubject<[Car]>{
        get set
    }
    func getDomainData()
    func save(_ data:[Article])
}
final class PersistenceWorker:PersistenceWorkerProtocol{
    
    var publisher:PublishSubject<[Car]> = .init()
    var peresistenceRepository = PersistenceRepository()
    private var disposeBag = DisposeBag()
    
    func getDomainData() {
        let fetchRequest = Car.fetchRequest()
        self.peresistenceRepository.getData(fetchRequest)
            .subscribe(onNext: {[unowned self] data in
                self.publisher.onNext(data)
                
            }, onError: {[unowned self] in
                self.publisher.onError($0)
            }, onCompleted: {[unowned self] in
                self.publisher.onCompleted()
            })
            .disposed(by: disposeBag)
    }
    func save(_ data: [Article]) {
        for item in data{
            saveCarList(item)
        }
    }
}

extension PersistenceWorker{
    func saveCarList(_ item:Article){
        let action: Action = {
            let car:Car = self.peresistenceRepository.createEntity()
            car.id = item.id
            car.title = item.title
            car.ingress = item.ingress
            car.date = item.dateTime.toDate()
            car.tags = item.tags.joined(separator: ",")
            car.image = item.image
//            car.content = item.c
        }
        self.peresistenceRepository.create(save: action)
            .subscribe( onError: {
                print($0)
            }, onCompleted: {
                print("success")
            })
            .disposed(by: disposeBag)
    }
}
