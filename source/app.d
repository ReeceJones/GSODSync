import std.stdio;
import scraper.taskqueue;
import scraper.scraperthread;
static import scraper.config;
import std.algorithm: each;

void main()
{
	// CSVResourceExtractor csvre = new CSVResourceExtractor("https://www.ncei.noaa.gov/data/global-summary-of-the-day/access/1968/";
	// foreach (string csvResource; csvre)
	// {
	// 	writeln("CSV:\t", csvResource);
	// }
	ThreadPoolTaskQueue queue = new ThreadPoolTaskQueue(scraper.config.beginningYear, scraper.config.endYear);
	ScraperThread[scraper.config.syncThreads] scraperThreads;
	
	// start all threads
	for (int i = 0; i < scraper.config.syncThreads; i++)
	{
		scraperThreads[i] = new ScraperThread(queue);
		writefln!"Starting thread %d"(i + 1);
		scraperThreads[i].start();
	}

	// join all threads
	for (int i = 0; i < scraper.config.syncThreads; i++)
	{
		scraperThreads[i].join();
	}
}
