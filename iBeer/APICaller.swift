//
//  APICaller.swift
//  iBeer
//
//  Created by Francisco Javier Gallego Lahera on 16/1/22.
//

import Foundation

struct APICaller {
    static let shared = APICaller()
    
    private let url = URL(string: "https://api.punkapi.com/v2/beers?page=1&per_page=50")!
    
    func fetchBeers(completion: @escaping (Result<[Beer], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode),
                  error == nil else {
                      completion(.failure(APICallerError.requestError))
                      return
                  }
            
            do {
                let decodedBeers = try JSONDecoder().decode([OnlineBeer].self, from: data)
                let convertedBeers = decodedBeers.map { convertOnlineBeerToCustom(onlineBeer: $0) }
                completion(.success(convertedBeers))
            } catch {
                completion(.failure(APICallerError.dataFormatError))
            }
        }
        
        task.resume()
    }
    
    private func convertOnlineBeerToCustom(onlineBeer: OnlineBeer) -> Beer {
        let name = onlineBeer.name
        let abv = onlineBeer.abv
        let calories = Double(Int.random(in: 10...500))
        let beerType = BeerType.allCases[Int.random(in: 0...BeerType.allCases.count-1)]
        
        var data: Data? = nil
        
        if let imageURL = URL(string: onlineBeer.imageURL) {
            data = try? Data(contentsOf: imageURL)
        }
        
        let convertedBeer = Beer(name: name, abv: abv, calories: calories, type: beerType, imageData: data)
        return convertedBeer
    }
}

enum APICallerError: Error {
    case requestError
    case dataFormatError
}
