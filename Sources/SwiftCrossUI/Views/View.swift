/// A view that can be rendered by any backend.
public protocol View {
    /// The view's content (composed of other views).
    associatedtype Content: View
    /// The view's observed state.
    associatedtype State: Observable

    /// The views observed state. Any observed changes cause ``View/body`` to be recomputed,
    /// and the view itself to be updated.
    var state: State { get set }

    /// The view's contents.
    @ViewBuilder var body: Content { get }

    /// Gets the view's children as a type-erased collection of view graph nodes. Type-erased
    /// to avoid leaking complex requirements to users implementing their own regular views.
    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> any ViewGraphNodeChildren

    // TODO: Perhaps this can be split off into a separate protocol for the `TupleViewN`s
    //   if we can set up the generics right for VStack.
    /// Gets the view's children in a format that can be consumed by the ``LayoutSystem``.
    /// This really only needs to be its own method for views such as VStack which treat
    /// their child's children as their own and skip over their direct child. Only needs to
    /// be implemented by the `TupleViewN`s.
    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: any ViewGraphNodeChildren
    ) -> [LayoutSystem.LayoutableChild]

    /// Creates the view's widget using the supplied backend.
    ///
    /// A view is represented by the same widget instance for the whole time that it's visible even
    /// if its content is changing; keep that in mind while deciding the structure of the widget.
    /// For example, a view displaying one of two children should use ``AppBackend/createContainer()``
    /// to create a container for the displayed child instead of just directly returning the widget
    /// of the currently displayed child (which would result in you not being able to ever switch
    /// to displaying the other child). This constraint significantly simplifies view implementations
    /// without requiring widgets to be re-created after every single update.
    func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget

    /// Updates the view's widget after a state change occurs (although the change isn't guaranteed
    /// to have affected this particular view). `proposedSize` is the size suggested by the parent
    /// container, but child views always get the final call on their own size.
    ///
    /// Always called once immediately after creating the view's widget with. This helps reduce
    /// code duplication between `asWidget` and `update`.
    /// - Parameter dryRun: If `true`, avoids updating the UI and only computes sizing.
    /// - Returns: The view's new size.
    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize
}

extension View {
    public func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> any ViewGraphNodeChildren {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    public func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: any ViewGraphNodeChildren
    ) -> [LayoutSystem.LayoutableChild] {
        body.layoutableChildren(backend: backend, children: children)
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        let vStack = VStack(content: body)
        return vStack.asWidget(children, backend: backend)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        let vStack = VStack(content: body)
        return vStack.update(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend,
            dryRun: dryRun
        )
    }
}

extension View where State == EmptyState {
    // swiftlint:disable unused_setter_value
    public var state: State {
        get {
            EmptyState()
        }
        set {
            return
        }
    }
    // swiftlint:enable unused_setter_value
}
