import Foundation

@MainActor
protocol WakePreferencesManaging: AnyObject {
    var startsActive: Bool { get set }
}

@MainActor
final class WakePreferences: WakePreferencesManaging {
    private enum Keys {
        static let startsActive = "startsActive"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var startsActive: Bool {
        get { userDefaults.bool(forKey: Keys.startsActive) }
        set { userDefaults.set(newValue, forKey: Keys.startsActive) }
    }
}
