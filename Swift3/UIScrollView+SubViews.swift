//  Created by Armando Brito
//  Copyright © 2017 Armando Brito. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

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
    func appendSubView(view: UIView, viewHeight: CGFloat, animated: Bool) {
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
        
        if animated {
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: 1.0)
            heightConstraint.isActive = true
            self.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, animations: {
                heightConstraint.constant = viewHeight
                self.layoutIfNeeded()
            })
        } else {
            view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        }
        
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
