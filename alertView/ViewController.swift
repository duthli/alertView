//
//  ViewController.swift
//  alertView
//
//  Created by do duy hung on 9/22/16.
//  Copyright © 2016 do duy hung. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollisionBehaviorDelegate {

    @IBAction func showAlertView (sender: UIButton){
        showAlert()
    }
    
    var alertView : UIView?
    var animator: UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior: UISnapBehavior!
    var  collisionBehavior: UICollisionBehavior!
    var currentLocation : CGPoint = CGPoint(x: 0, y: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        create()
        animator = UIDynamicAnimator(referenceView: self.view)
        // Do any additional setup after loading the view, typically from a nib.
    }


    func create(){
        let alertWidth: CGFloat = 250
        let alertHeight: CGFloat = 150
        let buttonWidth: CGFloat = 40
        let alertViewFrame: CGRect = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView?.backgroundColor = UIColor.white
        alertView?.alpha = 0.0
        alertView?.layer.cornerRadius = 10;
        alertView?.layer.shadowColor = UIColor.black.cgColor;
        alertView?.layer.shadowOffset = CGSize(width: 0, height: 5);
        alertView?.layer.shadowOpacity = 0.3;
        alertView?.layer.shadowRadius = 10.0;
        
        // button
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Dismiss.png"), for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth/2 - buttonWidth/2, y: -buttonWidth/2, width: buttonWidth, height: buttonWidth)
        
        button.addTarget(self, action: #selector(dismissAlert), for: UIControlEvents.touchUpInside)
        
        // OK button
        let buttonOK = UIButton(type: .custom)
        buttonOK.frame = CGRect(x: alertWidth/2 + buttonWidth, y: alertWidth/2 - buttonWidth/2, width: buttonWidth+40, height: buttonWidth)
        buttonOK.backgroundColor = UIColor.green
        buttonOK.setTitle("Oke", for: .normal)
        buttonOK.addTarget(self, action: #selector(okAlert), for: UIControlEvents.touchUpInside)
        
        let buttonCancel = UIButton(type: .custom)
        buttonCancel.frame = CGRect(x: alertWidth/2 - (buttonWidth * 3), y: alertWidth/2 - buttonWidth/2, width: buttonWidth * 2, height: buttonWidth)
        buttonCancel.backgroundColor = UIColor.red
        
        buttonCancel.addTarget(self, action: #selector(cancelAlert), for: UIControlEvents.touchUpInside)
        buttonCancel.setTitle("Cancel", for: .normal)
        
        alertView?.addSubview(buttonOK)
        alertView?.addSubview(buttonCancel)
        
        
        
        let rectLabel = CGRect(x: 0, y: button.frame.origin.y + button.frame.height, width: alertWidth, height: alertHeight - buttonWidth/2)
        let label = UILabel(frame: rectLabel)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Hello World"
        label.textAlignment = .center
        
        alertView?.addSubview(label)
        alertView?.addSubview(button)
        view.addSubview(alertView!)
    }
    
    func okAlert(){
        print("Ok")
    }
    func cancelAlert(){
        dismissAlert()
        print("Cancel")
    }
    func dismissAlert(){
        animator.removeAllBehaviors()
        
        UIView.animate(withDuration: 0.4, animations: {
            //self.overlayView.alpha = 0.0
            self.alertView?.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.alertView?.removeFromSuperview()
                self.alertView = nil
        })

    }
    
    func showAlert(){
        if (alertView == nil){
            create()
        }
         createGestureRecognizer()
        animator.removeAllBehaviors()
        
        alertView?.alpha = 1.0
        
        let snapBehaviour: UISnapBehavior = UISnapBehavior(item: alertView!, snapTo: view.center)
        animator.addBehavior(snapBehaviour)

        
        //tao sk
        
        animator.removeAllBehaviors()
        alertView?.alpha = 1
        let snapBehavior = UISnapBehavior(item: alertView!, snapTo: view.center)
        snapBehavior.damping  = 2
        animator.addBehavior(snapBehavior)

    }
    
    func createGestureRecognizer() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func handlePan(_ sender: UIGestureRecognizer){
        let panLocationInView = sender.location(in: self.view)
        let panLocationInAlert = sender.location(in: self.alertView)
        
        if (sender.state == .began){
            let offset = UIOffsetMake(panLocationInAlert.x - (alertView?.bounds.midX)!, panLocationInAlert.y - (alertView?.bounds.midY)!);
            attachmentBehavior = UIAttachmentBehavior(item: alertView!, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            animator.addBehavior(attachmentBehavior)
        }
        else if (sender.state == .changed){
            attachmentBehavior.anchorPoint = panLocationInView
        }
        else if (sender.state  == .ended){
            animator.removeAllBehaviors()
            snapBehavior = UISnapBehavior(item: alertView!, snapTo: view.center)
            animator.addBehavior(snapBehavior)
        }
        if (sender.state == .recognized){
            dismissAlert()
        }
            currentLocation = sender.location(in: alertView)
    }
}

