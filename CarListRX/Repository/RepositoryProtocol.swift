//
//  ReepositoryProtocol.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 9/10/22.
//

//RepositoryProtocol is conformed by all classes that are part of the data repository and returns data to the worker object
protocol RepositoryProtocol {
    associatedtype Request
    associatedtype Output
    func getData(_ request:Request)->Output
}
