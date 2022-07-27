//
//  AdressModel.swift
//  Penny
//
//  Created by Alan S Mathew on 27/07/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let adressModel = try? newJSONDecoder().decode(AdressModel.self, from: jsonData)

import Foundation

// MARK: - AdressModel
struct AdressModel: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let providedLocation: ProvidedLocation?
    let locations: [Location]?
}

// MARK: - Location
struct Location: Codable {
    let street, adminArea6, adminArea6Type, adminArea5: String?
    let adminArea5Type, adminArea4, adminArea4Type, adminArea3: String?
    let adminArea3Type, adminArea1, adminArea1Type, postalCode: String?
    let geocodeQualityCode, geocodeQuality: String?
    let dragPoint: Bool?
    let sideOfStreet, linkID, unknownInput, type: String?
    let latLng, displayLatLng: LatLng?
    let mapURL: String?

}

// MARK: - LatLng
struct LatLng: Codable {
    let lat, lng: Double?
}

// MARK: - ProvidedLocation
struct ProvidedLocation: Codable {
    let latLng: LatLng?
}

