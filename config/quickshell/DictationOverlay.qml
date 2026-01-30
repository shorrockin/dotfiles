import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    property bool isRecording: false

    Process {
        id: checkProcess
        command: ["test", "-f", "/tmp/dictation.state"]
        // When the process exits, we check the code
        onExited: code => {
            isRecording = (code === 0)
        }
    }

    Timer {
        interval: 100 // Check every 100ms
        running: true
        repeat: true
        onTriggered: {
            if (!checkProcess.running) {
                checkProcess.running = true
            }
        }
    }

    PanelWindow {
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        visible: isRecording
        
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"

        Rectangle {
            anchors.centerIn: parent
            
            width: 260
            height: 60 
            radius: 30
            
            color: "#EE1e1e2e" // Slightly more opaque for center visibility
            border.color: "#f38ba8" // Red
            border.width: 2
            
            // Shadow effect (simple imitation)
            Rectangle {
                z: -1
                anchors.fill: parent
                anchors.topMargin: 2
                anchors.leftMargin: 2
                radius: 24
                color: "#000000"
                opacity: 0.2
            }

            Row {
                anchors.centerIn: parent
                spacing: 12

                // Audio Visualizer
                Row {
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Repeater {
                        model: 8 // 8 Bars
                        Rectangle {
                            width: 6
                            height: 10
                            radius: 3
                            color: "#f38ba8" // Red
                            anchors.verticalCenter: parent.verticalCenter
                            
                            // Random initial delay to desync bars
                            property int delay: Math.random() * 500

                            SequentialAnimation on height {
                                loops: Animation.Infinite
                                running: true
                                
                                PauseAnimation { duration: delay }
                                
                                // Organic "Voice" movement simulation
                                NumberAnimation { 
                                    to: 10 + Math.random() * 25 
                                    duration: 100 + Math.random() * 150
                                    easing.type: Easing.InOutQuad 
                                }
                                NumberAnimation { 
                                    to: 8 + Math.random() * 10
                                    duration: 100 + Math.random() * 150
                                    easing.type: Easing.InOutQuad 
                                }
                                NumberAnimation { 
                                    to: 10 + Math.random() * 25 
                                    duration: 100 + Math.random() * 150
                                    easing.type: Easing.InOutQuad 
                                }
                                NumberAnimation { 
                                    to: 10
                                    duration: 200
                                    easing.type: Easing.InOutQuad 
                                }
                                
                                // Reset delay for next loop to keep it chaotic
                                ScriptAction { script: delay = Math.random() * 200 }
                            }
                        }
                    }
                }

                Text {
                    text: "Listening..."
                    color: "#cdd6f4" // Text
                    font.family: "JetBrains Mono"
                    font.pixelSize: 18
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
