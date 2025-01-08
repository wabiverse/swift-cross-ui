import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

class ControlsState: Observable {
    @Observed var count = 0
    @Observed var exampleButtonState = false
    @Observed var exampleSwitchState = false
    @Observed var sliderValue = 5.0
}

@main
@HotReloadable
struct ControlsApp: App {
    let state = ControlsState()

    var body: some Scene {
        WindowGroup("ControlsApp") {
            #hotReloadable {
                VStack {
                    VStack {
                        Text("Button")
                        Button("Click me!") {
                            state.count += 1
                        }
                        Text("Count: \(state.count)")
                    }
                    .padding(.bottom, 20)

                    VStack {
                        Text("Toggle button")
                        Toggle("Toggle me!", active: state.$exampleButtonState)
                            .toggleStyle(.button)
                        Text("Currently enabled: \(state.exampleButtonState)")
                    }
                    .padding(.bottom, 20)

                    VStack {
                        Text("Toggle switch")
                        Toggle("Toggle me:", active: state.$exampleSwitchState)
                            .toggleStyle(.switch)
                        Text("Currently enabled: \(state.exampleSwitchState)")
                    }

                    VStack {
                        Text("Slider")
                        Slider(state.$sliderValue, minimum: 0, maximum: 10)
                            .frame(maxWidth: 200)
                        Text("Value: \(String(format: "%.02f", state.sliderValue))")
                    }
                }
            }
        }
    }
}
