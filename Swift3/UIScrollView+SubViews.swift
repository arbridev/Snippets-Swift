//
//  UIScrollView+SubViews.swift
//  AddingView
//
//  Created by Admin on 4/16/17.
//  Copyright © 2017 Arbridev. All rights reserved.
//

import UIKit

extension UIScrollView {

    //Adds a view to an empty scroll view
    func addSubViewToEmptyScrollView(view: UIView, viewHeight: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
    }
    
    //Appends a sub view at the end of other vertical sub views
    func appendSubView(view: UIView, viewHeight: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        let bottomConstraint = extractBottomConstraint()
        
        bottomConstraint?.isActive = false
        
        var bottomView: UIView!
        
        if bottomConstraint?.firstItem as! NSObject == self {
            bottomView = bottomConstraint?.secondItem as! UIView!
        } else {
            bottomView = bottomConstraint?.firstItem as! UIView!
        }
        
        view.topAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        
        self.removeConstraint(bottomConstraint!)
    }
    
    private func extractBottomConstraint() -> NSLayoutConstraint? {
        for constraint in self.constraints {
            if constraint.firstAnchor == self.bottomAnchor {
                return constraint
            }
            if constraint.secondAnchor == self.bottomAnchor {
                return constraint
            }
        }
        return nil
    }
    
}
