//
//  NetworkHandler.swift
//  Pipedrive
//
//  Created by Baris Cem Baykara on 05.12.2021.
//

import Foundation

protocol Endpoint {
    func prepare() -> String
}

//MARK: TODO-Migrate to OAuth
class NetworkHandler {
    
    //MARK: TODO - Bring URLComponents scheme here maybe have a singleton
    func fetch<T: Decodable>(from endpoint: Endpoint, completion: @escaping (T?,FetcherError?) -> ()) {
        
        guard let remoteUrl = URL(string: endpoint.prepare()) else {return}
        URLSession.shared.dataTask(with: remoteUrl) { (receivedData, response, err) in

            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, .requestFailed)
                    return}
                
                if httpResponse.statusCode == 200 {
                    guard let receivedData = receivedData else {
                        completion(nil, .invalidData)
                        return }
                    //MARK: TODO - Seperate decoding and couple with model
                    do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let object = try decoder.decode(T.self, from: receivedData)
                            completion(object, nil)
                        } catch {
                           completion(nil, .jsonConversionFailed)
                        }
                }else {
                    completion(nil, .responseUnsuccessfull)
                }
            }
        }.resume()
    }
}

enum PipedriveEndpoint : String, Endpoint {
    case persons
    
    var base: String {
        return "pipedrive.com/api"
    }
    
    var endpoint: String {
        switch self {
        case .persons :
                return "/v1/persons"
        }
    }
    
    var creds: [String : Any]? {
        get {
            guard let filePath = Bundle.main.path(forResource: "Service-Info", ofType: "plist") else {
              fatalError("Couldn't find file 'Service-Info.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let key = plist?.object(forKey: "API_KEY") as? String else {
              fatalError("Couldn't find key 'API_KEY' in 'Service-Info.plist'.")
            }
            guard let domain = plist?.object(forKey: "COMPANY_DOMAIN") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'Service-Infoplist'.")
              }
            
            if (domain.isEmpty || key.isEmpty){
                print("'API_KEY' or 'COMPANY_DOMAIN' is not set")
            }
            return ["API_KEY":key, "COMPANY_DOMAIN": domain]
        }
    }
    
    func prepare() -> String {
        if let domain = creds?["COMPANY_DOMAIN"], let token = creds?["API_KEY"]{
        return "https://\(domain)\(base)\(endpoint)\(token)"
        }else{
            return ""
        }
    }
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
            return "Response was Unsuccessful"
        }
    }
}
