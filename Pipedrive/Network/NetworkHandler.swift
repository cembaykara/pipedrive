//
//  NetworkHandler.swift
//  Pipedrive
//
//  Created by Baris Cem Baykara on 05.12.2021.
//

import Foundation

class NetworkHandler {
    
    //MARK: TODO - Bring URLComponents scheme here maybe have a singleton
    
    func fetch<T: Decodable>(from endpoint: PipedriveEndpoint, completion: @escaping (T?,FetcherError?) -> ()) {
        
        let companyCreds = CompanyCredentials()
        var url = ""
        let apiToken = companyCreds.apiToken
        let domain = companyCreds.companyDomain
        
        switch endpoint {
        case .persons:
            url =  "https://\(domain).pipedrive.com/api/v1/persons/?api_token=\(apiToken)"
        }
        
        guard let remoteUrl = URL(string: url) else {return}
        URLSession.shared.dataTask(with: remoteUrl) { (receivedData, response, err) in

            DispatchQueue.main.async {

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, .requestFailed)
                    return}

                if httpResponse.statusCode == 200 {

                    guard let receivedData = receivedData else {
                        completion(nil, .invalidData)
                        return }

                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let object = try decoder.decode(T.self, from: receivedData)
                            completion(object, nil)
                        } catch {
                            //print(String(data: receivedData, encoding: .utf8))
                           completion(nil, .jsonConversionFailed)
                        }
                    
                }else {
                    completion(nil, .responseUnsuccessfull)
                }
            }
            
        }.resume()
    }
}


enum PipedriveEndpoint: String {
    case persons
    
}

enum FetcherError{
    case requestFailed
    case jsonConversionFailed
    case invalidData
    case responseUnsuccessfull
    
    var description: String {
        switch self {
        case .requestFailed:
            return "Request Failed"
        case .jsonConversionFailed:
            return "JSON Conversion Failed"
        case .invalidData:
            return "Received Invalid Data"
        case .responseUnsuccessfull:
            return "Response was unsuccesful"
        }
    }
}
