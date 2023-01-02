#include "videoprocessor.h"

VideoProcessor::VideoProcessor(QObject *parent)
    : QObject{parent}
{
    m_fileDialog = new FileDialog();
}
