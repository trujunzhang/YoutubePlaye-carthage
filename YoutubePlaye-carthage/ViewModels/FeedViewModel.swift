//
//  FeedViewModel.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/07.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

import Foundation


class FeedViewModel: NSObject {
    private(set) var items = [FeedItemViewModel]()
    private(set) var loading = false
    private(set) var pagingEnabled = true
    private var nextPageToken: String?
    
    override init() {
        super.init()
    }
    
    func fetchMostPopularVideos(#refresh: Bool) -> BFTask {
        var fetchTask = BFTask(result: nil)
        loading = true
        
        if refresh {
            nextPageToken = nil
        }
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return APIClient.fetchMostPopularVideos(pageToken: self.nextPageToken)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let dictionary = task.result as? [String: AnyObject] {
                
                if let videos = dictionary["videos"] as? [VideoItem] {
                    let items = videos.map { (video: VideoItem) -> FeedItemViewModel in
                        return FeedItemViewModel(item: video)
                    }
                    
                    if refresh {
                        self.items = items
                    } else {
                        self.items += items
                    }
                }
                
                if let nextPageToken = dictionary["nextPageToken"] as? String {
                    self.nextPageToken = nextPageToken
                } else {
                    self.pagingEnabled = false
                }                
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            self.loading = false
            
            return task
        })
        
        return fetchTask
    }
}
