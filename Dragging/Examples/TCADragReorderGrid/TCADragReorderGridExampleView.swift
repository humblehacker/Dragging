import ComposableArchitecture
import SwiftUI

// origin: https://danielsaidi.com/blog/2023/08/30/enabling-drag-reordering-in-swiftui-lazy-grids-and-stacks

@Reducer
private struct Example {
    @ObservableState
    struct State {
        var cells: IdentifiedArrayOf<Cell.State>
        var activeDragItem: StoreOf<Cell>?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case cells(IdentifiedActionOf<Cell>)
        case rowMoved(from: Int, to: Int)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .cells:
                return .none
            case let .rowMoved(from, to):
                state.cells.move(fromOffsets: IndexSet(integer: from), toOffset: to)
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
                ReorderableForEach(
                    store.scope(state: \.cells, action: \.cells),
                    activeDragItem: $store.activeDragItem
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
                    store.send(.rowMoved(from: from as! Int, to: to as! Int))
                }
            }.padding()
        }
        .background(Color.blue.gradient)
        .scrollContentBackground(.hidden)
        .reorderableForEachContainer(activeDragItem: $store.activeDragItem)
    }

    var shape: some Shape {
        RoundedRectangle(cornerRadius: 20)
    }
}

private struct GridData: Identifiable, Equatable {
    let id: Int
}
