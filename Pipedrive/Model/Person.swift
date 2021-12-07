//
//  Person.swift
//  Pipedrive
//
//  Created by Baris Cem Baykara on 05.12.2021.
//

import Foundation
//MARK: TODO: Name Stuff better
// Study the results of endpoints and create better model data maybe add core data to store instead
struct Person: Codable {
    
    var data: [Object]?
}

struct Email: Codable {
    var value: String?
}

struct Phone: Codable {
    var value: String?
}

struct Object: Codable {
    var name: String?
    var firstName: String?
    var lastName: String?
    var phone: [Phone]?
    var email: [Email]?
}
