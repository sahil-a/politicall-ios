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
    
    let serverIP: String = "http://ec2-52-40-205-19.us-west-2.compute.amazonaws.com"
    
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
    
    //    func getCallNumber(completion: (success: Bool, ))
}
