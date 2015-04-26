//
//  Router.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/06.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "https://www.googleapis.com/youtube/v3"
    static let kGoogleAPIKey = "AIzaSyBtW-zJkAl2Y7_2Z_AoJdmYovDWRJ1oGvE"
    
    // github.com/Alamofire/Alamofire#api-parameter-abstraction
    case MostPopular(pageToken: String?)
    case Search(channelId: String?, pageToken: String?)
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            
            switch self {
            case .MostPopular(let pageToken):
                var parameters: [String: AnyObject] = [
                    "key": Router.kGoogleAPIKey,
                    "part": "snippet",
                    "chart": "mostPopular",
                    "maxResults": 20,
                ]
                
                if pageToken != nil {
                    parameters["pageToken"] = pageToken
                }
                
                return (.GET, "/videos", parameters)
            
            case .Search(let channelId, let pageToken):
                var parameters: [String: AnyObject] = [
                    "key": Router.kGoogleAPIKey,
                    "part": "snippet",
                    "order": "date",
                    "maxResults": 20,
                ]
                
                if channelId != nil {
                    parameters["channelId"] = channelId
                }
                
                if pageToken != nil {
                    parameters["pageToken"] = pageToken
                }
                
                return (.GET, "/search", parameters)
            }
        }()
        
        let encoding = Alamofire.ParameterEncoding.URL
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest =
            NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        return encoding.encode(mutableURLRequest, parameters: parameters).0
    }
}
