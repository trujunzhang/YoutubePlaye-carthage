//
//  GradientNode.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/08.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

//import AsyncDisplayKit


class GradientNode: ASDisplayNode {
    
//    override class func drawRect(bounds: CGRect, withParameters parameters: NSObjectProtocol!,
//        isCancelled isCancelledBlock: asdisplaynode_iscancelled_block_t!, isRasterizing: Bool) {
//            let myContext = UIGraphicsGetCurrentContext()
//            CGContextSaveGState(myContext)
//            CGContextClipToRect(myContext, bounds)
//            
//            let componentCount: Int = 2
//            let locations: [CGFloat] = [0.0, 1.0]
//            let components: [CGFloat] = [
//                0.0, 0.0, 0.0, 0.8,
//                0.0, 0.0, 0.0, 0.0
//            ]
//            let myColorSpace = CGColorSpaceCreateDeviceRGB()
//            let myGradient = CGGradientCreateWithColorComponents(myColorSpace, components,
//                locations, componentCount)
//            
//            let myStartPoint = CGPoint(x: bounds.midX, y: bounds.maxY)
//            let myEndPoint = CGPoint(x: bounds.midX, y: bounds.midY)
//            CGContextDrawLinearGradient(myContext, myGradient, myStartPoint,
//                myEndPoint, UInt32(kCGGradientDrawsAfterEndLocation))
//            
//            CGContextRestoreGState(myContext)
//    }
}
