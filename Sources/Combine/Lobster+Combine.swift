//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public struct CombineLobster {
    fileprivate let lobster: Lobster
}

@available(iOS 13.0, *)
public extension CombineLobster {

    final class ConfigValueSubscription<S: Subscriber, T: ConfigSerializable>: Combine.Subscription where S.Input == T.T, S.Failure == Error, T.T == T {
        
        private var subscriber: S?
        private var cancellable: AnyCancellable?
        private let lobster: Lobster

        fileprivate init(subscriber: S, lobster: Lobster, key: ConfigKey<T>) {
            self.subscriber = subscriber
            self.lobster = lobster

            cancellable = lobster.combine.fetched()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: {
                        _ = subscriber.receive(lobster[key])
                })
        }

        public func request(_ demand: Subscribers.Demand) {}

        public func cancel() {
            cancellable?.cancel()
            subscriber = nil
        }
    }

    struct ConfigValuePublisher<T: ConfigSerializable>: Combine.Publisher where T.T == T {
        public typealias Output = T.T
        public typealias Failure = Error

        private let lobster: Lobster
        private let key: ConfigKey<T>

        init(lobster: Lobster, key: ConfigKey<T>) {
            self.lobster = lobster
            self.key = key
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subscriber.receive(subscription: ConfigValueSubscription(
                subscriber: subscriber,
                lobster: lobster,
                key: key
            ))
        }
    }

    final class ConfigValueOptionalSubscription<S: Subscriber, T: ConfigSerializable>: Combine.Subscription where S.Input == T.T?, S.Failure == Error, T.T == T {

        private var subscriber: S?
        private var cancellable: AnyCancellable?
        private let lobster: Lobster

        fileprivate init(subscriber: S, lobster: Lobster, key: ConfigKey<T?>) {
            self.subscriber = subscriber
            self.lobster = lobster

            cancellable = lobster.combine.fetched()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: {
                        _ = subscriber.receive(lobster[key])
                })
        }

        public func request(_ demand: Subscribers.Demand) {}

        public func cancel() {
            cancellable?.cancel()
            subscriber = nil
        }
    }

    struct ConfigValueOptionalPublisher<T: ConfigSerializable>: Combine.Publisher where T.T == T {
        public typealias Output = T.T?
        public typealias Failure = Error

        private let lobster: Lobster
        private let key: ConfigKey<T?>

        init(lobster: Lobster, key: ConfigKey<T?>) {
            self.lobster = lobster
            self.key = key
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subscriber.receive(subscription: ConfigValueOptionalSubscription(
                subscriber: subscriber,
                lobster: lobster,
                key: key
            ))
        }
    }

}

@available(iOS 13.0, *)
public extension Lobster {
    var combine: CombineLobster {
        CombineLobster(lobster: self)
    }
}

@available(iOS 13.0, *)
public extension CombineLobster {
    func fetched() -> AnyPublisher<Void, Error> {
        return NotificationCenter.default.publisher(for: Lobster.didFetchConfig)
            .tryMap { (notification) in
                if let error = notification.object as? Error {
                    throw error
                }
                return
            }
            .eraseToAnyPublisher()
    }

    func fetched<T: ConfigSerializable>(_ key: ConfigKey<T>) -> AnyPublisher<T.T, Error> where T.T == T {
        return ConfigValuePublisher(lobster: lobster, key: key)
            .eraseToAnyPublisher()
    }

    func fetched<T: ConfigSerializable>(_ key: ConfigKey<T?>) -> AnyPublisher<T.T?, Error> where T.T == T {
        return ConfigValueOptionalPublisher(lobster: lobster, key: key)
            .eraseToAnyPublisher()
    }
}


//extension ConfigKeys {
//    static let a = ConfigKey<String>("a")
//    static let b = ConfigKey<String?>("b")
//}
//
//@available(iOS 13.0, *)
//class hoge {
//    func hoge() {
//        Lobster.shared.combine.fetched(key: .a).sink(receiveCompletion: { _ in }, receiveValue: { a in
//
//        })
//        Lobster.shared.combine.fetched(key: .b).sink(receiveCompletion: { _ in }, receiveValue: { a in
//
//        })
//
//    }
//}
