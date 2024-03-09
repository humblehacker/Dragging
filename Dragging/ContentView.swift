import SwiftUI

struct ContentView: View {
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

struct ConditionalDragModifier<T>: ViewModifier where T : Transferable {
    let enabled: Bool
    var payload: () -> T

    init(enabled: Bool, payload: @escaping () -> T) {
        self.enabled = enabled
        self.payload = payload
    }

    func body(content: Content) -> some View {
        if enabled {
            content
                .overlay { Color.white.opacity(0.001) }
                .draggable(payload())
        } else {
            content
        }
    }
}

extension View {
    func draggable<T>(enabled: Bool, payload: @autoclosure @escaping () -> T) -> some View where T : Transferable {
        modifier(ConditionalDragModifier(enabled: enabled, payload: payload))
    }
}

#Preview {
    ContentView()
}
