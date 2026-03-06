//
//  NetworkError.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 2/24/26.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse //Any reponse that is not a HTTP-URL-RESPONSE
    case badStatus //Any status out side 200 range [200-299] --> [400-499] Unauthorised or not found or bad request
    case failedToDecodeResponse //Failed to decode data from JSON to Post Model
}
