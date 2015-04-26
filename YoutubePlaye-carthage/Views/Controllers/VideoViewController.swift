//
//  VideoViewController.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/08.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var playerMaskView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var viewModel: VideoViewModel?
    
    private let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        playerView.delegate = self
        
        if let viewModel = viewModel {
            
            if let videoId = viewModel.videoId {
                playerView.loadWithVideoId(videoId, playerVars: ["showinfo": 0])
                indicator.startAnimating()
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "playerMaskDidTap:")
        playerMaskView.addGestureRecognizer(tapGesture)
        playerMaskView.userInteractionEnabled = true
        
        containerView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(containerView)
        
//        containerView.snp_makeConstraints { [weak self] (make: ConstraintMaker) in
//            if let wself = self {
//                make.edges.equalTo(wself.scrollView)
//                make.width.equalTo(wself.scrollView.snp_width) // Essential
//            }
//        }
        
        setupContainerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action
    
    func playerMaskDidTap(sender: AnyObject) {
        playerView.playVideo()
    }
    
    // MARK: - Private
    
    private func setupContainerView() {
        var lastView: UIView?
        let outerPadding: CGFloat = 12.0
        
        if let viewModel = viewModel {
            let titleBox = UIView()
            titleBox.backgroundColor = UIColor.whiteColor()
            titleBox.layer.borderWidth = 0.4
            titleBox.layer.borderColor = UIColor(white: 0, alpha: 0.2).CGColor
            
            containerView.addSubview(titleBox)
            
            let titleLabel = UILabel()
            titleLabel.font = UIFont.boldSystemFontOfSize(titleLabel.font.pointSize)
            titleLabel.lineBreakMode = .ByWordWrapping
            titleLabel.numberOfLines = 0
            titleLabel.text = viewModel.title
            
            let size = titleLabel.sizeThatFits(CGSize(
                width: view.frame.width - CGFloat(outerPadding * 4),
                height: CGFloat.max))
            
//            titleBox.snp_makeConstraints { (make: ConstraintMaker) in
//                make.top.equalTo(outerPadding)
//                make.left.equalTo(outerPadding)
//                make.width.equalTo(self.view.frame.width - CGFloat(outerPadding * 2))
//                make.height.equalTo(size.height + CGFloat(outerPadding * 2))
//            }

            titleBox.addSubview(titleLabel)
            
//            titleLabel.snp_makeConstraints { (make: ConstraintMaker) in
//                make.top.equalTo(outerPadding)
//                make.left.equalTo(outerPadding)
//                make.width.equalTo(size.width)
//                make.height.equalTo(size.height)
//            }
            
            let textView = UITextView()
            textView.backgroundColor = UIColor.whiteColor()
            textView.layer.borderWidth = 0.4
            textView.layer.borderColor = UIColor(white: 0, alpha: 0.2).CGColor
            textView.scrollEnabled = false
            textView.editable = false
            textView.textContainer.lineFragmentPadding = 0
            textView.textContainerInset = UIEdgeInsets(
                top: outerPadding,
                left: outerPadding,
                bottom: outerPadding,
                right: outerPadding
            )
            
            textView.text = viewModel.itemDescription
            
            let textViewSize = textView.sizeThatFits(CGSize(
                width: view.frame.width - CGFloat(outerPadding * 2),
                height: CGFloat.max))
            
            containerView.addSubview(textView)
            
//            textView.snp_makeConstraints { (make: ConstraintMaker) in
//                make.top.equalTo(titleBox.snp_bottom).with.offset(outerPadding)
//                make.left.equalTo(outerPadding)
//                make.width.equalTo(self.view.frame.width - CGFloat(outerPadding * 2))
//                make.height.equalTo(textViewSize.height)
//            }
            
            lastView = textView as UIView
        }
        
//        containerView.snp_updateConstraints { (make: ConstraintMaker) in
//            if let lastView = lastView {
//                make.bottom.equalTo(lastView.snp_bottom).with.offset(outerPadding)
//            }
//        }
    }
}

extension VideoViewController: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        
        // FIX: github.com/youtube/youtube-ios-player-helper/issues/86
        let intervalId = playerView.webView
            .stringByEvaluatingJavaScriptFromString("window.setInterval('', 9999);")

        if let intervalId = intervalId {
            playerView.webView
                .stringByEvaluatingJavaScriptFromString(
                    "for (var i = 1; i < \(intervalId); i++) { window.clearInterval(i); }")
        }
        
        UIView.animateWithDuration(0.6,
            animations: {
                self.playerMaskView.backgroundColor = UIColor.clearColor()
            },
            completion: { (finished) in
                if finished {
                    self.indicator.stopAnimating()
                }
            })
    }
}
