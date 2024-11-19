import CGtk3

/// The #GtkEntry widget is a single line text entry
/// widget. A fairly large set of key bindings are supported
/// by default. If the entered text is longer than the allocation
/// of the widget, the widget will scroll so that the cursor
/// position is visible.
///
/// When using an entry for passwords and other sensitive information,
/// it can be put into “password mode” using gtk_entry_set_visibility().
/// In this mode, entered text is displayed using a “invisible” character.
/// By default, GTK+ picks the best invisible character that is available
/// in the current font, but it can be changed with
/// gtk_entry_set_invisible_char(). Since 2.16, GTK+ displays a warning
/// when Caps Lock or input methods might interfere with entering text in
/// a password entry. The warning can be turned off with the
/// #GtkEntry:caps-lock-warning property.
///
/// Since 2.16, GtkEntry has the ability to display progress or activity
/// information behind the text. To make an entry display such information,
/// use gtk_entry_set_progress_fraction() or gtk_entry_set_progress_pulse_step().
///
/// Additionally, GtkEntry can show icons at either side of the entry. These
/// icons can be activatable by clicking, can be set up as drag source and
/// can have tooltips. To add an icon, use gtk_entry_set_icon_from_gicon() or
/// one of the various other functions that set an icon from a stock id, an
/// icon name or a pixbuf. To trigger an action when the user clicks an icon,
/// connect to the #GtkEntry::icon-press signal. To allow DND operations
/// from an icon, use gtk_entry_set_icon_drag_source(). To set a tooltip on
/// an icon, use gtk_entry_set_icon_tooltip_text() or the corresponding function
/// for markup.
///
/// Note that functionality or information that is only available by clicking
/// on an icon in an entry may not be accessible at all to users which are not
/// able to use a mouse or other pointing device. It is therefore recommended
/// that any such functionality should also be available by other means, e.g.
/// via the context menu of the entry.
///
/// # CSS nodes
///
/// |[<!-- language="plain" -->
/// entry[.read-only][.flat][.warning][.error]
/// ├── image.left
/// ├── image.right
/// ├── undershoot.left
/// ├── undershoot.right
/// ├── [selection]
/// ├── [progress[.pulse]]
/// ╰── [window.popup]
/// ]|
///
/// GtkEntry has a main node with the name entry. Depending on the properties
/// of the entry, the style classes .read-only and .flat may appear. The style
/// classes .warning and .error may also be used with entries.
///
/// When the entry shows icons, it adds subnodes with the name image and the
/// style class .left or .right, depending on where the icon appears.
///
/// When the entry has a selection, it adds a subnode with the name selection.
///
/// When the entry shows progress, it adds a subnode with the name progress.
/// The node has the style class .pulse when the shown progress is pulsing.
///
/// The CSS node for a context menu is added as a subnode below entry as well.
///
/// The undershoot nodes are used to draw the underflow indication when content
/// is scrolled out of view. These nodes get the .left and .right style classes
/// added depending on where the indication is drawn.
///
/// When touch is used and touch selection handles are shown, they are using
/// CSS nodes with name cursor-handle. They get the .top or .bottom style class
/// depending on where they are shown in relation to the selection. If there is
/// just a single handle for the text cursor, it gets the style class
/// .insertion-cursor.
public class Entry: Widget, CellEditable, Editable {
    /// Creates a new entry.
    override public init() {
        super.init()
        widgetPointer = gtk_entry_new()
    }

    /// Creates a new entry with the specified text buffer.
    public init(buffer: UnsafeMutablePointer<GtkEntryBuffer>!) {
        super.init()
        widgetPointer = gtk_entry_new_with_buffer(buffer)
    }

    override func didMoveToParent() {
        removeSignals()

        super.didMoveToParent()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
        }

        addSignal(name: "backspace") { [weak self] () in
            guard let self = self else { return }
            self.backspace?(self)
        }

        addSignal(name: "copy-clipboard") { [weak self] () in
            guard let self = self else { return }
            self.copyClipboard?(self)
        }

