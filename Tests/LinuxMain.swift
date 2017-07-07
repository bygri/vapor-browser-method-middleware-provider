#if os(Linux)

import XCTest
@testable import BrowserMethodMiddlewareProviderTests

XCTMain([
  testCase(BrowserMethodMiddlewareProviderTests.allTests),
])

#endif
