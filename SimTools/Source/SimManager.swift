/**
*  SimTools
*  Copyright (c) Andrii Myk 2020
*  Licensed under the MIT license (see LICENSE file)
*/

import Foundation
import CoreLocation
import SimLib

typealias Action = () -> Void
typealias SimRefreshCompletion = (SimError?) -> (Void)
typealias SimRequestCompletion = (Result<Bool, SimError>) -> (Void)

enum SimError: Error, CustomStringConvertible {
    case failed(withMessage: String)
    case noBootedSimulators
    
    public var description: String {
        switch self {
        case .noBootedSimulators:
            return "No booted simulators"
        case .failed(let message):
            return "Failed with message '\(message)'"
        }
    }
}

class SimManager {

    // MARK: - Private properties

    private lazy var simLib = { SimLib() }()
    private lazy var refreshQueue = DispatchQueue(label: "com.simmanger.refresh_queue", qos: .userInitiated)
    
    // MARK: - Public properties

    static let shared = SimManager()
    
    private(set) var allSimulators: [Simulator]?
    
    var bootedSimulators: [Simulator]? {
        allSimulators?.filter { $0.state == .booted }
    }
    
    // MARK: - Public

    func refresh(completion: @escaping SimRefreshCompletion) {
        refreshQueue.async {
            do {
                self.allSimulators = try self.simLib.getAllSimulators()
                DispatchQueue.main.async { completion(nil) }
            } catch let error as CustomStringConvertible {
                DispatchQueue.main.async { completion(.failed(withMessage: error.description)) }
            }
        }
    }
    
    func bootSimulator(_ simulator: Simulator, completion: @escaping SimRefreshCompletion) {
        refreshQueue.async {
            do {
                try self.simLib.bootSimulator(simulator)
                DispatchQueue.main.async { completion(nil) }
            } catch let error as CustomStringConvertible {
                DispatchQueue.main.async { completion(.failed(withMessage: error.description)) }
            }
        }
    }
    
    public func setLocationToBootedSimulators(_ location: CLLocationCoordinate2D, completion: @escaping SimRefreshCompletion) {
        refreshQueue.async {
            guard let simulators = self.bootedSimulators, !simulators.isEmpty else {
                DispatchQueue.main.async { completion(.noBootedSimulators) }
                return
            }

            do {
                try self.simLib.setLocation(location, to: simulators)
                DispatchQueue.main.async { completion(nil) }
            } catch let error as CustomStringConvertible {
                DispatchQueue.main.async { completion(.failed(withMessage: error.description)) }
            }
        }
    }
    
    public func isSimulatorAppRunned(completion: @escaping SimRequestCompletion) {
        refreshQueue.async {
            do {
                let result = try self.simLib.isSimulatorAppRunned()
                DispatchQueue.main.async { completion(.success(result)) }
            } catch let error as CustomStringConvertible {
                DispatchQueue.main.async { completion(.failure(.failed(withMessage: error.description))) }
            }
        }
    }
}
