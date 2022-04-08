//
//  PostManager.swift
//  correWatch WatchKit Extension
//
//  Created by Lucas Morehouse on 4/8/22.
//
//  Adapted from: https://github.com/Kilo-Loco/URLSessionJSONRequests/blob/master/URLSessionJSONRequests/ViewController.swift
//

import Foundation


final class PostManager {
    
    //MARK: parameter should be formatted as:
    //MARK: parameter = ["key":"value","key":"value",...]
    func post(parameter: Any, url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
    }
}
