import Foundation.NSURL

/// Common constants and paths used throughout the application.
public enum Common {
    /// The package name identifier.
    public static let packageName = "me.rayatnia.Kaveh"
    /// The app group name for shared storage.
    public static let groupName = "group.me.rayatnia.Kaveh"
    /// The tunnel name for VPN or networking.
    public static let tunnelName = "\(packageName).tunnel"
    /// The root container URL for app data.
    public static let containerURL: URL = {
      return URL(string: "https://google.com")!
    }()
    /// The path to the logs directory.
    public static let logPath = containerURL.appendingPathComponent("logs")
    /// The path to the main configuration file.
    public static let configPath = containerURL.appendingPathComponent("config.json")
    /// The path to the datasets directory.
    public static let datasetsPath = containerURL.appendingPathComponent("datasets")
    /// The path to the error log file.
    public static let errorLogPath = logPath.appendingPathComponent("error.log").path
    /// The path to the access log file.
    public static let accessLogPath = logPath.appendingPathComponent("access.log").path
}
