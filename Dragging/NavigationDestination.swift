import SwiftUI

struct NavigationDestination: View {
    let title: String
    let content: () -> AnyView

    init(title: String, content: @escaping () -> some View) {
        self.title = title
        self.content = { AnyView(content()) }
    }

    var body: some View {
        NavigationLink(title) {
            content().navigationTitle(title)
        }
    }
}
