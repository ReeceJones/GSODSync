module scraper.config;

/**
 * The URL for the root directory of the CSV bulk download for GSOD records
public immutable string gsodDirectoryLocation = "https://www.ncei.noaa.gov/data/global-summary-of-the-day/access/";
 */
immutable string gsodDirectoryLocation = "https://www.ncei.noaa.gov/data/global-summary-of-the-day/access/";

/**
 * Number of threads running at once, downloading data from NOAA GSOD records.
 */
immutable int syncThreads = 16;

/** 
 * The start year that we want to download records from
 */
shared immutable int beginningYear = 1901;

/**
 * The end year we want to download records from. -1 for current year of host machine.
 */
shared immutable int endYear = -1;
