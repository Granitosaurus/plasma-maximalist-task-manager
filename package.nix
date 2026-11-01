{ lib, stdenv, cmake, kdePackages }:

stdenv.mkDerivation {
  pname = "plasma-maximalist-task-manager";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  buildInputs = with kdePackages; [
    qtbase
    qtdeclarative
    kconfig
    kglobalaccel
    ki18n
    kio
    knotifications
    kservice
    kwindowsystem
    kxmlgui
    libplasma
    plasma-activities
    plasma-activities-stats
    plasma-workspace # LibNotificationManager
    libksysguard
  ];

  # A Plasma applet plugin, not an application.
  dontWrapQtApps = true;

  meta = {
    description = "Icons-only Plasma task manager that lets you change the icon of individual windows";
    homepage = "https://github.com/granitosaurus/plasma-maximalist-task-manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
