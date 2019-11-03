import std.stdio;
import scraper.taskqueue;
import scraper.scraperthread;
static import scraper.config;
import std.algorithm: each;

void main()
{
	ThreadPoolTaskQueue queue = new ThreadPoolTaskQueue(scraper.config.beginningYear, scraper.config.endYear);
	ScraperThread[scraper.config.syncThreads] scraperThreads;
	
	// start all threads
	for (int i = 0; i < scraper.config.syncThreads; i++)
	{
		scraperThreads[i] = new ScraperThread(queue, i);
		writefln!"Starting thread %d"(i + 1);
	}

	// start all threads (doing seperately to ensure good spacing)
	for (int i = 0; i < scraper.config.syncThreads; i++)
	{
		scraperThreads[i].start();
	}

	// join all threads
	for (int i = 0; i < scraper.config.syncThreads; i++)
	{
		scraperThreads[i].join();
	}
}
