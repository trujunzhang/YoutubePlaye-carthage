//
//  FeedItemViewModel.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/07.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

import Foundation


class FeedItemViewModel: NSObject {
    
    private(set) var item: VideoItem
    private(set) var title: String?
    private(set) var itemDescription: String?
    private(set) var publishedAt: NSDate?
    private(set) var thumbnail: Thumbnail?
    
    init(item: VideoItem) {
        self.item = item
        title = item.title
        itemDescription = item.itemDescription
        publishedAt = item.publishedAt
        
        let resolutions = ["maxres", "standard", "high", "medium", "default"]
        
        for resolution in resolutions {
            let predicate = NSPredicate(format: "resolution = %@", resolution)
            let results = item.thumbnails.objectsWithPredicate(predicate)
            
            if results.count > 0 {
                let thumbnail = results.lastObject() as! Thumbnail
                self.thumbnail = thumbnail
                break
            }
        }
        
        super.init()
    }
}
