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
        
        var scalefactor = window.frame.width / copyImageView.frame.width
        
        var photoViewImageCenter = CGPoint(x: 320/2, y: 287)
        var imageViewCenterX = self.imageViewToSegue.center.x
        var imageViewCenterY = self.imageViewToSegue.center.y + 110

        if (isPresenting) {
            copyImageView.contentMode = UIViewContentMode.ScaleAspectFill
            copyImageView.clipsToBounds = true
            copyImageView.image = imageViewToSegue.image
            window.addSubview(copyImageView)
            
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            
            if let vc = toViewController as? PhotoViewController {
                vc.imageView.hidden = false
            }
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                toViewController.view.alpha = 1
                copyImageView.transform = CGAffineTransformMakeScale(scalefactor, scalefactor)
                copyImageView.center.x = 320 / 2
                copyImageView.center.y = 287
                }, completion: { (finished: Bool) -> Void in
                        copyImageView.removeFromSuperview()
                        transitionContext.completeTransition(true)
                })
        } else {
            
            let vc = fromViewController as PhotoViewController
            
            copyImageView.clipsToBounds = true
            copyImageView.contentMode = imageViewToSegue.contentMode
            copyImageView.image = imageViewToSegue.image
            
            window.addSubview(copyImageView)
            containerView.addSubview(fromViewController.view)
            
            copyImageView.center = photoViewImageCenter
            
            copyImageView.transform = CGAffineTransformMakeScale(scalefactor, scalefactor)
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                fromViewController.view.alpha = 1
                }, completion: { (finished: Bool) -> Void in
                    UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: { () -> Void in
                        copyImageView.transform = CGAffineTransformMakeScale(1, 1)
                        copyImageView.center.x = imageViewCenterX
                        copyImageView.center.y = imageViewCenterY
                        }, completion: { (finished: Bool) -> Void in
                            copyImageView.removeFromSuperview()
                            transitionContext.completeTransition(true)
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
