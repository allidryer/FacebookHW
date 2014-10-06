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
        destinationViewController.image = self.imageViewToSegue.image
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
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
        var copyImageViewToSegue = UIImageView(frame: frame)
        var scalefactor = window.frame.width / copyImageViewToSegue.frame.width
        
        var photoViewImageCenter = CGPoint(x: 320/2, y: 287)
        var imageViewCenterX = self.imageViewToSegue.center.x
        var imageViewCenterY = self.imageViewToSegue.center.y + 110

        if (isPresenting) {
            copyImageViewToSegue.image = imageViewToSegue.image
            window.addSubview(copyImageViewToSegue)
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            copyImageViewToSegue.contentMode = UIViewContentMode.ScaleAspectFill
            copyImageViewToSegue.clipsToBounds = true
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                copyImageViewToSegue.transform = CGAffineTransformMakeScale(scalefactor, scalefactor)
                copyImageViewToSegue.center.x = 320 / 2
                copyImageViewToSegue.center.y = 287
                }, completion: { (finished: Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    toViewController.view.alpha = 1
                    }, completion: { (finished: Bool) -> Void in
                        transitionContext.completeTransition(true)
                        copyImageViewToSegue.removeFromSuperview()
                })
            })
        } else {
            copyImageViewToSegue.image = imageViewToSegue.image
            window.addSubview(copyImageViewToSegue)
            containerView.addSubview(fromViewController.view)
            copyImageViewToSegue.contentMode = UIViewContentMode.ScaleAspectFill
            copyImageViewToSegue.clipsToBounds = true
            copyImageViewToSegue.center = photoViewImageCenter
            
            copyImageViewToSegue.transform = CGAffineTransformMakeScale(scalefactor, scalefactor)
            fromViewController.view.alpha = 1
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                fromViewController.view.alpha = 0
                }, completion: { (finished: Bool) -> Void in
                    UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: { () -> Void in
                        copyImageViewToSegue.transform = CGAffineTransformMakeScale(1, 1)
                        copyImageViewToSegue.center.x = imageViewCenterX
                        copyImageViewToSegue.center.y = imageViewCenterY
                        }, completion: { (finished: Bool) -> Void in
                            transitionContext.completeTransition(true)
                            copyImageViewToSegue.removeFromSuperview()
                    })
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
