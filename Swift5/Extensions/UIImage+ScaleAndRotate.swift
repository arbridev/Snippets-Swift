import UIKit

extension UIImage {
    
    func scaleAndRotate() -> UIImage {
        
        let kMaxResolution: CGFloat = 3000
        
        let imgRef = self.cgImage
        
        let width = CGFloat((imgRef?.width)!)
        let height = CGFloat((imgRef?.height)!)
        
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        if (width > kMaxResolution || height > kMaxResolution) {
            let ratio: CGFloat = width/height;
            if (ratio > 1) {
                bounds.size.width = kMaxResolution
                bounds.size.height = bounds.size.width / ratio
            }
            else {
                bounds.size.height = kMaxResolution
                bounds.size.width = bounds.size.height * ratio
            }
        }
        
        let scaleRatio: CGFloat = bounds.size.width / width;
        let imageSize: CGSize = CGSize(width: CGFloat(imgRef!.width), height: CGFloat(imgRef!.height))
        var boundHeight: CGFloat = 0
        let orient: UIImage.Orientation = self.imageOrientation;
        
        switch(orient)
        {
        case UIImageOrientation.up: //EXIF = 1
            transform = CGAffineTransform.identity;
            break;
            
        case UIImageOrientation.upMirrored: //EXIF = 2
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            break;
            
        case UIImageOrientation.down: //EXIF = 3
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height);
            transform = transform.rotated(by: CGFloat(Double.pi));
            break;
            
        case UIImageOrientation.downMirrored: //EXIF = 4
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height);
            transform = transform.scaledBy(x: 1.0, y: -1.0);
            break;
            
        case UIImageOrientation.leftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            transform = transform.rotated(by: 3.0 * CGFloat(Double.pi) / 2.0);
            break;
            
        case UIImageOrientation.left: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width);
            transform = transform.rotated(by: 3.0 * CGFloat(Double.pi) / 2.0);
            break;
            
        case UIImageOrientation.rightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            transform = transform.rotated(by: CGFloat(Double.pi) / 2.0);
            break;
            
        case UIImageOrientation.right: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0);
            transform = transform.rotated(by: CGFloat(Double.pi) / 2.0);
            break;
        @unknown default:
            fatalError("Unknown orientation")
        }
        
        UIGraphicsBeginImageContext(bounds.size);
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        if (orient == UIImage.Orientation.right || orient == UIImage.Orientation.left)
        {
            context.scaleBy(x: -scaleRatio, y: scaleRatio);
            context.translateBy(x: -height, y: 0);
        }
        else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio);
            context.translateBy(x: 0, y: -height);
        }
        
        context.concatenate(transform);
        
        UIGraphicsGetCurrentContext()?.draw(imgRef!, in: CGRect(x: 0, y: 0, width: width, height: height));
        let imageCopy: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return imageCopy;
        
    }
}
