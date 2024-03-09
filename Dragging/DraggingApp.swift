import SwiftUI

@main
struct DraggingApp: App {
    let views: [NavigationDestination] = [
        .init(title: "Conditional draggable") { ConditionalDraggableView() },
        .init(title: "Drag reorder list") { DragReorderExampleView() },
    ]

    var body: some Scene {
        WindowGroup {
            NavigationView {
                List(views, id: \.title) { $0 }
                    .listStyle(.sidebar)
                    .frame(width: 200)
            }
        }
        .windowResizability(.contentSize)
    }
}
