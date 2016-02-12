//
//  FullScreenPhotoViewController.swift
//  Instagram
//
//  Created by Fer on 2/4/16.
//  Copyright © 2016 Fernando Mendoza. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var profileImage: UIImageView!
  var imageUrl:NSURL?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      scrollView.delegate = self
      profileImage.setImageWithURL(imageUrl!)
      scrollView.contentSize = profileImage.image!.size


      // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return profileImage
  }
  
  
  @IBAction func dismissViewController(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)

  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
