import Foundation

/// A view which erases the type of its child. Useful in dynamic
/// use-cases such as hot reloading, but not recommended if there
/// are alternate strongly-typed solutions to your problem since
/// ``AnyView`` has significantly more overhead than strongly
/// typed views.
public struct AnyView: TypeSafeView {
    typealias Children = AnyViewChildren

    public var body = EmptyView()

    var child: any View

    public init(_ child: any View) {
        self.child = child
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> AnyViewChildren {
        let snapshot = snapshots?.count == 1 ? snapshots?.first : nil
        return AnyViewChildren(
            from: self,
            backend: backend,
            snapshot: snapshot,
            environment: environment
        )
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: AnyViewChildren
    ) -> [LayoutSystem.LayoutableChild] {
        // TODO: Figure out a convention for views like this where ``layoutableChildren`` will
        //   never get used unless something has already gone pretty wrong.
        body.layoutableChildren(backend: backend, children: children)
    }

    func asWidget<Backend: AppBackend>(
        _ children: AnyViewChildren,
        backend: Backend
    ) -> Backend.Widget {
        let container = backend.createContainer()
        backend.addChild(children.node.getWidget().into(), to: container)
        backend.setPosition(ofChildAt: 0, in: container, to: .zero)
        return container
    }

    /// Attempts to update the child. If the initial update fails then it means that the child's
    /// concrete type has changed and we must recreate the child node and swap out our current
    /// child widget with the new view's widget.
    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: AnyViewChildren,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        var (viewTypesMatched, size) = children.node.updateWithNewView(
            child,
            proposedSize,
            environment,
            dryRun
        )

        // If the new view's type doesn't match the old view's type then we need to create a new
        // view graph node for the new view.
        if !viewTypesMatched {
            children.widgetToReplace = children.node.getWidget()
            children.node = ErasedViewGraphNode(
                for: child,
                backend: backend,
                environment: environment
            )

            // We can just assume that the update succeeded because we just created the node
            // a few lines earlier (so it's guaranteed that the view types match).
            let result = children.node.updateWithNewView(
                child,
                proposedSize,
                environment,
                dryRun
            )
            size = result.size
        }

        // If the child view has changed types and this isn't a dry-run then switch to displaying
        // the new child widget.
        if !dryRun, let widgetToReplace = children.widgetToReplace {
            backend.removeChild(widgetToReplace.into(), from: widget)
            backend.addChild(children.node.getWidget().into(), to: widget)
            backend.setPosition(ofChildAt: 0, in: widget, to: .zero)
            children.widgetToReplace = nil
        }

        if !dryRun {
            backend.setSize(of: widget, to: size.size)
        }

        return size
    }
}

class AnyViewChildren: ViewGraphNodeChildren {
    /// The erased underlying node.
    var node: ErasedViewGraphNode
    /// If the displayed view changed during a dry-run update then this stores the widget of the replaced view.
    var widgetToReplace: AnyWidget?

    var widgets: [AnyWidget] {
        return [node.getWidget()]
    }

    var erasedNodes: [ErasedViewGraphNode] {
        [node]
    }

    /// Creates the erased child node and wraps the child's widget in a single-child container.
    init<Backend: AppBackend>(
        from view: AnyView,
        backend: Backend,
        snapshot: ViewGraphSnapshotter.NodeSnapshot?,
        environment: Environment
    ) {
        node = ErasedViewGraphNode(
            for: view.child,
            backend: backend,
            snapshot: snapshot,
            environment: environment
        )
    }
}
