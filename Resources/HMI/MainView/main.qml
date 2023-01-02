import QtQuick
import QtMultimedia
import QtQuick.Window
import "../Common" as CommonWidget
Window{
    visible:true
    width:1024
    height:768
    Video{
        id:video
        anchors.fill:parent
        anchors.bottomMargin:50
    }
    Loader{
        id:loaderDialog
        anchors.centerIn: parent
        active:false
        source: "qrc:/Resources/HMI/Common/FileDialog.qml"
    }
    Connections{
        target:loaderDialog.item
        function onCloseDialog(){
            loaderDialog.active = false;
        }
        function onChangeVideoSource(videoSource){
            console.log("change Source, ",videoSource)
            video.source = videoSource
            video.play()
            sliderIndicator.x = Qt.binding(function(){return video.position/video.duration * slider.width- sliderIndicator.width/2})
            loaderDialog.active = false;
        }
    }
    Text{
        anchors.verticalCenter: slider.verticalCenter
        anchors.right:slider.left
        anchors.rightMargin: 20
        color:'black'
        text:roundTime(Math.round(video.position/1000))
    }
    Text{
        anchors.verticalCenter: slider.verticalCenter
        anchors.left:slider.right
        anchors.leftMargin: 20
        color:'black'
        text:roundTime(Math.round(video.duration/1000))
    }
    function roundTime(time){
        if (time<10) return "00:0"+time.toString()
        else return "00:"+time.toString()
    }

    Rectangle{
        id:slider
        width:500
        anchors{
            bottom:parent.bottom
            bottomMargin:50
            horizontalCenter: parent.horizontalCenter

        }
        height:10
        border.color: 'black'
        Rectangle{
            id:progress
            height:parent.height
            width:sliderIndicator.x+sliderIndicator.width/2
            color:'grey'
        }
        Rectangle{
            id:sliderIndicator
            property bool hasSeek:false
            width:25
            height:25
            radius:width/2
            anchors.verticalCenter:  parent.verticalCenter
            color:'lightsteelblue'
            onXChanged: {
                console.log("Hererere, "+x)
                if (sliderIndicator.hasSeek) video.position = (sliderIndicator.x)/slider.width*video.duration
            }
            MouseArea{
                anchors.fill:parent
                drag.target: parent
                onPressed:
                {;console.log("pressed");sliderIndicator.x = video.position/video.duration * slider.width- sliderIndicator.width/2;
                    sliderIndicator.hasSeek =true;
                    video.pause()
                }
                onReleased: {
                    console.log("relase")
                    sliderIndicator.hasSeek =false
                    video.position = (sliderIndicator.x+25)/slider.width*video.duration
                    sliderIndicator.x = Qt.binding(function(){return video.position/video.duration * slider.width- sliderIndicator.width/2})
                    video.play()
                }
            }
        }
    }
    Image{
        anchors.left:slider.right
        anchors.leftMargin:100
        anchors.verticalCenter: slider.verticalCenter
        source:"qrc:/Resources/Assets/Images/folder.png"
        MouseArea{
            anchors.fill: parent

            onClicked:{
                video.stop()
                loaderDialog.active = true
            }
        }

    }
}
