#include <stdio.h>
#include <syslog.h>

void log_open(const char* name);
void log_close(void);
void log_write(int priority, const char* message);

int main(void) {
    const char* pg_name = "syslog_sample";

    log_open(pg_name);
    log_write(LOG_EMERG, "log_test:LOG_EMERG");
    log_write(LOG_ALERT, "log_test:LOG_ALERT");
    log_write(LOG_CRIT, "log_test:LOG_CRIT");
    log_write(LOG_WARNING, "log_test:LOG_WARNING");
    log_write(LOG_NOTICE, "log_test:LOG_NOTICE");
    log_write(LOG_INFO, "log_test:LOG_INFO");
    log_write(LOG_DEBUG, "log_test:LOG_DEBUG");
    log_close();

    return 0;
}

/************************************
 * SYSLOG オープン
 * **********************************/
void log_open(const char* name) {
    openlog(name, LOG_CONS | LOG_PID, LOG_MAIL);
}

/************************************
 * SYSLOG 書き込み
 * **********************************/
void log_write(int priority, const char* const message) {
    syslog(priority, "%s", message);
}

/************************************
 * SYSLOG クローズ
 * **********************************/
void log_close() {
    closelog();
}

