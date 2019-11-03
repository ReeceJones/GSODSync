module scraper.csvextractor;

import std.string: indexOf;

/**
 * Represents a range that may be used to iterate over all CSV files in the directory.
 */
class CSVResourceExtractor
{
public:
    /// For range -- whether or not there is an upcoming href containing a csv file
    bool empty;

    /**
     * Construct an object using the URL root and page source
     */
    this(string htmlSource   ///< The source of the webpage from which CSV files will be extracted
        ) 
    {
        this.htmlSource = htmlSource;
        this.cursor = nextCSVReference();
        this.empty = this.cursor == -1;
    }

    /**
     * Returns the front element. (path of next CSV resource)
     */
    string front() 
    {
        return this.nextCSV;
    }

    /**
     * Iterates to the next resource
     */
     void popFront()
     {
         this.cursor = nextCSVReference();
         // if the cursor becomes -1, then there is nothing remaining
         if (this.cursor == -1)
            this.empty = true;
     }

private:
    /// The source of the webpage
    string htmlSource;
    /// The next CSV file's name
    string nextCSV;
    /// Cursor position
    long cursor;
    /**
     * Returns the cursor position 1 index past the last valid cursor position.
     */
    long nextCSVReference()
    {
        long nextCursor = this.cursor;
        bool foundValidRef = false;
        while (!foundValidRef)
        {
            // move to next href
            nextCursor = this.htmlSource.indexOf("href=", nextCursor);

            if (nextCursor == -1)
                return -1; // end of html file I guess
            
            // isolate resource
            nextCursor += "href=".length;
            nextCursor = this.htmlSource.indexOf('"', nextCursor) + 1; // move past the quotes
            // check to see if there is some malformatting error
            if (nextCursor == -1)
                throw new Exception("Expected opening \" in html source.");

            // create a copy of the cursor location, and set it as the anchor
            long anchor = nextCursor;
            nextCursor = this.htmlSource.indexOf('"', nextCursor);
            if (nextCursor == -1)
                throw new Exception("Expected closing \" in html source.");
            
            // get the resource name (non-fqn)
            const string resource = this.htmlSource[anchor..nextCursor];
            foundValidRef = resource[$-4..$] == ".csv";
            if (foundValidRef)
                this.nextCSV = resource; // set the last resource
        }
        return nextCursor + 1; // move past closing " and return idx
    }
}

/**
 * Basic wrapper around Exception for exceptions specific to CSVExtractor
 */
class CSVExtractorException : Exception
{
public:
    ///<Construct exception using message
    this(string msg ///< The message of the exception.
        )
    {
        super(msg);
    }
}
