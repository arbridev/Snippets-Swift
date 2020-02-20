/*
 Copyright 2020 Armando Brito

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **/

import UIKit

class ImageZoomer: NSObject {
    
    ///UIViewController where ImageZoomer is presented
    var viewController: UIViewController!
    
    ///UIImageView containing the zooming image
    var zoomImageView: UIImageView?
    
    private var scrollView: UIScrollView!
    
    private var quitSign: UIView?
    
    private var tap: UIGestureRecognizer!
    
    private var dynamicZoom: Bool = false
    
    /**
     viewController: the UIViewController instance where is presented
     */
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    /**
     viewController: the UIViewController instance where is presented
     */
    init(viewController: UIViewController, dynamicZoom: Bool) {
        self.viewController = viewController
        self.dynamicZoom = dynamicZoom
    }
    
    //MARK: - ImageZoomDelegate
    
    ///Zooms the image provided
    func zoomImage(_ image: UIImage) {
        guard let parentView = viewController.view else {
            return
        }
        
        scrollView = UIScrollView(frame: parentView.frame)
        self.zoomImageView = UIImageView(image: image)
        zoomImageView!.frame = parentView.frame
        zoomImageView!.contentMode = .scaleAspectFit
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        zoomImageView!.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.frame = parentView.frame
        scrollView.addGestureRecognizer(tap)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.bouncesZoom = false
        scrollView.backgroundColor = UIColor.black
        scrollView.addSubview(zoomImageView!)
        parentView.addSubview(scrollView)
        
        // Dynamic zooming
        scrollView.delegate = dynamicZoom ? self : nil
        
        scrollView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        
        zoomImageView!.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        zoomImageView!.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        zoomImageView!.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        zoomImageView!.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        zoomImageView!.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        zoomImageView!.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        parentView.layoutIfNeeded()
        
        scrollView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.alpha = 1
        }, completion: nil)
    }
    
    /**
     Dismisses the full screen image
     */
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        scrollView.alpha = 1
        quitSign?.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.alpha = 0
            self.quitSign?.alpha = 0
        }, completion: { completed in
            if completed {
                self.zoomImageView = nil
                self.scrollView.removeFromSuperview()
                self.quitSign?.removeFromSuperview()
            }
        })
    }
    
}

extension ImageZoomer: UIScrollViewDelegate {
    /**
     Gallery Zoom
     */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomImageView
    }
}

extension ImageZoomer {
    
    fileprivate func makeQuitSign() -> UIView {
        let background = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        background.backgroundColor = UIColor.black
        background.layer.cornerRadius = 5
        
        let sign = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        sign.text = "x"
        sign.textColor = UIColor.white
        sign.textAlignment = .center
        sign.adjustsFontSizeToFitWidth = true
        sign.isUserInteractionEnabled = false
        
        background.addContainedView(sign)
        
        sign.layoutIfNeeded()
        
        return background
    }
    
    func includeQuitSign() {
        self.quitSign = makeQuitSign()
        
        viewController.view.addSubview(quitSign!)
        
        quitSign!.translatesAutoresizingMaskIntoConstraints = false
        
        quitSign!.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -10).isActive = true
        quitSign!.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 20).isActive = true
        quitSign!.widthAnchor.constraint(equalToConstant: viewController.view.bounds.width/12).isActive = true
        quitSign!.heightAnchor.constraint(equalTo: quitSign!.widthAnchor).isActive = true
        
        quitSign!.layoutIfNeeded()
        
        if tap != nil {
            quitSign!.isUserInteractionEnabled = true
            scrollView.removeGestureRecognizer(tap)
            tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
            quitSign!.addGestureRecognizer(tap)
        } else {
            quitSign!.isUserInteractionEnabled = false
        }
    }
}

