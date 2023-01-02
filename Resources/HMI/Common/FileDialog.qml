import QtQuick
import QtQuick.Layouts
Rectangle{
    id:dialogController
    signal closeDialog()
    signal changeVideoSource(string source)
    function changeDialogStatus(){
        if (dialog.currentDialogItem.isVideo)
        {
            dialogController.changeVideoSource(convertSystemFile(dialog.currentDialogItem.path))
        }else fileDialog.setFileDialogDataAtPos(dialog.currentIndexInDialog)
    }
    function convertSystemFile(path){
        return "file://" + path
    }

    width:740
    height:580
    color:'transparent'
    border.color:'black'
    Rectangle{
        id:dialogHeader
        property bool isMoving:false
        anchors{
            top:parent.top
            topMargin: 1
            horizontalCenter: parent.horizontalCenter
        }
        width:parent.width-2
        height:50
        color:'lightblue'
        Image{
            id:type
            anchors{
                left:parent.left
                leftMargin:10
                verticalCenter:parent.verticalCenter
            }
            sourceSize.width:40
            sourceSize.height:40
            source: "qrc:/Resources/Assets/Images/folder(1).png"
        }
        Text{
            anchors.left:type.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text:"Choose a mp4 file"
            font.pixelSize: 20
        }
        MouseArea{
            anchors.fill:parent
            drag.target: dialogController
        }
        Image{
            anchors{
                right:parent.right
                rightMargin:5
                verticalCenter: parent.verticalCenter
            }
            sourceSize.width:40
            sourceSize.height:40
            source:"qrc:/Resources/Assets/Images/cancel.png"
            MouseArea{
                anchors.fill:parent
                onClicked: dialogController.closeDialog()
            }
        }
    }
    Rectangle{
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.leftMargin:10
        anchors.topMargin:60
        height:50
        width:100
        color:'transparent'
        Image{
            id:homeButton
            sourceSize.width:20
            sourceSize.height:20
            anchors.verticalCenter: parent.verticalCenter
            source:"qrc:/Resources/Assets/Images/home.png"
        }
        Text{
            anchors.left:homeButton.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text:"home"
            font.pixelSize: 20
        }
        MouseArea{
            anchors.fill:parent
            onClicked: fileDialog.backToHome()
        }
    }
    Rectangle{
        anchors.right:dialog.left
        anchors.top:parent.top
        anchors.topMargin:60
        anchors.rightMargin: 15
        height:dialog.height
        width:15
        color:'grey'
        opacity:0.35
    }
    Rectangle{
        anchors.bottom:dialog.top
        anchors.left:dialog.left
        width:40
        height:40
        color:'transparent'
        Image{
            anchors.centerIn: parent
            sourceSize.width:30
            sourceSize.height:30
            source:"qrc:/Resources/Assets/Images/return.png"
        }
        MouseArea{
            anchors.fill:parent
            onClicked: fileDialog.back()
        }
    }



    ListView{
        id:dialog
        model:fileDialog
        clip:true
        anchors{
            fill:parent
            margins: 70
            leftMargin:150
            topMargin: 90
        }
        delegate:fileDialogDelegate
        spacing:5
        property int currentIndexInDialog:-1
        property var currentDialogItem
        Component{
            id:fileDialogDelegate
            Rectangle{
                id:dialogItem
                width:dialog.width
                height:type.height+10
                color:'transparent'
                Image{
                    id:type
                    anchors{
                        left:parent.left
                        verticalCenter:parent.verticalCenter
                    }
                    sourceSize.width:40
                    sourceSize.height:40
                    source: model.type? "qrc:/Resources/Assets/Images/folder(1).png" : "qrc:/Resources/Assets/Images/file.png"
                }
                Text{
                    anchors.left:type.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    text:model.name
                    font.pixelSize: 15
                }
                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    onEntered: {
                        dialogItem.color = "#d2d2d2"
                    }
                    onExited: {
                        dialogItem.color = "white"
                    }
                    onClicked: {
                        dialog.currentIndexInDialog = model.index
                        dialog.currentDialogItem = model
                    }
                    onDoubleClicked:  {
                        dialogController.changeDialogStatus()
                    }
                }
            }
        }
    }
    RowLayout{
        anchors.bottom: parent.bottom
        anchors.bottomMargin:10
        anchors.right:parent.right
        anchors.rightMargin:10
        spacing:10
        Rectangle{
            width:100
            height:40
            border.color:'black'
            Text{
                anchors.centerIn:parent
                text:"Open"
                color:'black'
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    if (dialog.currentIndexInDialog!==-1) dialogController.changeDialogStatus()
                        fileDialog.setFileDialogDataAtPos(dialog.currentIndexInDialog)
                    dialog.currentIndexInDialog = -1
                }
            }
        }
        Rectangle{
            width:100
            height:40
            border.color:'black'
            Text{
                anchors.centerIn:parent
                text:"Close"
                color:'black'
            }
            MouseArea{
                anchors.fill:parent
                onClicked: dialogController.closeDialog()
            }
        }
    }

}
