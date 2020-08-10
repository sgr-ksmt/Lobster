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

    class Subscription<S: Subscriber> {
        var subscriber: S?
        var cancellable: AnyCancellable?
        let lobster: Lobster

        fileprivate init(subscriber: S, lobster: Lobster) {
            self.subscriber = subscriber
            self.lobster = lobster

            cancellable = lobster.combine
                .fetched()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] in self?.recerived() }
                )
        }

        func cancelSubscription() {
            cancellable?.cancel()
            subscriber = nil
        }

        func recerived() {
        }
    }

    final class ConfigValueSubscription<S: Subscriber, T: ConfigSerializable>: Subscription<S>, Combine.Subscription where S.Input == T.Value, S.Failure == Never {
        private let key: ConfigKey<T>
        init(subscriber: S, lobster: Lobster, key: ConfigKey<T>) {
            self.key = key
            super.init(subscriber: subscriber, lobster: lobster)
        }

        public func request(_ demand: Subscribers.Demand) {}

        public func cancel() {
            super.cancelSubscription()
        }

        override func recerived() {
            _ = subscriber?.receive(lobster[key])
        }
    }

    struct ConfigValuePublisher<T: ConfigSerializable>: Combine.Publisher {
        public typealias Output = T.Value
        public typealias Failure = Never

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

    final class ConfigValueOptionalSubscription<S: Subscriber, T: ConfigSerializable>: Subscription<S>, Combine.Subscription where S.Input == T.Value?, S.Failure == Never {
        private let key: ConfigKey<T?>
        init(subscriber: S, lobster: Lobster, key: ConfigKey<T?>) {
            self.key = key
            super.init(subscriber: subscriber, lobster: lobster)
        }

        public func request(_ demand: Subscribers.Demand) {}

        public func cancel() {
            super.cancelSubscription()
        }

        override func recerived() {
            _ = subscriber?.receive(lobster[key])
        }
    }

    struct ConfigValueOptionalPublisher<T: ConfigSerializable>: Combine.Publisher {
        public typealias Output = T.Value?
        public typealias Failure = Never

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

    func fetched<T: ConfigSerializable>(_ key: ConfigKey<T>) -> AnyPublisher<T.Value, Never> {
        return ConfigValuePublisher(lobster: lobster, key: key)
            .eraseToAnyPublisher()
    }

    func fetched<T: ConfigSerializable>(_ key: ConfigKey<T?>) -> AnyPublisher<T.Value?, Never> {
        return ConfigValueOptionalPublisher(lobster: lobster, key: key)
            .eraseToAnyPublisher()
    }
}
