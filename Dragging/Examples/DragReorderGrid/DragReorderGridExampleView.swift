import SwiftUI

// origin: https://danielsaidi.com/blog/2023/08/30/enabling-drag-reordering-in-swiftui-lazy-grids-and-stacks

struct DragReorderGridExampleView: View {
    @State
    private var items = (1 ... 100).map { GridData(id: $0) }

    @State
    private var activeDragItem: GridData?

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: 200))]) {
                ReorderableForEach(items, activeDragItem: $activeDragItem) { item in
                    shape
                        .fill(.white.opacity(0.5))
                        .frame(height: 100)
                        .overlay(Text("\(item.id)"))
                        .contentShape(.dragPreview, shape)
                } preview: { item in
                    Color.white
                        .clipShape(shape)
                        .frame(height: 150)
                        .frame(minWidth: 250)
                        .overlay(Text("\(item.id)"))
                        .contentShape(.dragPreview, shape)
                } moveAction: { from, to in
                    items.move(fromOffsets: IndexSet(integer: from), toOffset: to)
                }
            }.padding()
        }
        .background(Color.blue.gradient)
        .scrollContentBackground(.hidden)
        .reorderableForEachContainer(activeDragItem: $activeDragItem)
    }

    var shape: some Shape {
        RoundedRectangle(cornerRadius: 20)
    }
}

private struct GridData: Identifiable, Equatable {
    let id: Int
}
