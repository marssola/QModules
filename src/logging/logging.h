#ifndef HTLOGGING_H
#define HTLOGGING_H

#include <QObject>
#include <QDir>
#include <QFile>
#include <QDateTime>
#include <QTextStream>
#include <QJsonObject>

class Logging : public QObject
{
    Q_PROPERTY(QVariant log READ log NOTIFY logChanged)
    Q_OBJECT
public:
    explicit Logging(QObject *parent = nullptr);
    inline QVariant log() { return m_logs; }
    inline void setLog(QString type, QString msg)
    {
        m_logs.setValue(QJsonObject({{"type", type}, {"notification", msg}}));
        emit logChanged();
    }
    inline void setLog(QJsonObject obj)
    {
        m_logs = obj;
        emit logChanged();
    }

signals:
    void logChanged();

private:
    QVariant m_logs;
};
#endif // HTLOGGING_H

extern Logging logging;
extern QString application_name;
