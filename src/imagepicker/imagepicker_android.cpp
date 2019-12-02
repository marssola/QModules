#include "imagepicker.h"
#include <QtAndroidExtras>
#include <QFile>

void ImagePicker::openPicker()
{
    QAndroidJniObject ACTION_PICK = QAndroidJniObject::fromString("android.intent.action.GET_CONTENT");
    QAndroidJniObject intent("android/content/Intent");
    if (ACTION_PICK.isValid() && intent.isValid()) {
        intent.callObjectMethod("setAction", "(Ljava/lang/String;)Landroid/content/Intent;", ACTION_PICK.object<jstring>());
        intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("image/*").object<jstring>());
        QtAndroid::startActivity(intent.object<jobject>(), 101, this);
    }
}

void ImagePicker::handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data)
{
    jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
    if (receiverRequestCode == 101 && resultCode == RESULT_OK) {
        QAndroidJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
        QAndroidJniObject dataAndroid = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$MediaColumns", "DATA", "Ljava/lang/String;");
        QAndroidJniEnvironment env;

        jobjectArray projection = (jobjectArray)env->NewObjectArray(1, env.findClass("java/lang/String"), nullptr);
        jobject projectionDataAndroid = env->NewStringUTF(dataAndroid.toString().toStdString().c_str());
        env->SetObjectArrayElement(projection, 0, projectionDataAndroid);

        QAndroidJniObject contentResolver = QtAndroid::androidActivity().callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
        QAndroidJniObject cursor = contentResolver.callObjectMethod("query", "(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;", uri.object<jobject>(), projection, NULL, NULL, NULL);

        jint columnIndex = cursor.callMethod<jint>("getColumnIndex", "(Landroid/lang/String;)I", dataAndroid.object<jstring>());
        cursor.callMethod<jboolean>("moveToFirst", "()Z");

        QAndroidJniObject result = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", columnIndex);
        m_filename = result.toString();
        emit filenameChanged();

        if (!QFile(m_filename).exists()) {
            m_error = "File not exist";
            emit errorChanged();
        }
    }
}
