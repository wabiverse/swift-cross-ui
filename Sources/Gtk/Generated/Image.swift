import CGtk

/// The `GtkImage` widget displays an image.
///
/// ![An example GtkImage](image.png)
///
/// Various kinds of object can be displayed as an image; most typically,
/// you would load a `GdkTexture` from a file, using the convenience function
/// [ctor@Gtk.Image.new_from_file], for instance:
///
/// ```c
/// GtkWidget *image = gtk_image_new_from_file ("myfile.png");
/// ```
///
/// If the file isn’t loaded successfully, the image will contain a
/// “broken image” icon similar to that used in many web browsers.
///
/// If you want to handle errors in loading the file yourself,
/// for example by displaying an error message, then load the image with
/// [ctor@Gdk.Texture.new_from_file], then create the `GtkImage` with
/// [ctor@Gtk.Image.new_from_paintable].
///
/// Sometimes an application will want to avoid depending on external data
/// files, such as image files. See the documentation of `GResource` inside
/// GIO, for details. In this case, [property@Gtk.Image:resource],
/// [ctor@Gtk.Image.new_from_resource], and [method@Gtk.Image.set_from_resource]
/// should be used.
///
/// `GtkImage` displays its image as an icon, with a size that is determined
/// by the application. See [class@Gtk.Picture] if you want to show an image
/// at is actual size.
///
/// ## CSS nodes
///
/// `GtkImage` has a single CSS node with the name `image`. The style classes
/// `.normal-icons` or `.large-icons` may appear, depending on the
/// [property@Gtk.Image:icon-size] property.
///
/// ## Accessibility
///
/// `GtkImage` uses the `GTK_ACCESSIBLE_ROLE_IMG` role.
public class Image: Widget {
    /// Creates a new empty `GtkImage` widget.
    override public init() {
        super.init()
        widgetPointer = gtk_image_new()
    }

    /// Creates a new `GtkImage` displaying the file @filename.
    ///
    /// If the file isn’t found or can’t be loaded, the resulting `GtkImage`
    /// will display a “broken image” icon. This function never returns %NULL,
    /// it always returns a valid `GtkImage` widget.
    ///
    /// If you need to detect failures to load the file, use
    /// [ctor@Gdk.Texture.new_from_file] to load the file yourself,
    /// then create the `GtkImage` from the texture.
    ///
    /// The storage type (see [method@Gtk.Image.get_storage_type])
    /// of the returned image is not defined, it will be whatever
    /// is appropriate for displaying the file.
    public init(filename: String) {
        super.init()
        widgetPointer = gtk_image_new_from_file(filename)
    }

    /// Creates a `GtkImage` displaying an icon from the current icon theme.
    ///
    /// If the icon name isn’t known, a “broken image” icon will be
    /// displayed instead. If the current icon theme is changed, the icon
    /// will be updated appropriately.
    public init(icon: OpaquePointer) {
        super.init()
        widgetPointer = gtk_image_new_from_gicon(icon)
    }

    /// Creates a `GtkImage` displaying an icon from the current icon theme.
    ///
    /// If the icon name isn’t known, a “broken image” icon will be
    /// displayed instead. If the current icon theme is changed, the icon
    /// will be updated appropriately.
    public init(iconName: String) {
        super.init()
        widgetPointer = gtk_image_new_from_icon_name(iconName)
    }

    /// Creates a new `GtkImage` displaying @paintable.
    ///
    /// The `GtkImage` does not assume a reference to the paintable; you still
    /// need to unref it if you own references. `GtkImage` will add its own
    /// reference rather than adopting yours.
    ///
    /// The `GtkImage` will track changes to the @paintable and update
    /// its size and contents in response to it.
    public init(paintable: OpaquePointer) {
        super.init()
        widgetPointer = gtk_image_new_from_paintable(paintable)
    }

    /// Creates a new `GtkImage` displaying the resource file @resource_path.
    ///
    /// If the file isn’t found or can’t be loaded, the resulting `GtkImage` will
    /// display a “broken image” icon. This function never returns %NULL,
    /// it always returns a valid `GtkImage` widget.
    ///
    /// If you need to detect failures to load the file, use
    /// [ctor@GdkPixbuf.Pixbuf.new_from_file] to load the file yourself,
    /// then create the `GtkImage` from the pixbuf.
    ///
    /// The storage type (see [method@Gtk.Image.get_storage_type]) of
    /// the returned image is not defined, it will be whatever is
    /// appropriate for displaying the file.
    public init(resourcePath: String) {
        super.init()
        widgetPointer = gtk_image_new_from_resource(resourcePath)
    }

    override func didMoveToParent() {
        removeSignals()

        super.didMoveToParent()

        let handler0:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::file", handler: gCallback(handler0)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyFile?(self)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::gicon", handler: gCallback(handler1)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyGicon?(self)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::icon-name", handler: gCallback(handler2)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyIconName?(self)
        }

        let handler3:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::icon-size", handler: gCallback(handler3)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyIconSize?(self)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::paintable", handler: gCallback(handler4)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPaintable?(self)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::pixel-size", handler: gCallback(handler5)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPixelSize?(self)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::resource", handler: gCallback(handler6)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyResource?(self)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::storage-type", handler: gCallback(handler7)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyStorageType?(self)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-fallback", handler: gCallback(handler8)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseFallback?(self)
        }
    }

    /// The name of the icon in the icon theme.
    ///
    /// If the icon theme is changed, the image will be updated automatically.
    @GObjectProperty(named: "icon-name") public var iconName: String?

    /// The symbolic size to display icons at.
    @GObjectProperty(named: "icon-size") public var iconSize: IconSize

    /// The size in pixels to display icons at.
    ///
    /// If set to a value != -1, this property overrides the
    /// [property@Gtk.Image:icon-size] property for images of type
    /// `GTK_IMAGE_ICON_NAME`.
    @GObjectProperty(named: "pixel-size") public var pixelSize: Int

    /// The representation being used for image data.
    @GObjectProperty(named: "storage-type") public var storageType: ImageType

    public var notifyFile: ((Image) -> Void)?

    public var notifyGicon: ((Image) -> Void)?

    public var notifyIconName: ((Image) -> Void)?

    public var notifyIconSize: ((Image) -> Void)?

    public var notifyPaintable: ((Image) -> Void)?

    public var notifyPixelSize: ((Image) -> Void)?

    public var notifyResource: ((Image) -> Void)?

    public var notifyStorageType: ((Image) -> Void)?

    public var notifyUseFallback: ((Image) -> Void)?
}
