import SwiftUI

// origin: https://danielsaidi.com/blog/2023/08/30/enabling-drag-reordering-in-swiftui-lazy-grids-and-stacks

struct ReorderableDragRelocateDelegate<Item: Reorderable>: DropDelegate {
    let item: Item
    var items: [Item]

    @Binding var activeDragItem: Item?
    @Binding var hasChangedLocation: Bool

    var moveAction: (IndexSet, Int) -> Void

    func dropEntered(info _: DropInfo) {
        guard item != activeDragItem, let current = activeDragItem else { return }
        guard let from = items.firstIndex(of: current) else { return }
        guard let to = items.firstIndex(of: item) else { return }
        hasChangedLocation = true
        if items[to] != current {
            moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
        }
    }

    func dropUpdated(info _: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info _: DropInfo) -> Bool {
        hasChangedLocation = false
        activeDragItem = nil
        return true
    }
}
