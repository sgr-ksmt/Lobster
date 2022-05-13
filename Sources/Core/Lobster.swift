//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import Amplitude
import Experiment

/** Lobster wraps Remote Config and Amplitude Experiment interfaces */
public class Lobster {
    
    // MARK: - Alias
    
    public typealias FetchStatus = (RemoteConfigFetchStatus, RemoteConfigFetchStatus)
    
    // MARK: - Public Properties
    
    /** Common instance of Lobster. */
    public static let shared = Lobster()

    /**
     The `FIRRemoteConfig` instance.
     - Note: Basically, You don't  have to use this directly.
     */
    public let remoteConfig = RemoteConfig.remoteConfig()
    
    /**
     We store here every variants we've fetched from Amplitude Experiment as a dictionary.
     For instance:
     
     ["variant_key": [
         "firstValue": false,
         "secondValue": 190
       ]
     ]
     */
    public var experimentVariants = [String: Any]()
    
    /** The Remote Config default expiration duration. `12 hours` */
    public static let defaultExpirationDuration: TimeInterval = 43_200.0

    /**
     The custom fetch expiration duration. You can change it you want.
     Default is `defaultExpirationDuration`
     */
    public var fetchExpirationDuration: TimeInterval = Lobster.defaultExpirationDuration

    /**
     A flag indicating whether to check for stale status or not.
     Default is `true`.
     */
    public var useStaleChecker: Bool = true

    /**
     A value store to store `isStaled`, which is the flag to judge remote config stale or not.
     You can inject another value store conforming to `StaleValueStore` protocol.
     Default is `UserDefaults`.
     */
    public var staleValueStore: StaleValueStore = UserDefaults.standard

    /**
     Set/Get `isStaled` flag.
     If `useStaleChecker` is true and `isStaled` is true, Lobster fetch Remote config values from
     Firebase immediately ignoring cache expiration when you call `Lobster.shared.fetch(completion:)`
     This value is not applied to Amplitude Experiment.
     */
    public var isStaled: Bool {
        get { staleValueStore.isStaled }
        set { staleValueStore.isStaled = newValue }
    }

    /** Debug mode - It must be false on production. */
    public var debugMode: Bool = false {
        didSet {
            remoteConfig.configSettings.minimumFetchInterval = debugMode ?
                0 :
                Lobster.defaultExpirationDuration
        }
    }

    /**
     The current fetch status of Remote Config & Amplitude Experiment as `FetchStatus`
     First status = Remote Config - Second one = Amplitude Experiment
     */
    public private(set) var fetchStatus: FetchStatus = (.noFetchYet, .noFetchYet)

    /** Default value store. */
    public let defaultsStore = DefaultsStore()
    
    // MARK: - Initializers
    
    /** This method is private to prevent a developer create a new instance of `Lobster` */
    private init() {}
    
    // MARK: - Public Functions
    
    /**
     Fetchs Remote Config and Amplitude Experiment in a row and then callbacks the potential occured errors.
     - parameter experimentAPIKey: The Amplitude Experiment API key needed to initialized the SDK.
     - parameter completion: The completion indicating when the fetchs are ended and giving the occured errors if there's some.
     */
    public func fetch(experimentAPIKey: String, completion: ((Error?, Error?) -> Void)? = nil) {
        var fetchErrors: (Error?, Error?) = (nil, nil)
        let fetchGroup = DispatchGroup()
        
        /** Enters the dispatch group and fetchs the Remote config, then leaves the group */
        fetchGroup.enter()
        fetchRemoteConfig { error in
            if let error = error { fetchErrors.0 = error }

            fetchGroup.leave()
        }

        /** Enters the dispatch group and fetchs the Amplitude Experiment, then leaves the group */
        fetchGroup.enter()
        fetchAmplitudeExperiment(with: experimentAPIKey) { error in
            if let error = error { fetchErrors.1 = error }

            fetchGroup.leave()
        }

        /** All tasks are ended, sends a notification to inform the every fetchs are ended and callbacks the potential errors */
        fetchGroup.notify(queue: .main) {
            completion?(fetchErrors.0, fetchErrors.1)
            NotificationCenter.default.post(name: Lobster.didFetchConfig, object: fetchErrors)
        }
    }
    
    /**
     Set default config values.
     By setting default config values, You can use these value safely before fetching config data from Firebase.
     - parameter defaults: A dictionary that will set as default config values
     */
    public func setDefaults(_ defaults: [String: AnyObject]) {
        defaultsStore.set(defaults: defaults)
        updateDefaults()
    }

