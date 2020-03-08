//
//  IEXCloudAPI.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-02-29.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation


struct Symbol:Codable {
    let exchange:String
    let region:String
    let securityName:String
    let securityType:String
    let symbol:String
}

class IEXCloudAPI {
    
    static let shared = IEXCloudAPI()
    
    private let Host = "https://cloud.iexapis.com/stable"
    private let token = "pk_03e4439873e34bcc9aa48865912ad73d"
    
    private let session = URLSession.shared
    
    private init() {

    }
    
    struct EndPoints {
        static let search = "/search"
        static func stockQuote(_ symbol:String) -> String {
            return "/stock/\(symbol)/quote"
        }
        static let stockMarketBatch = "/stock/market/batch"
    }
    
    private func buildURL(_ endpoint:String,_ params:[String:String] = [:]) -> URL? {
        var str = Host + endpoint + "?token=\(token)"
        for (key, value) in params {
            str += "&\(key)=\(value)"
        }
        return URL(string: str)
    }
    
    func searchSymbols(_ fragment:String, completion: @escaping ((_ query:String, _ results:[Symbol]) -> ())) {
        guard let query = fragment.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = buildURL(EndPoints.search + "/" + query) else {
            return completion(fragment, [])
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
            var results = [Symbol]()
            do {
                //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                results = try JSONDecoder().decode([Symbol].self, from: data)
                
            } catch {
                print("Error: \(error)")
            }
            
            DispatchQueue.main.async {
                return completion(fragment, results)
            }
            
            
        }
        task.resume()
        
    }
    

}



