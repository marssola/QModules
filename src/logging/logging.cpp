#include "logging.h"

void logMsg(QtMsgType type, const QMessageLogContext &logContext, const QString &msg)
{
    QString type_str;
    switch (type) {
    case QtDebugMsg: type_str = "Debug"; break;
    case QtWarningMsg: type_str = "Warning"; break;
    case QtCriticalMsg: type_str = "Critical"; break;
    case QtInfoMsg: type_str = "Info"; break;
    case QtFatalMsg: type_str = "Fatal"; break;
    }
    logging.setLog(QJsonObject({
                                     {"type", type_str},
                                     {"file", logContext.file},
                                     {"function", logContext.function},
                                     {"msg", msg}
                                 }));

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    Q_UNUSED(logContext);
#else
    const QString directory_logs = "/tmp/logs/";
    QDir dir(directory_logs);
    if (!dir.exists())
        dir.mkdir(directory_logs);

    QFile log_file(directory_logs + application_name + ".log");
    if (log_file.open(QIODevice::Append)) {
        QTextStream out(&log_file);
        out << QDateTime::currentSecsSinceEpoch();
        out << " [" << type_str << "]";
        if (logContext.file)
            out << " [" << logContext.file << "]";
        if (logContext.function)
            out << " [" << logContext.function << "]";
        out << " " << msg << "\n";
        if (type == QtFatalMsg) {
            log_file.close();
            abort();
        }
        log_file.close();
    }
#endif
}

Logging::Logging(QObject *parent) : QObject(parent)
{
    qInstallMessageHandler(logMsg);
}
