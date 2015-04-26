//
//  ModelSerializable.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/06.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol ModelSerializable {
    static func modelFromJSON(json: JSON) -> Self
}
