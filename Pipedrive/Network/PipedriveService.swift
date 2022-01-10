//
//  PipedriveService.swift
//  Pipedrive
//
//  Created by Baris Cem Baykara on 09.01.2022.
//

import Foundation

final class PipedriveService {
    
    static let shared = PipedriveService()
    
    func request<T: Decodable>(from endpoint: PipedriveEndpoint, completion: @escaping (T?,Error?)->()){
        guard let filePath = Bundle.main.path(forResource: "PipedriveService-Info", ofType: "plist") else {
            completion(nil,PipedriveServiceError.resourceNotFound)
            return
        }
        
        let servicePlist = NSDictionary(contentsOfFile: filePath)
        
        guard let key = servicePlist?.object(forKey: "API_KEY") as? String else {return}
        guard let domain = servicePlist?.object(forKey: "COMPANY_DOMAIN") as? String else {return}
       
        let credentials = ["API_KEY":key, "COMPANY_DOMAIN": domain]
        let request = PipeDriveRequest(from: endpoint, withCredentials: credentials)
        
        NetworkHandler.shared.fetch(from: request.url) { (receivedData, error) in
            guard let receivedData = receivedData else {
                if let error = error {
                    print("\(error.description)")
                }
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let object = try decoder.decode(T.self, from: receivedData)
                completion(object,nil)
            } catch {
                completion(nil,FetcherError.jsonConversionFailed)
            }
        }
    }
}

struct PipeDriveRequest {
    
    private let base : String = "pipedrive.com/api"
    private let endpoint : PipedriveEndpoint
    private let credentials : [String:String]
    
    var url : String {
        guard let domain = credentials["COMPANY_DOMAIN"], let key = credentials["API_KEY"] else {
            debugPrint("Invalid Creds")
            return ""
        }
        return "https://\(domain).\(base)\(endpoint.description)/?api_token=\(key)"
    }

    init(from endpoint : PipedriveEndpoint, withCredentials : [String:String]) {
        self.endpoint = endpoint
        self.credentials = withCredentials
    }
}

enum PipedriveEndpoint : String {
    case persons
    
    var description: String {
        switch self {
        case .persons :
            return "/v1/persons"
        }
    }
}

enum PipedriveServiceError: Error {
    case resourceNotFound
    case invalidData
    
    var description: String {
        switch self {
        case .resourceNotFound:
            return "Resource not found"
        case .invalidData:
            return "Invalid Data"
        }
    }
}
