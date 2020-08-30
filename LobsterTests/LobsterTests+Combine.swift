//
//  LobsterTests+Combine.swift
//  LobsterTests
//
//  Created by Suguru Kishimoto on 2020/08/10.
//  Copyright © 2020 Suguru Kishimoto. All rights reserved.
//

import XCTest
@testable import Lobster
import Firebase
import Combine

@available(iOS 13.0, *)
class Lobster_Combine_Tests: XCTestCase {

    override func setUp() {
        _ = FirebaseSetupHandler.handler
        Lobster.shared.clearDefaults()
        Lobster.shared.debugMode = true
        Lobster.shared.fetchExpirationDuration = 0
    }

    override func tearDown() {
        Lobster.shared.clearDefaults()
    }

    func testFetched() {
        let exp = expectation(description: "test fetched")

        let cancellable = Lobster.shared.combine.fetched().sink(receiveCompletion: { _ in }) { _ in
            exp.fulfill()
        }

        Lobster.shared.fetch()

        wait(for: [exp], timeout: 5.0)
        cancellable.cancel()
    }

    func testFetchedTwice() {
        let exp = expectation(description: "test fetched twice")
        exp.expectedFulfillmentCount = 2

        let cancellable = Lobster.shared.combine.fetched().sink(receiveCompletion: { _ in }) { _ in
            exp.fulfill()
        }

        Lobster.shared.fetch { _ in
            Lobster.shared.fetch()
        }

        wait(for: [exp], timeout: 10.0)
        cancellable.cancel()
    }

    func testFetchedWithCancel() {
        let exp = expectation(description: "test fetched with cancel")
        exp.expectedFulfillmentCount = 2
        exp.isInverted = true

        let cancellable = Lobster.shared.combine.fetched().sink(receiveCompletion: { _ in }) { _ in
            exp.fulfill()
        }

        Lobster.shared.fetch { _ in
            cancellable.cancel()
            Lobster.shared.fetch()
        }
        wait(for: [exp], timeout: 5.0)
    }


    func testFetchedString() {
        let exp = expectation(description: "test fetched string")

        let cancellable = Lobster.shared.combine.fetched(.title).sink(receiveCompletion: { _ in }) { title in
            XCTAssertEqual(title, "abc")
            exp.fulfill()
        }

        Lobster.shared.fetch()

        wait(for: [exp], timeout: 5.0)
        cancellable.cancel()
    }

    func testFetchedOptionalString() {
        let exp = expectation(description: "test fetched optional string")

        let cancellable = Lobster.shared.combine.fetched(.titleOptional).sink(receiveCompletion: { _ in }) { title in
            XCTAssertEqual(title, "def")
            exp.fulfill()
        }

        Lobster.shared.fetch()

        wait(for: [exp], timeout: 5.0)
        cancellable.cancel()
    }

    func testFetchedCodable() {
        let exp = expectation(description: "test fetched string")

        let cancellable = Lobster.shared.combine.fetched(.mike).sink(receiveCompletion: { _ in }) { mike in
            XCTAssertEqual(mike.name, "Mike")
            exp.fulfill()
        }

        Lobster.shared.fetch()

        wait(for: [exp], timeout: 5.0)
        cancellable.cancel()
    }

    func testFetchedOptionalCodable() {
        let exp = expectation(description: "test fetched optional string")

        let cancellable = Lobster.shared.combine.fetched(.mikeOptional).sink(receiveCompletion: { _ in }) { mike in
            XCTAssertEqual(mike?.name, "Mike")
            exp.fulfill()
        }

        Lobster.shared.fetch()

        wait(for: [exp], timeout: 5.0)
        cancellable.cancel()
    }

}
