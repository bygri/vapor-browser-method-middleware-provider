import XCTest
import BrowserMethodMiddlewareProvider
import Testing
import Vapor

class BrowserMethodMiddlewareProviderTests: XCTestCase {

  func testProvider() throws {
    // Set up Provider on Droplet
    let config: Config = try [
      "droplet": [
        "middleware": [
          "browser-method"
        ]
      ]
    ].makeNode(in: nil).converted()
    try config.addProvider(Provider.self)
    let drop = try Droplet(config)
    // Set up a `patch` route
    var patchCalled = false
    drop.patch() { req in
      patchCalled = true
      return ""
    }
    // Fake a method
    let req = Request.makeTest(method: .post, path: "/")
    req.formURLEncoded = ["_method": "patch"]
    let _ = try drop.respond(to: req)
    // See if it changed
    XCTAssertTrue(req.method == .patch)
    // See if the `patch` route was called.
    XCTAssertTrue(patchCalled)
  }

}

extension BrowserMethodMiddlewareProviderTests {
  static let allTests = [
    ("testProvider", testProvider),
  ]
}
