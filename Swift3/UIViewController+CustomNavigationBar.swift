//  Created by arbridev
//  Copyright © 2017 arbridev. All rights reserved.
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

extension UIViewController {

    //Adds a UIViewController at the top of self.view
    func addCustomNavigationBar(controller: UIViewController, barHeight: CGFloat) {
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        let overlay = controller.view
        
        self.view.addSubview(overlay!)
        
        overlay?.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        overlay?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        overlay?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        overlay?.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        
        let constraints = [NSLayoutConstraint]()
        
        for constraint in self.view.constraints {
            if let si = constraint.secondItem as? UILayoutSupport {
                if si.isEqual(topLayoutGuide) {
                    if constraint.secondAnchor == topLayoutGuide.bottomAnchor {
                        if let fi = constraint.firstItem as? UIView {
                            if fi.frame.minY == 0.0 {
                                //Ignore the status bar
                                continue
                            }
                        }
                        constraint.isActive = false
                        constraint.firstItem.topAnchor.constraint(equalTo: (overlay?.bottomAnchor)!).isActive = true
                    }
                }
            }
        }
        
        self.view.removeConstraints(constraints)
    }
}
