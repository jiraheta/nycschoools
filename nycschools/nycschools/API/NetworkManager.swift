//
//  NetworkManager.swift
//  nycschools
//
//  Created by Jportdev on 6/12/21.
//

import Foundation
/*
  TODO: - move all the service call to this file.
 */
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

//enum ErrorResponse: Error {
//    case badUrl
//    case badParameters
//    case Unknown
//
//    var localizedDescription: String {
//        switch self {
//        case .badUrl:
//            return "Bad Url"
//        case .badParameters:
//            return "Bad parameters"
//        case .Unknown:
//            return "Unkwon error"
//        }
//    }
//}

//struct NetworkCall {
//    let api: String
//    let method: HTTPMethod
//    //let parameters: [String: Any]?
//    //let headers: [String: String]?
//
//    init(api: Api,
//         method: HTTPMethod = HTTPMethod.get)//,
//         //parameters: [String: Any]? = nil,
//         //headers: [String: String]? = nil)
//    {
//        self.api = api.rawValue
//        self.method = method
//        //self.parameters = parameters
//        //self.headers =  headers
//
//    }
//}
    
class NetworkManager {
    static let shared = NetworkManager()
    private var SchoolList = [SchoolModel]()

    func returnListOfSchools() -> [(SchoolModel)] {
        SchoolListNetworkCall()
        print(self.SchoolList)
        return self.SchoolList
    }
    
    func SchoolListNetworkCall(){
        // Create URL
        let url = URL(string: Api.schools.rawValue)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = HTTPMethod.get.rawValue
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data {
                //print("Response data string:\n \(dataString)")
                do{
                let decode = JSONDecoder()
                self.SchoolList = try decode.decode([SchoolModel].self, from: data)
                } catch {
                    print("error: \(error)")
                }
            }
        }
        task.resume()
        
        
    }
    
    func SchoolInfoNetworkCall(dbn: String) -> [(SchoolModel)]{
        var SchoolList = [SchoolModel]()
        // Create URL
        let url = URL(string: "\(Api.school_details)?dbn=\(dbn)")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = HTTPMethod.get.rawValue
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                //print("Response data string:\n \(dataString)")
                do{
                let decode = JSONDecoder()
                let SchoolList = try decode.decode([SchoolModel].self, from: data)
                
                } catch {
                    print("error: \(error)")
                }
                
            }
        }
        task.resume()
        return SchoolList
    }

}// end of Network

// MARK: - Dev Comments
/*
  This was las thing I try to coding... having the VCs make a singleton of this class to make
  the calls.
 */
