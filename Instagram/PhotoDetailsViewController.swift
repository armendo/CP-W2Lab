//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Fer on 2/4/16.
//  Copyright © 2016 Fernando Mendoza. All rights reserved.
//

import UIKit


class PhotoDetailsViewController: UIViewController {

  @IBOutlet weak var profileImage: UIImageView!
  var imageUrl:NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
      profileImage.userInteractionEnabled = true
      profileImage.setImageWithURL(imageUrl!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @IBAction func didTapOnImage(sender: UITapGestureRecognizer) {
    performSegueWithIdentifier("zoomSegue", sender: self)
  }
  
  
  

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      if segue.identifier == "zoomSegue"{
        let vc = segue.destinationViewController as! FullScreenPhotoViewController
        vc.imageUrl = imageUrl
      }
    }


}
