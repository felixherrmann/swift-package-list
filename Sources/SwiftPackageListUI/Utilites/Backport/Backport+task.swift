//
//  Backport+task.swift
//  SwiftPackageListUI
//
//  Created by Felix Herrmann on 02.01.24.
//

#if os(macOS)

import SwiftUI

@available(macOS, deprecated: 12.0, message: "Back-port no longer needed with macOS 12")
internal struct TaskModifier: ViewModifier {
    internal let priority: TaskPriority
    internal let action: @Sendable () async -> Void

    @State private var currentTask: Task<Void, Never>?

    internal func body(content: Content) -> some View {
        content
            .onAppear {
                currentTask = Task(priority: priority, operation: action)
            }
            .onDisappear {
                currentTask?.cancel()
            }
    }
}

extension Backport where Content: View {
    @MainActor
    @ViewBuilder
    internal func task(
        priority: TaskPriority = .userInitiated,
        @_inheritActorContext _ action: @escaping @Sendable () async -> Void
    ) -> some View {
        if #available(macOS 12.0, *) {
            content.task(priority: priority) {
                await action()
            }
        } else {
            content.modifier(TaskModifier(priority: priority, action: action))
        }
    }
}

#endif // os(macOS)
