#ifndef FILEDIALOG_H
#define FILEDIALOG_H

#include <QAbstractListModel>

class FileDialog : public QAbstractListModel
{
    Q_OBJECT
    enum FOLDER_DATA{
        TYPE=0,
        NAME,
        PATH,
        VIDEO,
    };

    struct DirData{
        bool isFolder{false};
        bool isVideo{false};
        QString name{""};
        QString path{""};
    };

public:
    explicit FileDialog(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void setFileDialogDataAtPos(const int& pos);
    Q_INVOKABLE void backToHome();
    Q_INVOKABLE void back();
signals:
    void closeDialog();
private:
    void setFileDialogData(const std::string& path);
private:
    QList<DirData> m_folderData;
    QString m_currentPath;
    QString m_currentRootParent="/home";
    QString m_defaultPath{"/home/tony/Desktop"};
};

#endif // FILEDIALOG_H
