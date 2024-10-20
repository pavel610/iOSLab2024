import Foundation
import UIKit

struct Moment: Hashable, Identifiable {
    var id: UUID
    var date: Date
    var images: [UIImage]
    var description: String
}
