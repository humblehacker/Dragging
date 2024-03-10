import SwiftUI

// origin: https://danielsaidi.com/blog/2023/08/30/enabling-drag-reordering-in-swiftui-lazy-grids-and-stacks

struct ReorderableDragRelocateDelegate<Data>: DropDelegate
    where Data: RandomAccessCollection, Data.Element: Reorderable
{
    typealias Item = Data.Element

    let item: Item
    var items: Data

    @Binding var activeDragItem: Item?
    @Binding var hasChangedLocation: Bool

    var moveAction: (Data.Index, Data.Index) -> Void

    func dropEntered(info _: DropInfo) {
        guard
            item != activeDragItem, let activeDragItem,
            let from = items.firstIndex(of: activeDragItem),
            let to = items.firstIndex(of: item)
        else { return }
        hasChangedLocation = true
        if items[to] != activeDragItem {
            let to = to > from ? items.index(to, offsetBy: 1) : to
            moveAction(from, to)
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