        addSignal(name: "cut-clipboard") { [weak self] () in
            guard let self = self else { return }
            self.cutClipboard?(self)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, GtkDeleteType, Int, UnsafeMutableRawPointer) ->
                Void =
                { _, value1, value2, data in
                    SignalBox2<GtkDeleteType, Int>.run(data, value1, value2)
                }

        addSignal(name: "delete-from-cursor", handler: gCallback(handler4)) {
            [weak self] (_: GtkDeleteType, _: Int) in
            guard let self = self else { return }
            self.deleteFromCursor?(self)
        }

        let handler5:
            @convention(c) (
                UnsafeMutableRawPointer, GtkEntryIconPosition, GdkEvent, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, data in
                    SignalBox2<GtkEntryIconPosition, GdkEvent>.run(data, value1, value2)
                }

        addSignal(name: "icon-press", handler: gCallback(handler5)) {
            [weak self] (_: GtkEntryIconPosition, _: GdkEvent) in
            guard let self = self else { return }
            self.iconPress?(self)
        }

        let handler6:
            @convention(c) (
                UnsafeMutableRawPointer, GtkEntryIconPosition, GdkEvent, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, data in
                    SignalBox2<GtkEntryIconPosition, GdkEvent>.run(data, value1, value2)
                }

        addSignal(name: "icon-release", handler: gCallback(handler6)) {
            [weak self] (_: GtkEntryIconPosition, _: GdkEvent) in
            guard let self = self else { return }
            self.iconRelease?(self)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CChar>, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<UnsafePointer<CChar>>.run(data, value1)
                }

        addSignal(name: "insert-at-cursor", handler: gCallback(handler7)) {
            [weak self] (_: UnsafePointer<CChar>) in
            guard let self = self else { return }
            self.insertAtCursor?(self)
        }

        addSignal(name: "insert-emoji") { [weak self] () in
            guard let self = self else { return }
            self.insertEmoji?(self)
        }

        let handler9:
            @convention(c) (
                UnsafeMutableRawPointer, GtkMovementStep, Int, Bool, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, value3, data in
                    SignalBox3<GtkMovementStep, Int, Bool>.run(data, value1, value2, value3)
                }

        addSignal(name: "move-cursor", handler: gCallback(handler9)) {
            [weak self] (_: GtkMovementStep, _: Int, _: Bool) in
            guard let self = self else { return }
            self.moveCursor?(self)
        }

        addSignal(name: "paste-clipboard") { [weak self] () in
            guard let self = self else { return }
            self.pasteClipboard?(self)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, GtkWidget, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<GtkWidget>.run(data, value1)
                }

        addSignal(name: "populate-popup", handler: gCallback(handler11)) {
            [weak self] (_: GtkWidget) in
            guard let self = self else { return }
            self.populatePopup?(self)
        }

