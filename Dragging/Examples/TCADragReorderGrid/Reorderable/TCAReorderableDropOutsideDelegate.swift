import SwiftUI

// origin: https://danielsaidi.com/blog/2023/08/30/enabling-drag-reordering-in-swiftui-lazy-grids-and-stacks

struct TCAReorderableDropOutsideDelegate<Item: TCAReorderable>: DropDelegate {
    @Binding
    var activeDragItem: Item?

    func dropUpdated(info _: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info _: DropInfo) -> Bool {
        activeDragItem = nil
        return true
    }
}

public extension View {
    func tcaReorderableForEachContainer<Item: TCAReorderable>(
        activeDragItem: Binding<Item?>
    ) -> some View {
        onDrop(of: [.text], delegate: TCAReorderableDropOutsideDelegate(activeDragItem: activeDragItem))
    }
}
