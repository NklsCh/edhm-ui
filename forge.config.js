const { FusesPlugin } = require( '@electron-forge/plugin-fuses' );
const { FuseV1Options, FuseVersion } = require( '@electron/fuses' );
const path = require( 'path' );

// For Linux
module.exports = {
  packagerConfig: {
    asar: true,
    executableName: 'edhm-ui-v3',
    icon: 'public/images/icon.png',
    extraResource: [
      'src/data',
      'src/images',
      'public',
    ],
    buildIdentifier: 'production' // Add build identifier
  },
  rebuildConfig: {},
  makers: [
    {
      name: '@electron-forge/maker-squirrel',
      config: {},
    },
    {
      name: '@electron-forge/maker-zip',
    },
    {
      name: '@electron-forge/maker-deb',
      executableName: "edhm-ui-v3",
      config: {
        options: {
          icon: 'public/images/icon.png',
          setupIcon: 'public/images/icon.png',
          name: 'edhm-ui-v3',
          productName: 'edhm-ui-v3',
          genericName: 'Modding Tool',
          maintainer: 'Blue Mystic <bluemystic.play@gmail.com>',
          description: 'Mod for Elite Dangerous to customize the HUD of any ship.',
        }
      }
    },
    {
      name: '@electron-forge/maker-rpm',
      config: {},
    },
  ],
  plugins: [
    {
      name: '@electron-forge/plugin-vite',
      config: {
        // `build` can specify multiple entry builds, which can be Main process, Preload scripts, Worker process, etc.
        // If you are familiar with Vite configuration, it will look really familiar.
        build: [
          {
            // `entry` is just an alias for `build.lib.entry` in the corresponding file of `config`.
            entry: 'src/main.js',
            config: 'vite.main.config.mjs',
            target: 'main',
          },
          {
            entry: 'src/preload.js',
            config: 'vite.preload.config.mjs',
            target: 'preload',
          },
        ],
        renderer: [
          {
            name: 'main_window',
            config: 'vite.renderer.config.mjs',
          },
        ],
      },
    },
    // Fuses are used to enable/disable various Electron functionality
    // at package time, before code signing the application
    new FusesPlugin( {
      version: FuseVersion.V1,
      [ FuseV1Options.RunAsNode ]: false,
      [ FuseV1Options.EnableCookieEncryption ]: true,
      [ FuseV1Options.EnableNodeOptionsEnvironmentVariable ]: false,
      [ FuseV1Options.EnableNodeCliInspectArguments ]: false,
      [ FuseV1Options.EnableEmbeddedAsarIntegrityValidation ]: true,
      [ FuseV1Options.OnlyLoadAppFromAsar ]: true,
    } ),
  ],
};