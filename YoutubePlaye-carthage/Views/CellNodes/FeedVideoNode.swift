//
//  FeedVideoNode.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/07.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

//import AsyncDisplayKit

class FeedVideoNode: ASCellNode {
    
    private let kOuterPadding: CGFloat = 12.0
    private let kNodeHeight  : CGFloat = 160.0
    private let kPlayIconSize  = CGSize(width: 40.0, height: 40.0)
    private let kClockIconSize = CGSize(width: 10.0, height: 10.0)
    private let kParagraphLineSpacing: CGFloat = 3.0
    
    private var imageNode      : ASNetworkImageNode
    private var titleNode      : ASTextNode
    private var descriptionNode: ASTextNode
    private var clockIconNode  : ASImageNode
    private var timeAgoNode    : ASTextNode
    private var playIconNode   : ASImageNode
    
    private var gradientNode: GradientNode
    
    // MARK: - Initialization
    
    init(viewModel: FeedItemViewModel) {
        imageNode = ASNetworkImageNode()
        imageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        
        if let thumbnail = viewModel.thumbnail {
            imageNode.URL = NSURL(string: thumbnail.url)
        }
        
        gradientNode = GradientNode()
        gradientNode.opaque = false
        gradientNode.layerBacked = true
        
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor.clearColor()
        
        var paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineSpacing = kParagraphLineSpacing
        paragraphStyle.lineBreakMode = .ByWordWrapping
        
        titleNode = ASTextNode()
//        titleNode.maximumLineCount = 1
        
        let titleAttributes = [
            NSFontAttributeName: UIFont(name: "HiraKakuProN-W6", size: 16.0)!,
            NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 1.0),
            NSShadowAttributeName: textShadow,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        if let title = viewModel.title {
            titleNode.attributedString =
                NSAttributedString(string: title, attributes: titleAttributes)
        }
        
        descriptionNode = ASTextNode()
//        descriptionNode.maximumLineCount = 2
        
        let descriptionAttributes = [
            NSFontAttributeName: UIFont(name: "HiraKakuProN-W3", size: 10.0)!,
            NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.7),
            NSShadowAttributeName: textShadow,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        if let itemDescription = viewModel.itemDescription {
            descriptionNode.attributedString =
                NSAttributedString(string: itemDescription, attributes: descriptionAttributes)
        }
        
        clockIconNode = ASImageNode()
        clockIconNode.backgroundColor = UIColor.clearColor()
        clockIconNode.image = UIImage(named: "ClockIcon")
        
        timeAgoNode = ASTextNode()
//        timeAgoNode.maximumLineCount = 1
        
        if let publishedAt = viewModel.publishedAt {
            let timeAgo = publishedAt.timeAgo()
            timeAgoNode.attributedString =
                NSAttributedString(string: timeAgo, attributes: descriptionAttributes)
        }
        
        playIconNode = ASImageNode()
        playIconNode.backgroundColor = UIColor.clearColor()
        playIconNode.image = UIImage(named: "PlayIcon")
        
        super.init()
        
        addSubnode(imageNode)
        addSubnode(gradientNode)
        addSubnode(titleNode)
        addSubnode(descriptionNode)
        addSubnode(clockIconNode)
        addSubnode(timeAgoNode)
        addSubnode(playIconNode)
    }
    
    // MARK: ASDisplayNode+Subclasses
    
     func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        titleNode.measure(CGSize(
            width: constrainedSize.width - (2 * kOuterPadding),
            height: constrainedSize.height))
        
        let timeAgoSize = timeAgoNode.measure(constrainedSize)
        
        descriptionNode.measure(CGSize(
            width: constrainedSize.width - (2 * kOuterPadding) - timeAgoSize.width - 4.0 - kClockIconSize.width - 12.0,
            height: constrainedSize.height))

        return CGSize(width: constrainedSize.width, height: kNodeHeight)
    }
    
     func layout() {
        imageNode.frame = frame
        
        let gradientNodeHeight = frame.height * 0.8
        
        gradientNode.frame = CGRect(
            x: 0,
            y: frame.height - gradientNodeHeight,
            width: frame.width,
            height: gradientNodeHeight
        )
        
        let descriptionSize = descriptionNode.calculatedSize
        
        descriptionNode.frame = CGRect(
            x: kOuterPadding,
            y: frame.height - descriptionSize.height - kOuterPadding,
            width: descriptionSize.width,
            height: descriptionSize.height
        )
        
        let titleSize = titleNode.calculatedSize
        
        titleNode.frame = CGRect(
            x: kOuterPadding,
            y: descriptionNode.frame.origin.y - titleSize.height - 3.0,
            width: titleSize.width,
            height: titleSize.height
        )
        
        let timeAgoSize = timeAgoNode.calculatedSize
        
        timeAgoNode.frame = CGRect(
            x: frame.width - timeAgoSize.width - kOuterPadding,
            y: frame.height - timeAgoSize.height - kOuterPadding - kParagraphLineSpacing,
            width: timeAgoSize.width,
            height: timeAgoSize.height
        )
        
        clockIconNode.frame = CGRect(
            x: timeAgoNode.frame.origin.x - kClockIconSize.width - 4,
            y: frame.height - kClockIconSize.height - kOuterPadding - kParagraphLineSpacing,
            width: kClockIconSize.width,
            height: kClockIconSize.height
        )
        
        playIconNode.frame = CGRect(
            x: (frame.width - kPlayIconSize.width) / 2,
            y: (frame.height - kPlayIconSize.height) / 2,
            width: kPlayIconSize.width,
            height: kPlayIconSize.height
        )
    }
}
