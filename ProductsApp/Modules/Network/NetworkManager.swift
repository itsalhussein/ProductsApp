//
//  APIManager.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 17/12/2022.
//

import Foundation
enum NetworkError : Error {
    case timeOut
    case invalidURL
}

class ProductsService {
    
    static func getData(completionHandler : @escaping (Result<[ProductsResponseModel], NetworkError>) -> ()) {
        
        guard let url = URL(string: "https://api.jsonserve.com/fHAbLZ") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                completionHandler(.failure(.timeOut))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([ProductsResponseModel].self, from: data!)
                
                DispatchQueue.main.async {
                    completionHandler(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(.invalidURL))
                }
            }
        }.resume()
        
    }
}
