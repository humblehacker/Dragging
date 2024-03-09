import SwiftUI

struct ConditionalDraggableView: View {
    @State var text: String = "Hello, World"
    @State var dropText: String? = nil
    @State var draggingEnabled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Toggle(isOn: $draggingEnabled) {
                Text("Dragging enabled")
            }
            .toggleStyle(.switch)

            Text("Everything in the green box is draggable, but only when enabled")

            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)

                TextField("", text: $text)
                    .labelsHidden()
                    .font(.title)
            }
            .padding()
            .draggable(enabled: draggingEnabled, payload: text)
            .border(Color.green, width: 2)

            Text(dropText ?? "Drop here")
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .border(Color.red, width: 2)
                .dropDestination { items, location in
                    dropText = items.first as String?
                    print("\(items) dropped @ \(location)")
                    return true
                } isTargeted: { targeted in
                    print("isTargeted: \(targeted)")
                }
        }
        .padding()
        .fixedSize()
        .onChange(of: text) { _, _ in
            dropText = nil
        }
    }
}

#Preview {
    ConditionalDraggableView()
}
