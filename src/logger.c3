module logger;

import std::io;
import libc;
import std::time;

LogLevel min_log_level @private = LogLevel.DEBUG; 

struct LogEvent {
    String fmt;
    String file;
    Tm *time;
    int line;
    LogLevel level;
}

enum Colors: uint (String value) {
	GRAY  = "\e[90m",
	WHITE = "\e[0m"
}

enum LogLevel : uint (String name, String color) {    
    DEBUG =  { "DEBUG", "\x1b[36m" },   
    WARN  =  { "WARN",  "\x1b[33m" },   
    INFO  =  { "INFO",  "\x1b[32m" }, 
    ERROR =  { "ERROR", "\x1b[31m" },
}

fn void set_min_log_level(LogLevel level) 
{
    min_log_level = level;
}

macro void log_event(LogEvent* ev, ...) 
{
    Tm* timeptr = ev.time;

	io::printf("%s%02d:%02d:%02d%s%s %s%s %s%s:%s: %s",
     Colors.GRAY.value,
     timeptr.tm_hour,
     timeptr.tm_min, 
     timeptr.tm_sec, 
     Colors.WHITE.value, 
     ev.level.color,
     ev.level.name, 
     Colors.WHITE.value, 
     Colors.GRAY.value,
     ev.file, 
     ev.line, 
     Colors.WHITE.value);

    io::printfn(ev.fmt, $vasplat);
}

macro void log(LogLevel level, String fmt, ...) 
{	
    if (level < min_log_level) {
        return;
    }

    Time_t currentTime = libc::time(null);
	Tm* timeptr = libc::localtime(&currentTime);

    LogEvent ev = {
        .fmt = fmt,
        .level = level,
        .time = timeptr,
        .file = $$FILE,
        .line = $$LINE,
    };

    log_event(&ev, $vasplat);
}

macro void info(String fmt, ...) 
{
    log(LogLevel.INFO, fmt, $vasplat);
}

macro void error(String fmt, ...) 
{
    log(LogLevel.ERROR, fmt, $vasplat);
}

macro void warn(String fmt, ...) 
{
    log(LogLevel.WARN, fmt, $vasplat);
}

macro void debug(String fmt, ...) 
{
    log(LogLevel.DEBUG, fmt, $vasplat);
}

