#ifndef IMAGEPICKER_H
#define IMAGEPICKER_H

#include <QObject>
#include <QQuickItem>

#if defined (Q_OS_ANDROID)
#include <QtAndroidExtras>
class ImagePicker: public QObject, public QAndroidActivityResultReceiver
#elif defined (Q_OS_IOS)
class ImagePicker : public QObject
#else
class ImagePicker : public QObject
#endif
{
    Q_OBJECT
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)
    Q_PROPERTY(QString filename READ filename WRITE setFilename NOTIFY filenameChanged)

public:
    ImagePicker(QQuickItem *parent = nullptr) :
        QObject(parent),
        m_filename(""),
        m_error("")
    {}

    inline QString filename() const { return m_filename; }
    inline QString error() const { return m_error; }
    inline void setFilename(const char* filename) { m_filename = filename; emit filenameChanged(); }
    inline void setFilename(const QString &filename) { m_filename = filename; emit filenameChanged(); }

    Q_INVOKABLE void openPicker();

#if defined (Q_OS_ANDROID)
    virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data) override;
#endif

signals:
    void filenameChanged();
    void errorChanged();

private:
    QString m_filename;
    QString m_error;
};

#endif // IMAGEPICKER_H
