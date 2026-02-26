import Foundation
import SwiftData

final class BootstrapService {
    func bootstrapIfNeeded(context: ModelContext) throws {
        guard try context.fetch(FetchDescriptor<StoreProfile>()).isEmpty else { return }
        context.insert(StoreProfile(name: "My Store"))
        try context.save()
    }
}
