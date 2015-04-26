//
//  FeedViewController.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/07.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

import UIKit
//import AsyncDisplayKit



class FeedViewController: UIViewController {

    private let tableView = ASTableView()
    private let viewModel = FeedViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "YoutubePlayer"
        navigationController?.hidesBarsOnSwipe = true

        applyTheme()
        
        tableView.asyncDataSource = self
        tableView.asyncDelegate = self
        
        view.addSubview(tableView)
        
        viewModel.fetchMostPopularVideos(refresh: true).continueWithBlock {
            (task) -> AnyObject! in
            
            if task.error != nil {
                println(task.error)
            }
            
            self.tableView.reloadData()
            
            return nil
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private
    
    private func applyTheme() {
        
        if let navigationController = navigationController {
            
            //navigationController.navigationBar.barTintColor = UIColor.customColor()
            
            setNeedsStatusBarAppearanceUpdate()
            
            let tintColor =
                UIColor(red: 233.0/255.0, green: 30.0/255.0, blue: 90.0/255.0, alpha: 1.0)
            
            navigationController.navigationBar.tintColor = tintColor
            
            navigationController.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: tintColor
            ]
        }
    }
}

extension FeedViewController: ASTableViewDataSource {
    
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        let itemVM = viewModel.items[indexPath.row]
        
        return FeedVideoNode(viewModel: itemVM)
    }
}

extension FeedViewController: ASCommonTableViewDataSource {
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
}

extension FeedViewController: ASTableViewDelegate {
}

extension FeedViewController: ASCommonTableViewDelegate {
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let itemVM = viewModel.items[indexPath.row]
        let videoVM = VideoViewModel(videoItem: itemVM.item)
        
        let videoVC = storyboard?.instantiateViewControllerWithIdentifier("VideoViewController") as! VideoViewController
        videoVC.viewModel = videoVM
        
        navigationController?.pushViewController(videoVC, animated: true)
    }
}
