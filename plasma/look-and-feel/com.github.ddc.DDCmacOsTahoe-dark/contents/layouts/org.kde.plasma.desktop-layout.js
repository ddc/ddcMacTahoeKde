var panel = new Panel
var panelScreen = panel.screen

// No need to set panel.location as ShellCorona::addPanel will automatically pick one available edge

// For an Icons-Only Task Manager on the bottom, *3 is too much, *2 is too little
// Round down to next highest even number since the Panel size widget only displays
// even numbers
panel.height = 30
panel.location = "top"
panel.hiding = "none"
panel.floating = false

// Restrict horizontal panel to a maximum size of a 21:9 monitor
const maximumAspectRatio = 21/9;
if (panel.formFactor === "horizontal") {
    const geo = screenGeometry(panelScreen);
    const maximumWidth = Math.ceil(geo.height * maximumAspectRatio);

    if (geo.width > maximumWidth) {
        panel.alignment = "center";
        panel.minimumLength = maximumWidth;
        panel.maximumLength = maximumWidth;
    }
}

var kickoff = panel.addWidget("org.kde.plasma.kickoff")
kickoff.currentConfigGroup = ["Shortcuts"]
kickoff.writeConfig("global", "Alt+F1")

var bpanel = new Panel
bpanel.location = "bottom"
bpanel.lengthMode = "fit"
bpanel.hiding = "none"
bpanel.height = 42

let taskBar = bpanel.addWidget("org.kde.plasma.icontasks")
taskBar.currentConfigGroup = ["General"]
taskBar.writeConfig("launchers", [
    "preferred://filemanager",
    "preferred://browser",
    "applications:org.kde.konsole.desktop",
    "applications:systemsettings.desktop",
])
panel.addWidget("org.kde.plasma.appmenu")
panel.addWidget("org.kde.plasma.panelspacer")
panel.addWidget("org.kde.plasma.marginsseparator")
panel.addWidget("org.kde.plasma.systemtray")
panel.addWidget("org.kde.plasma.marginsseparator")
panel.addWidget("org.kde.plasma.digitalclock")
panel.addWidget("org.kde.plasma.showdesktop")

// Set macOS-style window buttons on the left (close, maximize, minimize)
var kwinConfig = ConfigFile("kwinrc")
kwinConfig.group = "org.kde.kdecoration2"
kwinConfig.writeEntry("ButtonsOnLeft", "XIAN")
kwinConfig.writeEntry("ButtonsOnRight", "")
kwinConfig.writeEntry("BorderSize", "Tiny")

// Set wallpaper to solid black
for (var i = 0; i < screenCount; i++) {
    var d = desktops()[i]
    d.wallpaperPlugin = "org.kde.color"
    d.currentConfigGroup = ["Wallpaper", "org.kde.color", "General"]
    d.writeConfig("Color", "#000000")
}

