import XCTest
@testable import BrowserMethodMiddlewareProvider
import Testing
import Vapor
import HTTP

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

  func testCommonVerb() throws {
    let middleware = BrowserMethodMiddleware()
    let finalResponder = BasicResponder() { req in return Response(status: .ok) }
    let req = Request.makeTest(method: .post, path: "/")
    req.formURLEncoded = ["_method": "get"]
    let _ = try middleware.respond(to: req, chainingTo: finalResponder)
    XCTAssertTrue(req.method == .get)
  }

  func testUncommonVerb() throws {
    let middleware = BrowserMethodMiddleware()
    let finalResponder = BasicResponder() { req in return Response(status: .ok) }
    let req = Request.makeTest(method: .post, path: "/")
    req.formURLEncoded = ["_method": "teapot"]
    let _ = try middleware.respond(to: req, chainingTo: finalResponder)
    // Ensure it hasn't changed
    print("The method is \(req.method)")
    guard
      case let .other(methodName) = req.method,
      methodName == "TEAPOT"
     else {
      XCTFail()
      return
    }
  }

}

extension BrowserMethodMiddlewareProviderTests {
  static let allTests = [
    ("testProvider", testProvider),
    ("testCommonVerb", testCommonVerb),
    ("testUncommonVerb", testUncommonVerb),
  ]
}
