import Foundation
import IOKit.pwr_mgt

final class WakeController {
    private var systemAssertionID: AssertionID = 0
    private var displayAssertionID: AssertionID = 0
    private var userActivityAssertionID: AssertionID = 0

    var isActive: Bool {
        systemAssertionID != 0 || displayAssertionID != 0 || userActivityAssertionID != 0
    }

    /// Equivalente ao comando `caffeinate -id`
    /// Use `reportUserActivity: true` para incluir o equivalente ao `-u`.
    func activate(reportUserActivity: Bool = false) {
        if isActive { return }
        let reason = "Wake keeps this Mac awake while enabled"
        let systemCreated = createAssertion(type: systemSleep, reason: reason, id: &systemAssertionID)
        let displayCreated = createAssertion(type: displaySleep, reason: reason, id: &displayAssertionID)
        if reportUserActivity {
            _ = declareUserActivity(reason: reason, id: &userActivityAssertionID)
        }
        if !systemCreated || !displayCreated { deactivate() }
    }

    func deactivate() {
        releaseAssertion(id: &systemAssertionID)
        releaseAssertion(id: &displayAssertionID)
        releaseAssertion(id: &userActivityAssertionID)
    }
}
