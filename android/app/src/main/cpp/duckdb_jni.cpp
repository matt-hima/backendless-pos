#include <jni.h>

#include "duckdb.h"

namespace {
duckdb_database database = nullptr;
duckdb_connection connection = nullptr;
}

extern "C" JNIEXPORT jboolean JNICALL
Java_com_lilygo_lilygo_1erp_1client_MainActivity_nativeDuckDbInit(
    JNIEnv *env, jobject, jstring path) {
  const char *database_path = env->GetStringUTFChars(path, nullptr);
  if (database != nullptr) {
    duckdb_disconnect(&connection);
    duckdb_close(&database);
  }
  const auto open_result = duckdb_open(database_path, &database);
  env->ReleaseStringUTFChars(path, database_path);
  if (open_result != DuckDBSuccess) return JNI_FALSE;
  if (duckdb_connect(database, &connection) != DuckDBSuccess) {
    duckdb_close(&database);
    return JNI_FALSE;
  }
  return JNI_TRUE;
}

extern "C" JNIEXPORT void JNICALL
Java_com_lilygo_lilygo_1erp_1client_MainActivity_nativeDuckDbClose(
    JNIEnv *, jobject) {
  if (connection != nullptr) duckdb_disconnect(&connection);
  if (database != nullptr) duckdb_close(&database);
}
