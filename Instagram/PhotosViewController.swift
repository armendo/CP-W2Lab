//
//  ViewController.swift
//  Instagram
//
//  Created by Fer on 1/28/16.
//  Copyright © 2016 Fernando Mendoza. All rights reserved.
//  RANDOM MESSAGE TO TEST GIT SYNC
//  TEST
//

import UIKit
import AFNetworking
import SwiftyJSON


class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
  @IBOutlet weak var tableView: UITableView!
  var requestData: JSON!
  var isMoreDataLoading: Bool!
  
  var usersLoaded = NSMutableDictionary()
  var users       = [String]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isMoreDataLoading = true
    
    tableView.delegate      =   self
    tableView.dataSource    =   self
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
    
    loadMoreData()
  }
  
  // Makes a network request to get updated data
  // Updates the tableView with the new data
  // Hides the RefreshControl
  func refreshControlAction(refreshControl: UIRefreshControl) {
    
    //Setting the request to instagram
    let clientId = "e05c462ebd86446ea48a5af73769b602"
    let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
    let request = NSURLRequest(URL: url!)
    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate:nil,
      delegateQueue:NSOperationQueue.mainQueue()
    )
    
    let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
      completionHandler: { (data, response, error) in
        
        // ... Use the new data to update the data source ...
        
        // Reload the tableView now that there is new data
        self.tableView.reloadData()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    });
    task.resume()
  }
  
  func loadMoreData() {
    
    //Setting the request to instagram
    let clientId = "e05c462ebd86446ea48a5af73769b602"
    let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
    let request = NSURLRequest(URL: url!)
    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate:nil,
      delegateQueue:NSOperationQueue.mainQueue()
    )
    
    let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
      completionHandler: { (dataOrNil, response, error) in
        guard let data = dataOrNil else{
          print(error)
          return
        }
        self.isMoreDataLoading = false
        let instagramData = JSON(data: data)
        self.requestData  = instagramData["data"]
        
        for index in 0 ..< self.requestData.count{
          let userId = self.requestData[index]["caption"]["id"].string
          let profilePicture = self.requestData[index]["caption"]["from"]["profile_picture"].string
          
          if let userId = userId, profilePicture = profilePicture{
            if self.usersLoaded[userId] == nil{
              self.users.append(userId)
              self.usersLoaded[userId] = ["profile_picture": profilePicture]
            }
          }
        }
        
        self.tableView.reloadData()
        });
        

    task.resume()


  }
  
  //MARK: - UITableViewDataSource methods
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return users.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PhotoCell
    let user        = users[indexPath.row]
    let imageString = usersLoaded[user]!["profile_picture"] as! String
    let imageUrl    = NSURL(string: imageString)
    cell.photo.setImageWithURL(imageUrl!)
    return cell
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      // Calculate the position of one screen length before the bottom of the results
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
      
      // When the user has scrolled past the threshold, start requesting
      if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
        
        isMoreDataLoading = true
        
        // Code to load more results
        loadMoreData()
      }
    }
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  }

  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let vc = segue.destinationViewController as! PhotoDetailsViewController
    let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)

    let user        = users[indexPath!.row]
    let imageString = usersLoaded[user]!["profile_picture"] as! String
    let imageUrl    = NSURL(string: imageString)
    vc.imageUrl = imageUrl
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

