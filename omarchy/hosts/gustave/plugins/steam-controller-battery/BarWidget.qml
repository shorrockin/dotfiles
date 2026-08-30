import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Steam Controller battery indicator for the Omarchy bar.
//
// The 2025 Steam Controller's wireless "Puck" (USB 28de:1304) has no kernel
// battery class yet, so ~/.config/scripts/controller-battery reads the level
// straight off hidraw (and also covers Bluetooth game controllers via
// bluetoothctl). That script already prints Waybar-style JSON:
//
//   {"text":"<icon> 74%","tooltip":"Steam Controller\nBattery: 74%","class":"controller"}
//   {"text":"","tooltip":"","class":"empty"}        <- nothing connected
//
// This widget polls it and shows the pill only while a controller is reporting
// a level; otherwise it collapses to zero width and stays out of the bar.
BarWidget {
  id: root
  moduleName: "steam-controller-battery"

  // percent < 0  ->  no controller / no reading  ->  widget hidden.
  property int percent: -1
  property string pill: ""
  property string tip: ""
  property string cls: "empty"

  readonly property string script: Quickshell.env("HOME") + "/.config/scripts/controller-battery"
  readonly property int pollSeconds: Math.max(5, Number(root.setting("intervalSeconds", 30)))
  readonly property bool present: percent >= 0

  visible: present
  implicitWidth: present ? button.implicitWidth : 0
  implicitHeight: button.implicitHeight

  function refresh() {
    if (!poll.running)
      poll.running = true
  }

  Process {
    id: poll
    command: [root.script]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var raw = String(text || "").trim()
        var p = -1
        var pill = ""
        var tip = ""
        var cls = "empty"
        if (raw) {
          try {
            var j = JSON.parse(raw)
            var label = String(j.text || "").trim()
            if (label && j.class && j.class !== "empty") {
              pill = label
              tip = String(j.tooltip || "")
              cls = String(j.class || "")
              var m = label.match(/(\d+)\s*%/)
              p = m ? parseInt(m[1], 10) : 0
            }
          } catch (e) {
            // Unparseable output -> treat as "no controller".
          }
        }
        root.percent = p
        root.pill = pill
        root.tip = tip
        root.cls = cls
      }
    }
  }

  Timer {
    interval: root.pollSeconds * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.present ? root.pill : ""
    // The pill is an icon plus "NN%", so it needs more than a single-glyph slot.
    slotSize: Style.bar.iconSlot * (root.present && !vertical ? 2 : 1)
    tooltipText: root.tip
    // Turn the pill red at 15% and below (bar.urgent via WidgetButton.active).
    active: root.percent >= 0 && root.percent <= 15
    onPressed: function (b) {
      if (b === Qt.MiddleButton)
        root.refresh()
    }
  }
}
