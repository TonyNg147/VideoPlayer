#include "filedialog.h"
#include <string>
#include <filesystem>
namespace fs = std::filesystem;
QString findName(const QString& name, bool& isVideo){
    QString extractedName = "";
    const int& indexOfSlash = name.lastIndexOf("/");
    extractedName = name.sliced(indexOfSlash+1);
    const int& indexOfDot = extractedName.lastIndexOf(".");
    if (extractedName.sliced(indexOfDot+1)=="mp4") isVideo = true;
    return extractedName;
}
FileDialog::FileDialog(QObject *parent)
    : QAbstractListModel(parent)
{
    m_folderData.clear();
    DirData item;
    item.isFolder = true;
    item.name = "home";
    item.path = "/home";
    m_folderData.append(item);
    qWarning()<<"Constructor";
}

int FileDialog::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;
    return m_folderData.count();
    // FIXME: Implement me!
}

QVariant FileDialog::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    const int& pos = index.row();
    if (pos<0||pos>=m_folderData.count()) return QVariant();
    switch(role){
    case FOLDER_DATA::TYPE:
        return m_folderData.at(pos).isFolder;
    case FOLDER_DATA::VIDEO:
        return m_folderData.at(pos).isVideo;
    case FOLDER_DATA::NAME:
        return m_folderData.at(pos).name;
    case FOLDER_DATA::PATH:
        return m_folderData.at(pos).path;
    default:
        return QVariant();
    }
    // FIXME: Implement me!
    return QVariant();
}

QHash<int, QByteArray> FileDialog::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FOLDER_DATA::TYPE] = "type";
    roles[FOLDER_DATA::NAME] = "name";
    roles[FOLDER_DATA::PATH] = "path";
    roles[FOLDER_DATA::VIDEO] = "isVideo";
    return roles;
}

void FileDialog::setFileDialogDataAtPos(const int& pos)
{
    if (pos<0||pos>=m_folderData.count()) return;
    if (!m_folderData.at(pos).isFolder) emit closeDialog();
    const std::string& path = m_folderData.at(pos).path.toStdString();
    this->setFileDialogData(path);
}

void FileDialog::backToHome()
{
    setFileDialogData("/home");
}

void FileDialog::back()
{
    const int& pos = m_currentPath.lastIndexOf("/");
    if (pos > 0){
        m_currentPath = m_currentPath.sliced(0,pos);
        qWarning()<<"herere: "<<m_currentPath;
        setFileDialogData(m_currentPath.toStdString());
    }
}

void FileDialog::setFileDialogData(const std::string &path)
{
    if (path=="") return;
    m_currentPath = QString::fromStdString(path);
    m_folderData.clear();
    beginResetModel();
    for (const auto & entry : fs::directory_iterator(path))
    {
        DirData item;
        if (entry.is_regular_file()) item.isFolder = false;
        else item.isFolder = true;
        const QString& currentPath = QString::fromStdString(entry.path());
        item.name = findName(currentPath,item.isVideo);
        item.path = currentPath;
        m_folderData.append(item);
    }
    endResetModel();
}
