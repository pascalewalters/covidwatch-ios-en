//
//  Created by Zsombor Szabo on 27/04/2020.
//

import Foundation
import ExposureNotification

public protocol ExposureNotificationsDiagnosisKeyServing {
        
    func postDiagnosisKeys(
        _ diagnosisKeys: [ENTemporaryExposureKey],
        completion: @escaping (Error?) -> Void
    ) -> Void
    
    func getDiagnosisKeyFileURLs(
        startingAt index: Int,
        completion: @escaping (Result<[URL], Error>) -> Void
    )
    
    func downloadDiagnosisKeyFile(
        at remoteURL: URL,
        completion: @escaping (Result<[URL], Error>) -> Void
    )
    
    func getExposureConfiguration(
        completion: (Result<ENExposureConfiguration, Error>) -> Void
    )
    
    #if DEBUG_CALIBRATION
    func getExposureConfigurationList(
        completion: (Result<[ENExposureConfiguration], Error>) -> Void
    )
    #endif
}