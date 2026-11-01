# Maximalist Task Manager

An icons-only task manager widget for KDE Plasma 6 that lets you change the icon of individual windows.

When several windows of the same app are open, e.g. one Firefox window per project, they all share one icon and are hard to tell apart. Right-click a window in the task manager, pick **Change Icon**, and give that window its own icon.

It is a fork of Plasma's own Icons-Only Task Manager, so everything else looks and behaves exactly like the stock widget. The feature was [proposed upstream](https://invent.kde.org/plasma/plasma-desktop/-/merge_requests/4157) and declined, so it lives here instead.

## Features

- **Change Icon** in the task context menu:
  - pick an icon from the app's suggested alternatives or your presets
  - **Choose…** any icon through the standard icon picker
  - **Reset to Default**

  ![Giving two Firefox windows their own icons through Change Icon](docs/change-icon.gif)

  **Prefer the keyboard?** The **Cycle Icon of Active Window** shortcut does the same for the focused window. Each press switches it to the next icon from the menu, and after the last one back to its default icon. The shortcut has no key until you assign one:

  1. Open **System Settings → Keyboard → Shortcuts**.
  2. Select **Plasma Workspace** and search for "Cycle Icon".
  3. Click **Add custom shortcut** and press the keys you want, e.g. <kbd>Meta</kbd>+<kbd>T</kbd>. KWin uses that one for "Toggle Window Titlebar and Frame" by default, so Settings will offer to reassign it.

- Only the task manager is affected. Grouping, launchers and the window's app identity stay the same, and the titlebar and Alt+Tab keep the app's normal icon.
- Overrides belong to a window and are forgotten once it closes, so nothing is left behind after restarts.

### Suggesting icons for an app

Add an `X-MaximalistTaskManager-AlternativeIcons` key to the app's `.desktop` file (a local copy in `~/.local/share/applications/` works) with a list of icon names or absolute paths:

```ini
X-MaximalistTaskManager-AlternativeIcons=firefox-developer-edition;firefox-nightly;/home/me/icons/travel.svg;
```

Apps without the key fall back to the widget-wide `iconOverridePresets` setting, which is empty by default.

## Compatibility

The widget is built from the Plasma **6.8.1** sources and uses private Plasma QML modules, the same ones the stock task manager uses. It is only expected to work on Plasma 6.8. A matching release follows each Plasma minor version.

## Installing

Install a [release](https://github.com/Granitosaurus/plasma-maximalist-task-manager/releases) rather than `main`. Releases are tested on the Plasma version they name, while `main` may be mid-way through a Plasma upgrade. The examples below use v1.0.1 (Plasma 6.8).

### NixOS

Add the flake as an input and its package to your system:

```nix
{
  inputs.maximalist-task-manager = {
    url = "github:granitosaurus/plasma-maximalist-task-manager/v1.0.1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # in your NixOS configuration
  environment.systemPackages = [
    inputs.maximalist-task-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
```

### From source

Requires the development packages for Qt 6, KDE Frameworks 6, libplasma, plasma-activities(-stats), plasma-workspace (LibNotificationManager) and libksysguard.

```sh
git clone --branch v1.0.1 https://github.com/Granitosaurus/plasma-maximalist-task-manager.git
cd plasma-maximalist-task-manager
cmake -B build -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build
sudo cmake --install build
```

Then restart Plasma (`systemctl --user restart plasma-plasmashell`), right-click your current task manager, choose **Show Alternatives…** and pick **Maximalist Task Manager**.

## Maintaining the fork

The first commit is an unmodified import of `applets/taskmanager` from plasma-desktop v6.8.1. The second commit makes it a standalone widget, and the commits after that add features and upstream syncs ("Sync the task manager with Plasma …").

**Currently synced with plasma-desktop v6.8.2.** To move to a newer release, apply the upstream changes since that tag, with the plugin id renamed:

```sh
git -C ../plasma-desktop diff v6.8.2 v6.9.0 --relative=applets/taskmanager \
  | sed -e 's/org\.kde\.plasma\.taskmanager/com.github.granitosaurus.maximalisttaskmanager/g' \
        -e 's/org\.kde\.plasma\.icontasks/com.github.granitosaurus.maximalisttaskmanager/g' \
  | git apply --reject --directory=src
```

Then fix any `*.rej` files and update the "currently synced" version above. For a new Plasma minor release (e.g. 6.9), also raise `PLASMA_BASE_VERSION` in `CMakeLists.txt` and refresh `po/`. Point releases (e.g. 6.8.2) usually don't need either.

### Releasing

1. Bump the version in `CMakeLists.txt`, `src/metadata.json` and `package.nix`, and the tag in the install examples above.
2. Commit, then tag and push: `git tag -a vX.Y.Z -m "vX.Y.Z" && git push origin main vX.Y.Z`.
3. Create the GitHub release from the tag. Tags matching `v*` are protected, so a published tag can't be moved or deleted.

## License

GPL-2.0-or-later, like the upstream task manager. Original code by Eike Hein and the KDE community.
