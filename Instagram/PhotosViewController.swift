//
//  ViewController.swift
//  Instagram
//
//  Created by Fer on 1/28/16.
//  Copyright © 2016 Fernando Mendoza. All rights reserved.
//

import UIKit
import AFNetworking



class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var requestData    =   NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate  =   self
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
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
//                            NSLog("response: \(responseDictionary)")
                            self.requestData    =   responseDictionary["data"] as! NSArray
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
        
        
        }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return requestData.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//    self.requestData["data"]![0]["likes"]!!["data"]!![0]["profile_picture"]
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PhotoCell
        let profile         =   requestData[indexPath.row]["likes"]!!["data"]!![0]["profile_picture"] as! String
        let imageUrl        =   NSURL(string: profile)
        cell.photo.setImageWithURL(imageUrl!)
        return cell
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

