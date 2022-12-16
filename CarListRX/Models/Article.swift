//
//  Article.swift
//  Cars
//
//  Created by Linkon Sid on 11/12/22.
//

struct Article:Codable{
    let id: Int64
    let title: String
    let ingress: String
    let image: String
    let dateTime: String
    let tags: [String]
    let content:[Item]
    let created: Int64
    let changed: Int64
}
