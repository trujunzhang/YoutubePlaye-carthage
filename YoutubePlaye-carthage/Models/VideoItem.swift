//
//  VideoItem.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/06.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

import Foundation
import SwiftyJSON

class VideoItem: RLMObject {
    dynamic var itemId          = ""
    dynamic var title           = ""
    dynamic var itemDescription = ""
    dynamic var publishedAt     = NSDate()
    
    // MARK: - Relation
    
    dynamic var thumbnails = RLMArray(objectClassName: Thumbnail.className())

    // MARK: - Initialization
    
    // Custom initializer is not supported yet (github.com/realm/realm-cocoa/issues/1101)
    // init(json: JSON) {}
    
    class func modelFromJSON(json: JSON) -> VideoItem {
        let model = VideoItem()
        
        // videos api
        if let itemId = json["id"].string {
            model.itemId = itemId
        
        // search api
        } else if let itemId = json["id"]["videoId"].string {
            model.itemId = itemId
        }

        if let title = json["snippet"]["title"].string {
            model.title = title
        }

        if let description = json["snippet"]["description"].string {
            model.itemDescription = description
        }

        if let dateString = json["snippet"]["publishedAt"].string {
            let dateFormatter = VideoItem.dateFormatter()

            if let publishedAt = dateFormatter.dateFromString(dateString) {
                model.publishedAt = publishedAt
            }
        }

        let thumbnails = json["snippet"]["thumbnails"]

        if thumbnails.type == Type.Dictionary {

            for (key: String, subJson: JSON) in thumbnails {
                let thumbnail = Thumbnail.modelFromJSON(subJson, resolution: key)
                model.thumbnails.addObject(thumbnail)
            }
        }
        
        return model
    }
    
    // MARK: - Override
    
    override class func primaryKey() -> String! {
        return "itemId"
    }
    
    // MARK: - Private
    
    private class func dateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        // parse.com/docs/rest#objects-classes
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return dateFormatter
    }
    
    // MARK: - ResponseCollectionSerializable
    
    class func collection(#json: JSON) -> [VideoItem] {
        let realm = RLMRealm.defaultRealm()
        var collection = [VideoItem]()
        
        if let items = json["items"].array {
            realm.beginWriteTransaction()
            
            for item in items {
                let videoItem = VideoItem.modelFromJSON(item)
                let model = VideoItem.createOrUpdateInRealm(realm, withObject: videoItem)
                collection.append(model)
            }
            
            realm.commitWriteTransaction()
        }
        
        return collection
    }
}
