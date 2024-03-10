import ComposableArchitecture
import SwiftUI

// origin: https://danielsaidi.com/blog/2023/08/30/enabling-drag-reordering-in-swiftui-lazy-grids-and-stacks

@Reducer
private struct Example {
    @ObservableState
    struct State {
        var cells: IdentifiedArrayOf<Cell.State>
    }

    enum Action {
        case cells(IdentifiedActionOf<Cell>)
        case rowMoved(fromOffsets: IndexSet, toOffset: Int)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cells:
                return .none
            case let .rowMoved(fromOffsets: fromOffsets, toOffset: toOffset):
                state.cells.move(fromOffsets: fromOffsets, toOffset: toOffset)
                return .none
            }
        }
        .forEach(\.cells, action: \.cells) { Cell() }
    }
}

@Reducer
private struct Cell {
    @ObservableState
    struct State: Identifiable {
        let id: Int
    }
}

struct TCADragReorderGridExampleView: View {
    @State fileprivate var store: StoreOf<Example>
    @State private var activeDragItem: StoreOf<Cell>?

    init() {
        store = Store(
            initialState: Example.State(
                cells: IdentifiedArray(
                    uniqueElements: (1 ... 100).map { Cell.State(id: $0) }
                )
            )
        ) {
            Example()
        }
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: 200))]) {
                TCAReorderableForEach(
                    store.scope(state: \.cells, action: \.cells),
                    activeDragItem: $activeDragItem
                ) { cellStore in
                    shape
                        .fill(.white.opacity(0.5))
                        .frame(height: 100)
                        .overlay(Text("\(cellStore.id)"))
                        .contentShape(.dragPreview, shape)
                } preview: { cellStore in
                    Color.white
                        .clipShape(shape)
                        .frame(height: 150)
                        .frame(minWidth: 250)
                        .overlay(Text("\(cellStore.id)"))
                        .contentShape(.dragPreview, shape)
                } moveAction: { from, to in
                    store.send(.rowMoved(fromOffsets: from, toOffset: to))
                }
            }.padding()
        }
        .background(Color.blue.gradient)
        .scrollContentBackground(.hidden)
        .tcaReorderableForEachContainer(activeDragItem: $activeDragItem)
    }

    var shape: some Shape {
        RoundedRectangle(cornerRadius: 20)
    }
}

private struct GridData: Identifiable, Equatable {
    let id: Int
}
