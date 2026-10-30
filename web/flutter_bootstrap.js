{{flutter_js}}
{{flutter_build_config}}

const userConfig = {
  renderer: "canvaskit",
  useLocalCanvasKit: true,
  canvasKitBaseUrl: "canvaskit/"
};

_flutter.loader.load({
  config: userConfig,
  onEntrypointLoaded: async function(engineInitializer) {
    try {
      const appRunner = await engineInitializer.initializeEngine(userConfig);
      await appRunner.runApp();
    } finally {
      if (typeof window.hideLoader === "function") {
        window.hideLoader();
      }
    }
  }
});
