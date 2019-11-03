module scraper.scraperthread;

import scraper.taskqueue;
import scraper.config;
import scraper.csvextractor;
import core.thread;
import std.net.curl: get, download;
import std.path: buildPath;
import std.file: mkdirRecurse;
import std.stdio: writeln, writef;

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
                    // save the cursor pos, set the line row, move to begginning of line, clear line, write the line, restore cursor pos
                    writef!"\x1b[s\x1b[%dA\x1b[100D\x1b[2K\x1b[32mThread %d\x1b[0m\t: %s\x1b[31m%s\x1b[0m\x1b[u"(
                        syncThreads - this.threadId, this.threadId + 1, root, csvResource); 

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

