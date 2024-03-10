import SwiftUI

// origin: https://danielsaidi.com/blog/2023/08/30/enabling-drag-reordering-in-swiftui-lazy-grids-and-stacks

public typealias Reorderable = Equatable & Identifiable

public struct ReorderableForEach<Data, Content: View, Preview: View>: View
    where Data : RandomAccessCollection, Data.Element: Reorderable {

    public typealias Item = Data.Element

    public init(
        _ items: Data,
        activeDragItem: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder preview: @escaping (Item) -> Preview,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) {
        self.items = items
        _activeDragItem = activeDragItem
        self.content = content
        self.preview = preview
        self.moveAction = moveAction
    }

    public init(
        _ items: Data,
        activeDragItem: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) where Preview == EmptyView {
        self.items = items
        _activeDragItem = activeDragItem
        self.content = content
        preview = nil
        self.moveAction = moveAction
    }

    @Binding
    private var activeDragItem: Item?

    @State
    private var hasChangedLocation = false

    private let items: Data
    private let content: (Item) -> Content
    private let preview: ((Item) -> Preview)?
    private let moveAction: (IndexSet, Int) -> Void

    public var body: some View {
        ForEach(items) { item in
            if let preview {
                contentView(for: item)
                    .onDrag {
                        dragData(for: item)
                    } preview: {
                        preview(item)
                    }
            } else {
                contentView(for: item)
                    .onDrag {
                        dragData(for: item)
                    }
            }
        }
    }

    private func contentView(for item: Item) -> some View {
        content(item)
            .opacity(activeDragItem == item && hasChangedLocation ? 0.5 : 1)
            .onDrop(
                of: [.text],
                delegate: ReorderableDragRelocateDelegate(
                    item: item,
                    items: items,
                    activeDragItem: $activeDragItem,
                    hasChangedLocation: $hasChangedLocation
                ) { from, to in
                    withAnimation {
                        moveAction(from, to)
                    }
                }
            )
    }

    private func dragData(for item: Item) -> NSItemProvider {
        activeDragItem = item
        return NSItemProvider(object: "\(item.id)" as NSString)
    }
}
