import SwiftUI

// origin: https://danielsaidi.com/blog/2023/08/30/enabling-drag-reordering-in-swiftui-lazy-grids-and-stacks

struct ReorderableDragRelocateDelegate<Data>: DropDelegate
    where Data : RandomAccessCollection, Data.Element: Reorderable
{
    typealias Item = Data.Element
    
    let item: Item
    var items: Data

    @Binding var activeDragItem: Item?
    @Binding var hasChangedLocation: Bool

    var moveAction: (IndexSet, Int) -> Void

    func dropEntered(info _: DropInfo) {
        guard item != activeDragItem, let activeDragItem else { return }
        guard let from = items.firstIndex(of: activeDragItem) as! Int? else { return }
        guard let to = items.firstIndex(of: item) as! Int? else { return }
        hasChangedLocation = true
        if items[_offset: to] != activeDragItem {
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
