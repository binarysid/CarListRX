//
//  PersistenceRepository.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 13/10/22.
//


import CoreData
import RxSwift

typealias Action = (()->())
protocol CustomError:Error{
    var notFound:Self{get}
    var duplicate:Self{get}
}
enum PersistenceRepoError: CustomError {
    case notFound
    case duplicate
    case invalidManagedObjectType
    
    var notFound: PersistenceRepoError{
        .notFound
    }
    
    var duplicate: PersistenceRepoError{
        .duplicate
    }
}
protocol EntityCreating{
    var context:NSManagedObjectContext { get }
    func createEntity<T:NSManagedObject>()->T
}
extension EntityCreating{
    func createEntity<T:NSManagedObject>()->T{
        return T(context: context)
    }
}
protocol CoreDataCreateModelPublishing {
    var context: NSManagedObjectContext { get }
    func create(save action: @escaping Action) -> Observable<Void>
}

protocol PersistenceStoring:EntityCreating,CoreDataCreateModelPublishing,RepositoryProtocol{
    
}


final class PersistenceRepository:PersistenceStoring{
    
    typealias Request = NSFetchRequest<Car>
    typealias Output = Observable<[Car]>
    var context: NSManagedObjectContext{
        return PersistenceService.context
    }
    func getData(_ request: NSFetchRequest<Car>) -> Observable<[Car]> {
        return Observable.create{[unowned self] observer in
            do {
                let result = try self.context.fetch(request) as [Car]
                if result.count>0{
                    observer.onNext(result)
                }
                else{
                    observer.onError(PersistenceRepoError.notFound)
                }
            } catch  {
                observer.onError(PersistenceRepoError.invalidManagedObjectType)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    func create(save action: @escaping Action) -> Observable<Void> {
        return Observable.create{observer in
            action()
            do{
                try PersistenceService.saveContext()
                observer.onCompleted()
            }
            catch let error as PersistenceRepoError{
                observer.onError(error)
            }
            catch let err{
                observer.onError(err)
            }
            return Disposables.create()
        }
    }
}
