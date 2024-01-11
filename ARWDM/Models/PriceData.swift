//
//  Prices.swift
//  ARWDM
//
//  Created by Robin Konijnendijk on 11/01/2024.
//

import Foundation


struct PriceData: Codable {
    var prices: [String: [String: Float]]
    
    static func fetchPriceData(completion: @escaping (PriceData?) -> Void) {
        let urlString = "https://raw.githubusercontent.com/Raamdeluxe/blindsar/main/data/price.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let priceData = try JSONDecoder().decode(PriceData.self, from: data)
                completion(priceData)
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func priceFor(roundedHeight: Int, roundedWidth: Int) -> Float? {
        let heightKey = "\(roundedHeight)"
        let widthKey = "\(roundedWidth)"
        
        return prices[heightKey]?[widthKey]
    }
    
}
