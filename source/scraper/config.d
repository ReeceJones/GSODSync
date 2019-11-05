module scraper.config;

/**
 * The URL for the root directory of the CSV bulk download for GSOD records
public immutable string gsodDirectoryLocation = "https://www.ncei.noaa.gov/data/global-summary-of-the-day/access/";
 */
immutable string gsodDirectoryLocation = "https://www.ncei.noaa.gov/data/global-summary-of-the-day/access/";

/**
 * Number of threads running at once, downloading data from NOAA GSOD records.
 * 2950 -> 8 threads
 * r610 -> 24 threads
 * desktop -> 16 threads
 */
immutable int syncThreads = 16;

/** 
 * The start year that we want to download records from
 */
immutable int beginningYear = 1901;

/**
 * The end year we want to download records from. -1 for current year of host machine.
 */
immutable int endYear = -1;

/**
 * Use fancy formatting on thread status.
 */
immutable bool useFancyFormatting = false;
