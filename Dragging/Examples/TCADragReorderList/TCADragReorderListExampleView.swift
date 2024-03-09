import ComposableArchitecture
import SwiftUI

@Reducer
private struct Example {
    @ObservableState
    struct State {
        var rows: IdentifiedArrayOf<Row.State>
    }

    enum Action {
        case rows(IdentifiedActionOf<Row>)
        case rowMoved(fromOffsets: IndexSet, toOffset: Int)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .rows:
                return .none
            case let .rowMoved(fromOffsets: fromOffsets, toOffset: toOffset):
                state.rows.move(fromOffsets: fromOffsets, toOffset: toOffset)
                return .none
            }
        }
        .forEach(\.rows, action: \.rows) { Row() }
    }
}

@Reducer
private struct Row {
    @ObservableState
    struct State: Identifiable {
        let id: Int
        let color: Color

        init(id: Int) {
            self.id = id
            color = Color.basic[id]
        }
    }
}

struct TCADragReorderListExampleView: View {
    @State fileprivate var store: StoreOf<Example>

    init() {
        store = Store(
            initialState: Example.State(
                rows: IdentifiedArray(
                    uniqueElements: (1 ... 10).map { Row.State(id: $0) }
                )
            )
        ) {
            Example()
        }
    }

    var body: some View {
        List {
            ForEach(store.scope(state: \.rows, action: \.rows)) { rowStore in
                shape
                    .fill(rowStore.color)
                    .frame(height: 50)
                    .overlay(Text("\(rowStore.id)"))
                    .contentShape(.dragPreview, shape)
            }
            .onMove { from, to in
                store.send(.rowMoved(fromOffsets: from, toOffset: to))
            }
            .listRowSeparator(.hidden)
        }
        .background(Color.blue.gradient)
        .scrollContentBackground(.hidden)
    }

    var shape: some Shape {
        RoundedRectangle(cornerRadius: 20)
    }
}

#Preview {
    TCADragReorderListExampleView()
}
