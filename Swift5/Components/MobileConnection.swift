import Foundation
import CoreTelephony

struct MobileConnection {
    
    enum ConnectionType {
        case m2G
        case m3G
        case m4G
        case unknown
    }
    
    func mobileConnectionType() -> ConnectionType {
        let netInfo = CTTelephonyNetworkInfo()
        
        if #available(iOS 13.0, *) {
            if let cRAT = netInfo.serviceSubscriberCellularProviders?["serviceSubscriberCellularProvider"]?.mobileNetworkCode  {
                switch cRAT {
                case CTRadioAccessTechnologyGPRS,
                     CTRadioAccessTechnologyEdge,
                     CTRadioAccessTechnologyCDMA1x:
                    return .m2G
                case CTRadioAccessTechnologyWCDMA,
                     CTRadioAccessTechnologyHSDPA,
                     CTRadioAccessTechnologyHSUPA,
                     CTRadioAccessTechnologyCDMAEVDORev0,
                     CTRadioAccessTechnologyCDMAEVDORevA,
                     CTRadioAccessTechnologyCDMAEVDORevB,
                     CTRadioAccessTechnologyeHRPD:
                    return .m3G
                case CTRadioAccessTechnologyLTE:
                    return .m4G
                default:
                    return .unknown
                }
            }
            return .unknown
        } else {
            if let cRAT = netInfo.currentRadioAccessTechnology  {
                switch cRAT {
                case CTRadioAccessTechnologyGPRS,
                     CTRadioAccessTechnologyEdge,
                     CTRadioAccessTechnologyCDMA1x:
                    return .m2G
                case CTRadioAccessTechnologyWCDMA,
                     CTRadioAccessTechnologyHSDPA,
                     CTRadioAccessTechnologyHSUPA,
                     CTRadioAccessTechnologyCDMAEVDORev0,
                     CTRadioAccessTechnologyCDMAEVDORevA,
                     CTRadioAccessTechnologyCDMAEVDORevB,
                     CTRadioAccessTechnologyeHRPD:
                    return .m3G
                case CTRadioAccessTechnologyLTE:
                    return .m4G
                default:
                    return .unknown
                }
            }
            return .unknown
        }
        
    }
    
}
