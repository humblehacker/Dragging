import SwiftUI

struct DragReorderListExampleView: View {
    @State private var items = (1 ... 10).map { ListData(id: $0) }

    var body: some View {
        List {
            ForEach(items) { item in
                shape
                    .fill(.white.opacity(0.5))
                    .frame(height: 50)
                    .overlay(Text("\(item.id)"))
                    .contentShape(.dragPreview, shape)
            }
            .onMove { from, to in
                items.move(fromOffsets: from, toOffset: to)
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

private struct ListData: Identifiable, Equatable {
    let id: Int
}

#Preview {
    DragReorderListExampleView()
}
