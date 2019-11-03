module scraper.taskqueue;

import scraper.config;
import std.conv: text;
import std.datetime.systime: Clock, SysTime;
import core.sync.mutex;
import std.stdio: writefln;

class ThreadPoolTaskQueue
{
public:
    this(int start, int end)
    {
        if (end == -1)
        {
            SysTime now = Clock.currTime();
            end = cast(int)now.year;
            writefln!"Detected current year as: %d"(end);
        }
        
        for (int i = start; i <= end; i++)
        {
            unresolvedYears ~= i.text;
        }
    }

    string getTask()
    {
        synchronized 
        {
            if (unresolvedYears.length == 0)
                return "";
            string f = unresolvedYears[0];
            unresolvedYears = unresolvedYears[1..$];
            return f;
        }
    }
private:
    string[] unresolvedYears;
}
