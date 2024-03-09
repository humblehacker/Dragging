import SwiftUI

struct ConditionalDragModifier<T>: ViewModifier where T: Transferable {
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
    func draggable<T>(enabled: Bool, payload: @autoclosure @escaping () -> T) -> some View where T: Transferable {
        modifier(ConditionalDragModifier(enabled: enabled, payload: payload))
    }
}
