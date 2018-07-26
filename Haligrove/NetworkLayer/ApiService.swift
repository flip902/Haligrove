//
//  ApiService.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class ApiService {
    
    static var shared = ApiService()
    
    // Fetch Strains from url
    func fetchJson<T: Decodable>(from urlString: String, completion: @escaping ([T]) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        URLSession(configuration: config).dataTask(with: url) { (data, res, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed: ", err)
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode([T].self, from: data)
                    completion(data)
                } catch let jsonErr {
                    print("Failed: ", jsonErr)
                }
            }
            }.resume()
    }
}

