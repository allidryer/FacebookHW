//
//  PhotoViewController.swift
//  Facebook
//
//  Created by Alli Dryer on 10/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoActionsImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1

        var scrollWidth: CGFloat  = self.view.frame.size.width
        var scrollHeight: CGFloat  = self.view.frame.size.height
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        
        scrollView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDoneButtonPress(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        if scrollView.contentOffset.y <= -100 {
        UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: { () -> Void in
            self.photoActionsImageView.alpha = 0
            self.doneButton.alpha = 0
            }, completion: { (finished: Bool) -> Void in
                UIView.animateWithDuration(0.2, delay: 0.1, options: nil, animations: { () -> Void in
                    self.scrollView.backgroundColor = UIColor(white: 0, alpha: 0)
                }, completion: nil)
        })
        } else if scrollView.contentOffset.y > -100 {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.scrollView.backgroundColor = UIColor(white: 0, alpha: 1)
                self.photoActionsImageView.alpha = 1
                self.doneButton.alpha = 1
                }, completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,
        willDecelerate decelerate: Bool) {
            //println("Content Offset: \(scrollView.contentOffset.y)")
            if scrollView.contentOffset.y <= -100 {
                //println("DISMISSED")
                dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
