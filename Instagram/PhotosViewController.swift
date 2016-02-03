//
//  ViewController.swift
//  Instagram
//
//  Created by Fer on 1/28/16.
//  Copyright © 2016 Fernando Mendoza. All rights reserved.
//  RANDOM MESSAGE TO TEST GIT SYNC
//

import UIKit
import AFNetworking
import SwiftyJSON


class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var requestData: JSON!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate      =   self
    tableView.dataSource    =   self
    // Do any additional setup after loading the view, typically from a nib.
    
    
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
        let instagramData = JSON(data: data)
        self.requestData = instagramData["data"]
        self.tableView.reloadData()
    });
    task.resume()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    guard let requestData = requestData else{
      return 0
    }
    return requestData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PhotoCell
    let profile          =   requestData[indexPath.row]["likes"]["data"][0]["profile_picture"].string
    let imageUrl    = NSURL(string: profile!)
    
    cell.photo.setImageWithURL(imageUrl!)
    return cell
  }
  
  
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    // Dispose of any resources that can be recreated.
  }
}

