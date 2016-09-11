//
//  PoliticallService.swift
//  Politicall
//
//  Created by Sahil Ambardekar on 9/10/16.
//  Copyright © 2016 Pennhacks. All rights reserved.
//

import Foundation
import Alamofire

let service = PoliticallService()
public class PoliticallService {
    static var sharedService: PoliticallService {
        return service
    }
    
    let serverIP: String = "http://45.56.103.226"
    
    func createAccount(userID: String, email: String, name: String, completionHandler: (success: Bool) -> Void) {
        let endpoint = "/api/create"
        let url = serverIP + endpoint
        Alamofire.request(.POST, url, parameters: ["id": userID, "email": email, "name": name]).response { (req, response, data, error) in
            completionHandler(success: response!.statusCode == 200)
        }
    }
    
    func login(userID: String, completionHandler: (success: Bool) -> Void) {
        let endpoint = "/api/login"
        let url = serverIP + endpoint
        Alamofire.request(.POST, url, parameters: ["id": userID]).response { (req, response, _, _) in
            if response!.statusCode == 200 {
                completionHandler(success: true)
            } else {
                completionHandler(success: false)
            }
        }
    }
    
    func callDataForUserID(id: String, completionHandler: (success: Bool, pickedUp: Int!, dropped: Int!, total: Int!) -> Void) {
        let endpoint = "/api/calls"
        let url = serverIP + endpoint
        
        Alamofire.request(.GET, url, parameters: ["callerId": id]).responseJSON { response in
            if let value = response.result.value as? [[String: AnyObject]] {
                let calls = value.map { dict in
                    return dict["pickup"] as! Bool
                }
                
                let pickedUpCalls = calls.reduce(0) { current, pickedUp in
                    return (pickedUp ? current + 1 : current)
                }
                
                let droppedCalls = calls.count - pickedUpCalls
                
                completionHandler(success: true, pickedUp: pickedUpCalls, dropped: droppedCalls, total: calls.count)
                
            } else {
                completionHandler(success: false, pickedUp: nil, dropped: nil, total: nil)
            }
        }
    }
    
    func getCallNumber(completion: (success: Bool, number: String!) -> Void) {
        let endpoint = "/api/toCall"
        let url = serverIP + endpoint
        
        Alamofire.request(.GET, url).responseJSON { response in
            if let value = response.result.value?["phone"] as? String {
                completion(success: true, number: value)
            } else {
                completion(success: false, number: nil)
            }
        }
    }
    
    func reportCall(userID: String, duration: String, pickedUp: Bool, name: String, phoneNumber: String, opinion: Opinion, completionHandler: (success: Bool) -> Void) {
        // duration: mm:ss
        
        let endpoint = "/api/call"
        let url = serverIP + endpoint
        
        let parameters: [String: AnyObject] = [
            "id": userID,
            "duration": duration,
            "pickup": pickedUp,
            "name": name,
            "phone": phoneNumber,
            "opinion": opinion.rawValue
        ]
        
        Alamofire.request(.POST, url, parameters: parameters).response { (req, response, _, _) in
            completionHandler(success: response!.statusCode == 200)
        }
    }
    
    func getAverageCallDurationForUser(id: String, completion: (success: Bool, seconds: Int!) -> Void) {
        let endpoint = "/api/average/\(id)"
        let url = serverIP + endpoint
        
        Alamofire.request(.GET, url).responseJSON { response in
            if let value = response.result.value?["seconds"] as? Int where response.response?.statusCode == 200 {
                completion(success: true, seconds: value)
            } else {
                completion(success: false, seconds: nil)
            }
        }
    }
    
}

enum Opinion: String {
    case negative = "Negative"
    case neutral = "Neutral"
    case positive = "Positive"
}
