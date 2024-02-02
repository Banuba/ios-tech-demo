//
//  UnitTests.swift
//  UnitTests
//
//  Created by Rostyslav Dovhaliuk on 22.03.2023.
//  Copyright © 2023 Banuba. All rights reserved.
//

import XCTest
@testable import TechDemo

final class UnitTests: XCTestCase {
    func testDeepLinkParser() throws {
        var url = try XCTUnwrap(URL(string: "https://banuba.com/open?technology=virtual_try_on&category=glasses"))
        XCTAssertEqual(DeepLinkParser.deepLinkRoute(from: url), .category(id: "glasses", technologyId: "virtual_try_on"))
        
        url = try XCTUnwrap(URL(string: "https://banuba.com/open?technology=virtual_try_on"))
        XCTAssertEqual(DeepLinkParser.deepLinkRoute(from: url), .technology(id: "virtual_try_on"))

        url = try XCTUnwrap(URL(string: "https://banuba.com/open"))
        XCTAssertEqual(DeepLinkParser.deepLinkRoute(from: url), nil)
    }
}
