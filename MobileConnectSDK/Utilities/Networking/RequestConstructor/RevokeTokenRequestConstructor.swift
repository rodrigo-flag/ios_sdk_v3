//
//  RevokeTokenRequestConstructor.swift
//  MobileConnectSDK
//
//  Created by Mircea Grecu on 22/09/2016.
//  Copyright © 2016 GSMA. All rights reserved.
//

import Foundation
import Alamofire

private let kTokenKey : String = "token"
private let kTokenHintTypeKey : String = "token_type_hint"
private let kTokenHintTypeRefreshValue : String = "refresh_token"

class RevokeTokenRequestConstructor : NSObject {
    
    func generateRevokeRequest(_ withURL: String, withTokenId token : String, isRefreshToken : Bool, clientID : String?, clientSecret : String?) -> Request {
        
        var parameters : Dictionary = [kTokenKey : token]
        
        if isRefreshToken {
            parameters[kTokenHintTypeKey] = kTokenHintTypeRefreshValue
        }
        
        let credentialsString : String
        
        if let clientID = clientID, let clientSecret = clientSecret {
            credentialsString = "\(clientID):\(clientSecret)"
        } else {
            credentialsString = "\(MobileConnectSDK.getClientKey()):\(MobileConnectSDK.getClientSecret())"
        }
        
        var headers : Dictionary = ["Content-Type":"application/x-www-form-urlencoded"]
        
        if let encodedData : Data = credentialsString.data(using: String.Encoding.utf8)
        {
            let encodedCredentials : String = encodedData.base64EncodedString(options: [])
            headers["Authorization"] = "Basic \(encodedCredentials)"
        }
        
        return request(withURL, method: .post, parameters: parameters, encoding: URLEncoding.methodDependent, headers: headers)
    }    
}
