import HTTP
import Vapor

public struct BrowserMethodMiddleware: Middleware {
  public func respond(to req: Request, chainingTo next: Responder) throws -> Response {
    // If there is a parameter `_method` with a valid HTTP method, change the
    // request's method.
    if let m = req.data["_method"]?.string {
      req.method = Method(m)
    }
    return try next.respond(to: req)
  }
}
