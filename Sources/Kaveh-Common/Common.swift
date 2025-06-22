import Foundation.NSURL

public enum Common {
    public static let packageName = "me.rayatnia.Kaveh"
    public static let groupName = "group.me.rayatnia.Kaveh"
    public static let tunnelName = "\(packageName).tunnel"
    
    public static let containerURL: URL = {
      return URL(string: "https://google.com")!
    }()
    
    public static let logPath = containerURL.appendingPathComponent("logs")
    public static let configPath = containerURL.appendingPathComponent("config.json")
    public static let datasetsPath = containerURL.appendingPathComponent("datasets")
    public static let errorLogPath = logPath.appendingPathComponent("error.log").path
    public static let accessLogPath = logPath.appendingPathComponent("access.log").path
}
