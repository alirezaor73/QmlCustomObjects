import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12


Item {

    property var steps: [5000,1000,100,10,5,1,0.5,0.1,0.05,0.01,0.005,0.001]
    property int index: 5
    property var value: 0
    property string secondaryColor: "orange"
    property string btntxtColor   : "#c9c9c9"
    property string primaryColor   : "#424242"
    property double showText
    property int    spinSpeed     : 30
    property int    decimals      : 0
    property double from          : -9999999999999
    property double to            : 9999999999999
    property bool round: true

    onShowTextChanged: value = showText

    implicitHeight: 35
    implicitWidth: 200

    Rectangle{
        height: parent.height
        width: parent.width
        color: btntxtColor
        border.width: 1
        border.color: primaryColor
        radius: round ? height/4 : 0

        Timer {
            id: timerUp
            interval: spinSpeed; running: false; repeat: true
            onTriggered: if(value < to){
                             value += steps[index]
                         }
        }
        Timer {
            id: timerDown
            interval: spinSpeed; running: false; repeat: true
            onTriggered: if(value > from){
                             value -= steps[index]
                         }
        }

        Rectangle{
            id: stepContainer
            width: parent.width * 0.3 -4
            height: parent.height -4
            x:2
            y:2
            color: primaryColor
//            border.width: 1
//            border.color: primaryColor
            clip: true
            radius: round ? height/4 : 0

            Rectangle{
                anchors.right: parent.right
                height: parent.height
                width: parent.width * 0.7
                color: "transparent"
                Text {
                    id: stepperValue
                    text: steps[index]
                    anchors.margins: 1
                    color: btntxtColor
                    font.pixelSize: parent.height/3.5
                    anchors.centerIn: parent
                    rotation: 0
                }
            }
            Image {
                id: stepUp
                source: "./arrow.png"
                sourceSize.height: parent.height/2.1
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: sourceSize.height/10
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    hoverEnabled: true
                    onEntered: upColor.color = secondaryColor
                    onExited: upColor.color = btntxtColor
                    onPressed: if(index !=0){index --}
                }
                ColorOverlay{
                    id:upColor
                    anchors.fill: parent
                    source: stepDown
                    color: btntxtColor
                    visible: true
                }
            }
            Image {
                id: stepDown
                source: "./arrow.png"
                rotation: 180
                sourceSize.height: parent.height/2.1
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: sourceSize.height/10
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    hoverEnabled: true
                    onEntered: downColor.color = secondaryColor
                    onExited: downColor.color = btntxtColor
                    onPressed: if(index < steps.length-1){index ++}
                }
                ColorOverlay{
                    id:downColor
                    anchors.fill: parent
                    source: stepDown
                    color: btntxtColor
                    visible: true
                }
            }
        }
        Rectangle {
            id: spinnerContainer
            height: parent.height -2
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.7 -4
            anchors.right: parent.right
            anchors.margins: 1
//            border.width: 1
//            border.color: primaryColor
            color: btntxtColor
            radius: round ? height/4 : 0
            Image {
                id: spinUp
                source: "./arrow.png"
                sourceSize.height: parent.height/2.1
                anchors.right:  parent.right
                anchors.top: parent.top
                anchors.margins: sourceSize.height/10
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    hoverEnabled: true
                    onEntered: spinupColor.color = secondaryColor
                    onExited: spinupColor.color = primaryColor
                    onPressed:  {
                        if(value < from){value = from}
                        else if(value > to){value = to}
                        else if(value >= from && value <to){
                            spinupColor.color = btntxtColor
                            value += steps[index]
                        }
                    }
                    onPressAndHold: timerUp.start();
                    onReleased: {
                        spinupColor.color = secondaryColor
                        timerUp.stop();
                    }
                }
                ColorOverlay{
                    id:spinupColor
                    anchors.fill: parent
                    source: stepDown
                    color: primaryColor
                    visible: true
                }
            }
            Image {
                id: spinDown
                source: "./arrow.png"
                rotation: 180
                sourceSize.height: parent.height/2.1
                anchors.right:  parent.right
                anchors.bottom: parent.bottom
                anchors.margins: sourceSize.height/10
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    hoverEnabled: true
                    onEntered: spindownColor.color = secondaryColor
                    onExited: spindownColor.color = primaryColor
                    onPressed:  {
                        if(value < from){value = from}
                        else if(value > to){value = to}
                        else if(value > from && value <= to){
                            spindownColor.color = btntxtColor
                            value -= steps[index]
                        }
                    }
                    onPressAndHold: timerDown.start();
                    onReleased: {
                        spindownColor.color = secondaryColor
                        timerDown.stop();
                    }
                }
                ColorOverlay{
                    id:spindownColor
                    anchors.fill: parent
                    source: stepDown
                    color: primaryColor
                    visible: true
                }
            }
            Rectangle{
                height: parent.height -2
                width: parent.width - 1.2*spinUp.width
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                color: "transparent"
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "IBeamCursor"
                }

                TextInput {
                    id: input
                    text: value ? value.toFixed(decimals) : 0
                    padding: 5
                    anchors.fill: parent
                    color: primaryColor
                    selectByMouse: true
                    selectionColor: secondaryColor
                    selectedTextColor: primaryColor
                    font.pointSize: parent.height *0.4
                    onTextEdited: value = text
                    mouseSelectionMode: TextInput.SelectCharacters
                    autoScroll: true

                }
            }
        }
    }
}
