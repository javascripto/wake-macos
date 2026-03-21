import Foundation
import IOKit.pwr_mgt

typealias AssertionID = IOPMAssertionID

let systemSleep = kIOPMAssertionTypePreventUserIdleSystemSleep
let displaySleep = kIOPMAssertionTypePreventUserIdleDisplaySleep

func createAssertion(type: String, reason: String, id: inout AssertionID) -> Bool {
    let result = IOPMAssertionCreateWithName(
        type as CFString,
        IOPMAssertionLevel(kIOPMAssertionLevelOn),
        reason as CFString,
        &id
    )
    if result == kIOReturnSuccess { return true }
    id = 0
    return false
}

func declareUserActivity(reason: String, id: inout AssertionID) -> Bool {
    let result = IOPMAssertionDeclareUserActivity(
        reason as CFString,
        IOPMUserActiveType(rawValue: 0),
        &id
    )
    if result == kIOReturnSuccess { return true }
    id = 0
    return false
}

func releaseAssertion(id: inout AssertionID) {
    if id == 0 { return }
    IOPMAssertionRelease(id)
    id = 0
}
