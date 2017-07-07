import Vapor

public final class Provider: Vapor.Provider {
  public static let repositoryName = "browser-method-provider"

  public init(config: Config) throws { }

  public func boot(_ config: Config) throws {
    config.addConfigurable(middleware: BrowserMethodMiddleware(), name: "browser-method")
  }

  public func boot(_ drop: Droplet) throws { }
  public func beforeRun(_ drop: Droplet) {}
}
