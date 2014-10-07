//
//  NewsFeedViewController.swift
//  Facebook
//
//  Created by Timothy Lee on 8/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var wedding1ImageView: UIImageView!
    @IBOutlet weak var wedding2ImageView: UIImageView!
    @IBOutlet weak var wedding3ImageView: UIImageView!
    @IBOutlet weak var wedding4ImageView: UIImageView!
    @IBOutlet weak var wedding5ImageView: UIImageView!
    
    var imageViewToSegue: UIImageView!
    var isPresenting: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the content size of the scroll view
        scrollView.contentSize = CGSizeMake(320, feedImageView.image!.size.height)
    }
    
    @IBAction func onTap(gestureRecognizer: UITapGestureRecognizer) {
        imageViewToSegue = gestureRecognizer.view as UIImageView
        performSegueWithIdentifier("feedToPhotoViewer", sender: self)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        var destinationViewController = segue.destinationViewController as PhotoViewController
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
        
        destinationViewController.image = self.imageViewToSegue.image
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("animating transition")
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        var window = UIApplication.sharedApplication().keyWindow
        var frame = window.convertRect(imageViewToSegue.frame, fromView: scrollView)
        var copyImageView = UIImageView(frame: frame)

        if (isPresenting) {
            toViewController.view.alpha = 0
            
            copyImageView.image = imageViewToSegue.image
            copyImageView.contentMode = UIViewContentMode.ScaleAspectFill
            copyImageView.clipsToBounds = true
            
            window.addSubview(copyImageView)
            containerView.addSubview(toViewController.view)
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                copyImageView.frame.size.width = 320
                copyImageView.frame.size.height = 320 * (copyImageView.image!.size.height / copyImageView.image!.size.width)
                copyImageView.center.x = 320 / 2
                copyImageView.center.y = 568 / 2
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    copyImageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }
        } else {
            
            copyImageView.image = imageViewToSegue.image
            copyImageView.contentMode = UIViewContentMode.ScaleAspectFill
            copyImageView.clipsToBounds = true
            
            copyImageView.frame.size.width = 320
            copyImageView.frame.size.height = 320 * (copyImageView.image!.size.height / copyImageView.image!.size.width)
            copyImageView.center.x = 320 / 2
            copyImageView.center.y = 568 / 2
            
            window.addSubview(copyImageView)
            
            toViewController.view.alpha = 0
            fromViewController.view.alpha = 0
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                toViewController.view.alpha = 1
                copyImageView.frame = window.convertRect(self.imageViewToSegue.frame, fromView: self.scrollView)
                }, completion: { (finished: Bool) -> Void in
                    copyImageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentInset.top = 0
        scrollView.contentInset.bottom = 50
        scrollView.scrollIndicatorInsets.top = 0
        scrollView.scrollIndicatorInsets.bottom = 50
    }
}