    /**
     Set default values using loaded data from plist
     - parameter plistFileName: plist file name w/o extension
     - parameter bundle: bundle that embedded plist file. (Default is main bundle)
     */
    public func setDefaults(fromPlist plistFileName: String, bundle: Bundle = .main) {
        guard let url = bundle.url(forResource: plistFileName, withExtension: "plist") else { return }
        guard let defaults = NSDictionary(contentsOf: url) as? [String: NSObject] else { return }
        setDefaults(defaults)
    }

    /** Clear default values and then RemoteConfig's default values will be updated to empty. */
    public func clearDefaults() {
        defaultsStore.clear()
        updateDefaults()
    }
    
    /**
     Returns expiration duration for RemoteConfig.
     - returns: If you use `useStaleChecker` and `isStaled` is true, this function will return `0.0`.
     If not so, it will return `fetchExpirationDuration`.
     */
    private func getExpirationDuration() -> TimeInterval {
        if useStaleChecker, isStaled {
            return 0.0
        }
        return fetchExpirationDuration
    }
    
    /** Updates default values of RemoteConfig by using values stored in `defaultsStore` */
    func updateDefaults() {
        RemoteConfig.remoteConfig().setDefaults(defaultsStore.defaults)
    }
    
    // MARK: - Private Functions
    
    /**
     Fetchs the Remote Config and then call a completion to indicate the fetch is ended, with the associated optional error.
     - parameter completion: The completion indicating the end of the fetch and giving the optional error occured.
     */
    public func fetchRemoteConfig(completion: @escaping (Error?) -> Void) {
        let duration = getExpirationDuration()
        
        /** Starts the Remote Config fetch */
        remoteConfig.fetch(withExpirationDuration: duration) { [unowned self] (status, fetchError) in
            self.remoteConfig.activate { (_, activateError) in
                let error = fetchError ?? activateError
                
                /** Fetch is done, update the remote config fetch status (keeping
                 the status of amplitude experiment) and call the completion */
                self.fetchStatus = (status, self.fetchStatus.1)
                self.isStaled = false
                
                completion(error)
            }
        }
    }
    
    /**
     Initializes and fetchs Amplitude Experiment and then call a completion
     to indicate the fetch is ended, with the associated optional error.
     - parameter completion: The completion indicating the end of the fetch and giving the optional error occured.
     */
    private func fetchAmplitudeExperiment(with experimentAPIKey: String, completion: @escaping (Error?) -> Void) {
        
        /** Initializes the Amplitude Experiment SDK */
        let config = ExperimentConfig()
        let experimentClient = Experiment.initialize(apiKey: experimentAPIKey, config: config)

        /** Builds the experiment user thanks to the Amplitude Analytics deviceId */
        let deviceId = Amplitude.instance().deviceId
        let user = ExperimentUserBuilder()
            .deviceId(deviceId)
            .build()
        
        /** Starts the fetch of Amplitude Experiment for the experiment user just built */
        experimentClient.fetch(user: user) { fetchedClient, error in
            
            /** Fetch has failed, updates the experiment fetch status (keeping
             the status of remote config) and callback the error */
            if let error = error {
                self.fetchStatus = (self.fetchStatus.0, .failure)
                
                completion(error)
                return
            }
            
            /**
             Fetch has succeeded:
             1. Updates the experiment fetch status (keeping the status of remote config)
             2. Retrieves and stores all the experiment variants locally
             3. Call the completion with no error
             */
            self.fetchStatus = (self.fetchStatus.0, .success)
            self.storeAllVariants(from: fetchedClient.all())
        
            completion(nil)
        }
    }
    
    /**
     Loops into all experiments fetched from Amplitude Experiment
     to retrieve every payloads and stores them locally as `[String: Any]`.
     - parameter experiments: All the experiments fetched from Amplitude Experiments.
     */
    private func storeAllVariants(from experiments: [String: Variant]) {
        experiments
            .map { $0.value.payload }
            .forEach {
                
                /** Make sure the payload is convertible as a dictionary */
                guard let payload = $0 as? [String: Any] else { return }
                
                /** Stores each payload locally */
                payload.forEach { (key, value) in
                    self.experimentVariants[key] = value
                }
            }
    }
    
}

// MARK: - Extensions of Lobster

extension Lobster {
    
    /**
     The key of Notification. Lobster notifies you of finishing fetching config data from Firebase.
     - Note: If an error occurred while fetching data, it'll be included as the object of `Notification`.
     */
    public static var didFetchConfig: Notification.Name { Notification.Name("LobsterDidFetchConfig") }
}