        let handler12:
            @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CChar>, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<UnsafePointer<CChar>>.run(data, value1)
                }

        addSignal(name: "preedit-changed", handler: gCallback(handler12)) {
            [weak self] (_: UnsafePointer<CChar>) in
            guard let self = self else { return }
            self.preeditChanged?(self)
        }

        addSignal(name: "toggle-overwrite") { [weak self] () in
            guard let self = self else { return }
            self.toggleOverwrite?(self)
        }

        addSignal(name: "editing-done") { [weak self] () in
            guard let self = self else { return }
            self.editingDone?(self)
        }

        addSignal(name: "remove-widget") { [weak self] () in
            guard let self = self else { return }
            self.removeWidget?(self)
        }

        addSignal(name: "changed") { [weak self] () in
            guard let self = self else { return }
            self.changed?(self)
        }

        let handler17:
            @convention(c) (UnsafeMutableRawPointer, Int, Int, UnsafeMutableRawPointer) -> Void =
                { _, value1, value2, data in
                    SignalBox2<Int, Int>.run(data, value1, value2)
                }

        addSignal(name: "delete-text", handler: gCallback(handler17)) {
            [weak self] (_: Int, _: Int) in
            guard let self = self else { return }
            self.deleteText?(self)
        }

        let handler18:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafePointer<CChar>, Int, gpointer,
                UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, value3, data in
                    SignalBox3<UnsafePointer<CChar>, Int, gpointer>.run(
                        data, value1, value2, value3)
                }

        addSignal(name: "insert-text", handler: gCallback(handler18)) {
            [weak self] (_: UnsafePointer<CChar>, _: Int, _: gpointer) in
            guard let self = self else { return }
            self.insertText?(self)
        }

        let handler19:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::activates-default", handler: gCallback(handler19)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyActivatesDefault?(self)
        }

        let handler20:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::attributes", handler: gCallback(handler20)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAttributes?(self)
        }

        let handler21:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::buffer", handler: gCallback(handler21)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyBuffer?(self)
        }

        let handler22:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::caps-lock-warning", handler: gCallback(handler22)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCapsLockWarning?(self)
        }

        let handler23:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::completion", handler: gCallback(handler23)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCompletion?(self)
        }

        let handler24:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::cursor-position", handler: gCallback(handler24)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCursorPosition?(self)
        }

        let handler25:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::editable", handler: gCallback(handler25)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEditable?(self)
        }

        let handler26:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::enable-emoji-completion", handler: gCallback(handler26)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEnableEmojiCompletion?(self)
        }

        let handler27:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::has-frame", handler: gCallback(handler27)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHasFrame?(self)
        }

        let handler28:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::im-module", handler: gCallback(handler28)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyImModule?(self)
        }

        let handler29:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::inner-border", handler: gCallback(handler29)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInnerBorder?(self)
        }

        let handler30:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::input-hints", handler: gCallback(handler30)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInputHints?(self)
        }

        let handler31:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::input-purpose", handler: gCallback(handler31)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInputPurpose?(self)
        }

        let handler32:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::invisible-char", handler: gCallback(handler32)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInvisibleCharacter?(self)
        }

        let handler33:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::invisible-char-set", handler: gCallback(handler33)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInvisibleCharacterSet?(self)
        }

        let handler34:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::max-length", handler: gCallback(handler34)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMaxLength?(self)
        }

        let handler35:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::max-width-chars", handler: gCallback(handler35)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMaxWidthChars?(self)
        }

        let handler36:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::overwrite-mode", handler: gCallback(handler36)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyOverwriteMode?(self)
        }

        let handler37:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::placeholder-text", handler: gCallback(handler37)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPlaceholderText?(self)
        }

        let handler38:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::populate-all", handler: gCallback(handler38)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPopulateAll?(self)
        }

        let handler39:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-activatable", handler: gCallback(handler39)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconActivatable?(self)
        }

        let handler40:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-gicon", handler: gCallback(handler40)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconGicon?(self)
        }

        let handler41:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-name", handler: gCallback(handler41)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconName?(self)
        }

        let handler42:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-pixbuf", handler: gCallback(handler42)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconPixbuf?(self)
        }

        let handler43:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-sensitive", handler: gCallback(handler43)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconSensitive?(self)
        }

        let handler44:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-stock", handler: gCallback(handler44)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconStock?(self)
        }

        let handler45:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-storage-type", handler: gCallback(handler45)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconStorageType?(self)
        }

        let handler46:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-tooltip-markup", handler: gCallback(handler46)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconTooltipMarkup?(self)
        }

        let handler47:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-tooltip-text", handler: gCallback(handler47)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconTooltipText?(self)
        }

        let handler48:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::progress-fraction", handler: gCallback(handler48)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyProgressFraction?(self)
        }

        let handler49:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::progress-pulse-step", handler: gCallback(handler49)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyProgressPulseStep?(self)
        }

        let handler50:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::scroll-offset", handler: gCallback(handler50)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyScrollOffset?(self)
        }

        let handler51:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-activatable", handler: gCallback(handler51)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconActivatable?(self)
        }

        let handler52:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-gicon", handler: gCallback(handler52)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconGicon?(self)
        }

        let handler53:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-name", handler: gCallback(handler53)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconName?(self)
        }

        let handler54:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-pixbuf", handler: gCallback(handler54)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconPixbuf?(self)
        }

        let handler55:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-sensitive", handler: gCallback(handler55)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconSensitive?(self)
        }

        let handler56:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-stock", handler: gCallback(handler56)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconStock?(self)
        }

        let handler57:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-storage-type", handler: gCallback(handler57)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconStorageType?(self)
        }

        let handler58:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-tooltip-markup", handler: gCallback(handler58)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconTooltipMarkup?(self)
        }

        let handler59:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-tooltip-text", handler: gCallback(handler59)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconTooltipText?(self)
        }

        let handler60:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selection-bound", handler: gCallback(handler60)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectionBound?(self)
        }

        let handler61:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::shadow-type", handler: gCallback(handler61)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShadowType?(self)
        }

        let handler62:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::show-emoji-icon", handler: gCallback(handler62)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShowEmojiIcon?(self)
        }

        let handler63:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::tabs", handler: gCallback(handler63)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTabs?(self)
        }

        let handler64:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::text", handler: gCallback(handler64)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyText?(self)
        }

        let handler65:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::text-length", handler: gCallback(handler65)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTextLength?(self)
        }

        let handler66:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::truncate-multiline", handler: gCallback(handler66)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTruncateMultiline?(self)
        }

        let handler67:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::visibility", handler: gCallback(handler67)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyVisibility?(self)
        }

        let handler68:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::width-chars", handler: gCallback(handler68)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWidthChars?(self)
        }

        let handler69:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::xalign", handler: gCallback(handler69)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyXalign?(self)
        }

        let handler70:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::editing-canceled", handler: gCallback(handler70)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEditingCanceled?(self)
        }
    }

    @GObjectProperty(named: "activates-default") public var activatesDefault: Bool

    @GObjectProperty(named: "has-frame") public var hasFrame: Bool

    @GObjectProperty(named: "max-length") public var maxLength: Int

    /// The text that will be displayed in the #GtkEntry when it is empty
    /// and unfocused.
    @GObjectProperty(named: "placeholder-text") public var placeholderText: String

    @GObjectProperty(named: "text") public var text: String

    @GObjectProperty(named: "visibility") public var visibility: Bool

    @GObjectProperty(named: "width-chars") public var widthChars: Int

    /// The ::activate signal is emitted when the user hits
    /// the Enter key.
    ///
    /// While this signal is used as a
    /// [keybinding signal][GtkBindingSignal],
    /// it is also commonly used by applications to intercept
    /// activation of entries.
    ///
    /// The default bindings for this signal are all forms of the Enter key.
    public var activate: ((Entry) -> Void)?

    /// The ::backspace signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user asks for it.
    ///
    /// The default bindings for this signal are
    /// Backspace and Shift-Backspace.
    public var backspace: ((Entry) -> Void)?

    /// The ::copy-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to copy the selection to the clipboard.
    ///
    /// The default bindings for this signal are
    /// Ctrl-c and Ctrl-Insert.
    public var copyClipboard: ((Entry) -> Void)?

    /// The ::cut-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to cut the selection to the clipboard.
    ///
    /// The default bindings for this signal are
    /// Ctrl-x and Shift-Delete.
    public var cutClipboard: ((Entry) -> Void)?

    /// The ::delete-from-cursor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates a text deletion.
    ///
    /// If the @type is %GTK_DELETE_CHARS, GTK+ deletes the selection
    /// if there is one, otherwise it deletes the requested number
    /// of characters.
    ///
    /// The default bindings for this signal are
    /// Delete for deleting a character and Ctrl-Delete for
    /// deleting a word.
    public var deleteFromCursor: ((Entry) -> Void)?

    /// The ::icon-press signal is emitted when an activatable icon
    /// is clicked.
    public var iconPress: ((Entry) -> Void)?

    /// The ::icon-release signal is emitted on the button release from a
    /// mouse click over an activatable icon.
    public var iconRelease: ((Entry) -> Void)?

    /// The ::insert-at-cursor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates the insertion of a
    /// fixed string at the cursor.
    ///
    /// This signal has no default bindings.
    public var insertAtCursor: ((Entry) -> Void)?

    /// The ::insert-emoji signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to present the Emoji chooser for the @entry.
    ///
    /// The default bindings for this signal are Ctrl-. and Ctrl-;
    public var insertEmoji: ((Entry) -> Void)?

    /// The ::move-cursor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates a cursor movement.
    /// If the cursor is not visible in @entry, this signal causes
    /// the viewport to be moved instead.
    ///
    /// Applications should not connect to it, but may emit it with
    /// g_signal_emit_by_name() if they need to control the cursor
    /// programmatically.
    ///
    /// The default bindings for this signal come in two variants,
    /// the variant with the Shift modifier extends the selection,
    /// the variant without the Shift modifer does not.
    /// There are too many key combinations to list them all here.
    /// - Arrow keys move by individual characters/lines
    /// - Ctrl-arrow key combinations move by words/paragraphs
    /// - Home/End keys move to the ends of the buffer
    public var moveCursor: ((Entry) -> Void)?

    /// The ::paste-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to paste the contents of the clipboard
    /// into the text view.
    ///
    /// The default bindings for this signal are
    /// Ctrl-v and Shift-Insert.
    public var pasteClipboard: ((Entry) -> Void)?

    /// The ::populate-popup signal gets emitted before showing the
    /// context menu of the entry.
    ///
    /// If you need to add items to the context menu, connect
    /// to this signal and append your items to the @widget, which
    /// will be a #GtkMenu in this case.
    ///
    /// If #GtkEntry:populate-all is %TRUE, this signal will
    /// also be emitted to populate touch popups. In this case,
    /// @widget will be a different container, e.g. a #GtkToolbar.
    /// The signal handler should not make assumptions about the
    /// type of @widget.
    public var populatePopup: ((Entry) -> Void)?

    /// If an input method is used, the typed text will not immediately
    /// be committed to the buffer. So if you are interested in the text,
    /// connect to this signal.
    public var preeditChanged: ((Entry) -> Void)?

    /// The ::toggle-overwrite signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to toggle the overwrite mode of the entry.
    ///
    /// The default bindings for this signal is Insert.
    public var toggleOverwrite: ((Entry) -> Void)?

    /// This signal is a sign for the cell renderer to update its
    /// value from the @cell_editable.
    ///
    /// Implementations of #GtkCellEditable are responsible for
    /// emitting this signal when they are done editing, e.g.
    /// #GtkEntry emits this signal when the user presses Enter. Typical things to
    /// do in a handler for ::editing-done are to capture the edited value,
    /// disconnect the @cell_editable from signals on the #GtkCellRenderer, etc.
    ///
    /// gtk_cell_editable_editing_done() is a convenience method
    /// for emitting #GtkCellEditable::editing-done.
    public var editingDone: ((Entry) -> Void)?

    /// This signal is meant to indicate that the cell is finished
    /// editing, and the @cell_editable widget is being removed and may
    /// subsequently be destroyed.
    ///
    /// Implementations of #GtkCellEditable are responsible for
    /// emitting this signal when they are done editing. It must
    /// be emitted after the #GtkCellEditable::editing-done signal,
    /// to give the cell renderer a chance to update the cell's value
    /// before the widget is removed.
    ///
    /// gtk_cell_editable_remove_widget() is a convenience method
    /// for emitting #GtkCellEditable::remove-widget.
    public var removeWidget: ((Entry) -> Void)?

    /// The ::changed signal is emitted at the end of a single
    /// user-visible operation on the contents of the #GtkEditable.
    ///
    /// E.g., a paste operation that replaces the contents of the
    /// selection will cause only one signal emission (even though it
    /// is implemented by first deleting the selection, then inserting
    /// the new content, and may cause multiple ::notify::text signals
    /// to be emitted).
    public var changed: ((Entry) -> Void)?

    /// This signal is emitted when text is deleted from
    /// the widget by the user. The default handler for
    /// this signal will normally be responsible for deleting
    /// the text, so by connecting to this signal and then
    /// stopping the signal with g_signal_stop_emission(), it
    /// is possible to modify the range of deleted text, or
    /// prevent it from being deleted entirely. The @start_pos
    /// and @end_pos parameters are interpreted as for
    /// gtk_editable_delete_text().
    public var deleteText: ((Entry) -> Void)?

    /// This signal is emitted when text is inserted into
    /// the widget by the user. The default handler for
    /// this signal will normally be responsible for inserting
    /// the text, so by connecting to this signal and then
    /// stopping the signal with g_signal_stop_emission(), it
    /// is possible to modify the inserted text, or prevent
    /// it from being inserted entirely.
    public var insertText: ((Entry) -> Void)?

    public var notifyActivatesDefault: ((Entry) -> Void)?

    public var notifyAttributes: ((Entry) -> Void)?

    public var notifyBuffer: ((Entry) -> Void)?

    public var notifyCapsLockWarning: ((Entry) -> Void)?

    public var notifyCompletion: ((Entry) -> Void)?

    public var notifyCursorPosition: ((Entry) -> Void)?

    public var notifyEditable: ((Entry) -> Void)?

    public var notifyEnableEmojiCompletion: ((Entry) -> Void)?

    public var notifyHasFrame: ((Entry) -> Void)?

    public var notifyImModule: ((Entry) -> Void)?

    public var notifyInnerBorder: ((Entry) -> Void)?

    public var notifyInputHints: ((Entry) -> Void)?

    public var notifyInputPurpose: ((Entry) -> Void)?

    public var notifyInvisibleCharacter: ((Entry) -> Void)?

    public var notifyInvisibleCharacterSet: ((Entry) -> Void)?

    public var notifyMaxLength: ((Entry) -> Void)?

    public var notifyMaxWidthChars: ((Entry) -> Void)?

    public var notifyOverwriteMode: ((Entry) -> Void)?

    public var notifyPlaceholderText: ((Entry) -> Void)?

    public var notifyPopulateAll: ((Entry) -> Void)?

    public var notifyPrimaryIconActivatable: ((Entry) -> Void)?

    public var notifyPrimaryIconGicon: ((Entry) -> Void)?

    public var notifyPrimaryIconName: ((Entry) -> Void)?

    public var notifyPrimaryIconPixbuf: ((Entry) -> Void)?

    public var notifyPrimaryIconSensitive: ((Entry) -> Void)?

    public var notifyPrimaryIconStock: ((Entry) -> Void)?

    public var notifyPrimaryIconStorageType: ((Entry) -> Void)?

    public var notifyPrimaryIconTooltipMarkup: ((Entry) -> Void)?

    public var notifyPrimaryIconTooltipText: ((Entry) -> Void)?

    public var notifyProgressFraction: ((Entry) -> Void)?

    public var notifyProgressPulseStep: ((Entry) -> Void)?

    public var notifyScrollOffset: ((Entry) -> Void)?

    public var notifySecondaryIconActivatable: ((Entry) -> Void)?

    public var notifySecondaryIconGicon: ((Entry) -> Void)?

    public var notifySecondaryIconName: ((Entry) -> Void)?

    public var notifySecondaryIconPixbuf: ((Entry) -> Void)?

    public var notifySecondaryIconSensitive: ((Entry) -> Void)?

    public var notifySecondaryIconStock: ((Entry) -> Void)?

    public var notifySecondaryIconStorageType: ((Entry) -> Void)?

    public var notifySecondaryIconTooltipMarkup: ((Entry) -> Void)?

    public var notifySecondaryIconTooltipText: ((Entry) -> Void)?

    public var notifySelectionBound: ((Entry) -> Void)?

    public var notifyShadowType: ((Entry) -> Void)?

    public var notifyShowEmojiIcon: ((Entry) -> Void)?

    public var notifyTabs: ((Entry) -> Void)?

    public var notifyText: ((Entry) -> Void)?

    public var notifyTextLength: ((Entry) -> Void)?

    public var notifyTruncateMultiline: ((Entry) -> Void)?

    public var notifyVisibility: ((Entry) -> Void)?

    public var notifyWidthChars: ((Entry) -> Void)?

    public var notifyXalign: ((Entry) -> Void)?

    public var notifyEditingCanceled: ((Entry) -> Void)?
}