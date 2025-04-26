import Foundation

enum Config {
    private static let apiToken: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let token = dict["API_TOKEN"] as? String else {
            fatalError("Config.plist file or API_TOKEN not found")
        }
        return token
    }()
    
    static var bearerToken: String {
        "Bearer \(apiToken)"
    }
    
    static let accountId: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let token = dict["ACCOUNT_ID"] as? String else {
            fatalError("Config.plist file or ACCOUNT_ID not found")
        }
        return token
    }()
}
