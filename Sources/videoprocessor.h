#ifndef VIDEOPROCESSOR_H
#define VIDEOPROCESSOR_H

#include <QObject>
#include "filedialog.h"
class VideoProcessor : public QObject
{
    Q_OBJECT
public:
    explicit VideoProcessor(QObject *parent = nullptr);
    FileDialog* getDialogInstance() const {return m_fileDialog;}
private:
    FileDialog* m_fileDialog = nullptr;
signals:
};

#endif // VIDEOPROCESSOR_H
