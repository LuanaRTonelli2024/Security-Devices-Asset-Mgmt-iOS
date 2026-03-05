//
//  WebService.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 2/24/26.
//

import Foundation
import SwiftUI

//for the core API operations: GET, POST, PUT/PATCH, DELETE

//T --> template or a placeholder structure
//after validation of T we can store it as a Model [POST]

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH //GET, POST, PUT, DELETE
}


class WebService {
    
    @AppStorage("token")  var token: String = ""
    
    //Generic Send Request
    func sendRequest<T: Codable>(
        fromUrl: String,
        method: HTTPMethod,
        body: T? = nil) async -> T? {
            do {
                guard let url = URL(string: fromUrl) else{
                    throw NetworkError.badUrl
                }
                
                //create request
                var request = URLRequest(url: url)
                request.httpMethod = method.rawValue //GET, POST, PUT, DELETE
                
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                //check body
                if let body = body{
                    request.httpBody = try JSONEncoder().encode(body)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
                
                //send the request
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.badResponse
                }
                
                guard 200..<300 ~= response.statusCode else {
                    throw NetworkError.badStatus
                }
                
                print("\(method): \(url) [\(response.statusCode)]")
                
                if method.rawValue == "DELETE" {
                    return nil
                } else {
                    //decode data
                    return try JSONDecoder().decode(T.self, from: data)
                    //data -> nil catch (printed) return nil
                    //delete method --> decode {} --> Post
                }
                
            } catch{
                print(error.localizedDescription)
                return nil //by default it will return nil
            }
        }
    
    //Methode: GET
    func downloadData<T: Codable>(fromURL: String) async -> T? {
        do {
            guard let url = URL(string: fromURL)
            else {
                throw NetworkError.badUrl
            }
            let (data, response) = try await URLSession.shared.data(from: url) //Fetching information from the url
            guard let response = response as? HTTPURLResponse
            else {
                throw NetworkError.badResponse
            }
            guard response.statusCode >= 200 && response.statusCode < 300
            else {
                throw NetworkError.badStatus
            }
            //store it in a T
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data)
            else {
                throw NetworkError.failedToDecodeResponse
            }
            
            return decodedResponse
            
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        }
        catch NetworkError.badResponse {
            print("Did not get a valid response")
        }
        catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        }
        catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        }
        catch {
            print("An error occured downloading the data")
        }
        
        return nil
    }
}
