import UIKit

struct Base64Conversion {
    
    func imageToBase64(image: UIImage) -> String {
        let imageData: NSData = image.jpegData(compressionQuality: 1.0)! as NSData
        let strBase64 = imageData.base64EncodedString(options: [])
        return strBase64
    }
    
    func base64ToImage(strBase64: String) -> UIImage {
        let dataDecoded: NSData = NSData(base64Encoded: strBase64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage: UIImage = UIImage(data: dataDecoded as Data)!
        return decodedimage
    }
    
}
