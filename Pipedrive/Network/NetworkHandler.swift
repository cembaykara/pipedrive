//
//  NetworkHandler.swift
//  Pipedrive
//
//  Created by Baris Cem Baykara on 05.12.2021.
//

import Foundation

//MARK: TODO-Migrate to OAuth
final class NetworkHandler {
    
    static let shared = NetworkHandler()
    
    func fetch(from urlString: String, completion: @escaping (Data?,FetcherError?) -> ()) {
        guard let remoteUrl = URL(string: urlString) else {
            debugPrint("URL creation failed. Tried to make URL out of String: \(urlString)")
            return}
       
        URLSession.shared.dataTask(with: remoteUrl) { (receivedData, response, err) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, .requestFailed)
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    guard let receivedData = receivedData else {
                        completion(nil, .invalidData)
                        return
                    }
                    completion(receivedData,nil)
                }else {
                    completion(nil, .responseUnsuccessfull)
                }
                
            }
        }.resume()
    }
    
    private init(){}
    
}

enum FetcherError : Error{
    case requestFailed
    case jsonConversionFailed
    case invalidData
    case responseUnsuccessfull
    case invalidURL
    
    var description: String {
        switch self {
        case .requestFailed:
            return "Request Failed"
        case .jsonConversionFailed:
            return "JSON Conversion Failed"
        case .invalidData:
            return "Received Invalid Data"
        case .responseUnsuccessfull:
            return "Response was Unsuccessful"
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
