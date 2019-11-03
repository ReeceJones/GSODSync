module scraper.scraperthread;

import scraper.taskqueue;
import scraper.config;
import scraper.csvextractor;
import core.thread;
import std.net.curl: get, download;
import std.path: buildPath;
import std.file: mkdirRecurse;
import std.stdio: writeln;

/**
 * Thread class that is used to download CSV files.
 */ 
class ScraperThread : Thread
{
public:
    this(ThreadPoolTaskQueue queue, int i)
    {
        this.queue = queue;
        this.threadId = i;
        super(&run);
    }
private:
    ThreadPoolTaskQueue queue;
    int threadId;

    void run()
    {
        string year = queue.getTask();
        while (year != "")
        {
            // construct the root
            string root = gsodDirectoryLocation ~ year ~ "/";
            // move to correct position
            writef!"\x1b[s";
            writef!"\x1b[%d;0H";
            writef!"Thread %d\t: %s"(this.threadId, root);
            writef!"\x1b[u";
            // create a directory to place files in 
            auto tree = buildPath("gsod", year /* remove trailing '/' */);
            tree.mkdirRecurse;

            // download the root directory for this given year
            string htmlSource = cast(string)get(root);

            CSVResourceExtractor csvre = new CSVResourceExtractor(htmlSource);
            try 
            {
                foreach (string csvResource; csvre)
                {
                    // download the resource
                    download(root ~ csvResource, buildPath("gsod", year) ~ "/" ~ csvResource);
                }
            }
            catch (Exception ex)
            {
                writeln("Error, download failed: " ~ ex.msg);
            }

            year = queue.getTask();
        }
    }
}

