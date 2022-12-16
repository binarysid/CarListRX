//
//  DataWorker.swift
//  Cars
//
//  Created by Linkon Sid on 13/12/22.
//

import Foundation

protocol DataWorkerProtocol{
    func processViewDataFrom(articles:[Article])->[ViewData]
    func processViewDataFrom(cars:[Car])->[ViewData]
}
final class DataWorker:DataWorkerProtocol{
    func processViewDataFrom(articles:[Article])->[ViewData]{
        articles.map{[weak self] item -> ViewData in // convert to domain object for presentation
            var resultDate = ""
            var resultTime = ""
            if let calendar = self?.processDateFrom(item.dateTime.toDate()){
                resultDate = calendar.date
                resultTime = calendar.time
            }
            return ViewData(id:item.id, title: item.title, image: item.image, description: item.ingress, date: resultDate, time: resultTime)
        }
    }
    func processViewDataFrom(cars:[Car])->[ViewData]{
        cars.map{[weak self] item -> ViewData in // convert to domain object for presentation
            var resultDate = ""
            var resultTime = ""
            if let calendar = self?.processDateFrom(item.date){
                resultDate = calendar.date
                resultTime = calendar.time
            }
            return ViewData(id:item.id, title: item.title ?? "", image: item.image, description: item.content?.description ?? "", date: resultDate, time: resultTime)
        }
    }
    private func processDateFrom(_ dateObj:Date?)->(date:String,time:String){
        var presentableTime = ""
        var presentableDate = ""
        if let date = dateObj{
            let time = date.getTime()
            presentableDate = "\(date.getDateOfMonth()) \(date.getMonthName()) \(date.getYearByComparingToCurrent())"
            presentableTime = "\(time.hour):\(time.minute)"
        }
        return (presentableDate,presentableTime)
    }
}
