//
//  Models.swift
//  finalproject
//
//  Created by Sydney Blakeman on 8/1/22.
//

//this file for dates 

import Foundation
import Dispatch

struct ChartData: Codable {
    struct ChartModel: Codable {
        struct ResultModel: Codable {
            let timestamp: [Int]
            struct IndicatorsModel: Codable {
                struct QuoteModel: Codable {
                    let open: [Double]
                    let low: [Double]
                    let volume: [Double]
                    let close: [Double]
                    let high: [Double]
                }
                let quote: [QuoteModel]
            }
            let indicators: IndicatorsModel
        }
        let result: [ResultModel]
    }
    let chart: ChartModel
    
    var open: [Double] {
        chart.result.first!.indicators.quote.first!.open
    }
    
    var timestamp: [TimeInterval] {
        chart.result.first!.timestamp.map { TimeInterval($0) }
    }
}

func getCharData(ticker: String, completionHandler: @escaping (ChartData)->Void){
    var chart: ChartData!

    let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(ticker)?interval=1d&range=1mo")!
    let request = URLRequest(url: url)
    
    let sem = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        if let data = data {
            do {
                defer { sem.signal() }
                try chart = JSONDecoder().decode(ChartData.self, from: data)
                completionHandler(chart)
            } catch {
                print(error)
            }
        }
    }
    task.resume()
    
    sem.wait()
}

struct QuoteData: Codable {
    struct QuoteModel: Codable {
        struct ResultModel: Codable {
            struct StatisticsModel: Codable {
                struct ValueModel: Codable {
                    let raw: Double?
                }
                let enterpriseValue: ValueModel?
                let sharesOutstanding: ValueModel?
                let priceToBook: ValueModel?
                let trailingEps: ValueModel?
                let enterpriseToRevenue: ValueModel?
                let debtToEquity: ValueModel?
                let returnOnEquity: ValueModel?
            }
            let defaultKeyStatistics: StatisticsModel?
            let financialData: StatisticsModel?
        }
        let result: [ResultModel]
    }
    let quoteSummary: QuoteModel
    
    var dataSet: String!
    
    var data: QuoteModel.ResultModel.StatisticsModel {
        if let data = quoteSummary.result.first!.defaultKeyStatistics {
            return data
        } else {
            return quoteSummary.result.first!.financialData!
        }
    }
}

enum QuoteDataSelection: String {
    case defaultKeyStatistics = "defaultKeyStatistics"
    case financialData = "financialData"
    
}

extension QuoteData {
    struct ExtractedData {
        var P_E: Double
        var P_Bv: Double
        var Debt_Equity: Double
        var P_S: Double
        var ROE: Double
    }
        
    static func getExtractedData(ticker: String) -> [Double] {
        let today = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: .now)
        
        var defaultKeyStatistics: QuoteData!
        var financialData: QuoteData!
        
        getQuoteData(ticker: ticker, dataSet: .defaultKeyStatistics) {
            defaultKeyStatistics = $0
        }
        
        getQuoteData(ticker: ticker, dataSet: .financialData) {
            financialData = $0
        }

        let result:[Double] = [
            (defaultKeyStatistics.data.enterpriseValue?.raw ?? .nan) / (defaultKeyStatistics.data.sharesOutstanding?.raw ?? .nan) / (defaultKeyStatistics.data.trailingEps!.raw ?? .nan),
            (defaultKeyStatistics.data.priceToBook?.raw ?? .nan),
            (financialData.data.debtToEquity?.raw ?? .nan),
            (defaultKeyStatistics.data.enterpriseToRevenue?.raw ?? .nan) / (defaultKeyStatistics.data.enterpriseValue?.raw ?? .nan) * (defaultKeyStatistics.data.sharesOutstanding?.raw ?? .nan),
            (financialData.data.returnOnEquity?.raw ?? .nan)
        ]

        return result
    }

    static func getNormalizedData(source data: [Double], targets: [Double?]) -> Double {
        var values = [Double]()

        for (datum, target) in zip(data, targets) {
            if let target = target {
                values.append((target - datum) * (target - datum) / datum)
            }
        }
        
//        let zipped = Array(zip(data, targets))
//
//        let values = zipped.compactMap { (datum, target) in
//            target == nil ? nil : ((target - datum) * (target - datum) / datum)
//        }

        return values.stddev() / Double(values.count)
    }
}

func getQuoteData(ticker: String, dataSet: QuoteDataSelection, completionHandler: @escaping ((QuoteData)->Void)) {
    print("Getting data for \(ticker):\(dataSet)")
    var quote: QuoteData = .init(quoteSummary: .init(result: []), dataSet: "")
    
    let url = URL(string: "https://query1.finance.yahoo.com/v10/finance/quoteSummary/\(ticker)?modules=\(dataSet)")!
    let request = URLRequest(url: url)
    
    let sem = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        if let data = data {
            do {
                defer { sem.signal() }
                try quote = JSONDecoder().decode(QuoteData.self, from: data)
                quote.dataSet = dataSet.rawValue
                completionHandler(quote)
            } catch {
                print(error)
                print(String(decoding: data, as: UTF8.self))
            }
        }
    }
    task.resume()
    
    sem.wait()
}
