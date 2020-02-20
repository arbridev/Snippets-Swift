
import UIKit

extension UIImage {
    
    func getPNGFileSize() -> Double { // In KB
        let imageData:NSData = self.pngData()! as NSData
        let imageSize: Int = imageData.length
        return Double(imageSize) / 1024.0
    }
    
    func getJPEGFileSize() -> Double { // In KB
        let imageData:NSData = self.jpegData(compressionQuality: 1.0)! as NSData
        let imageSize: Int = imageData.length
        return Double(imageSize) / 1024.0
    }
    
}
