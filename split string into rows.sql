/*
    This mysql procedure splits a delimited string into rows
    
    As I have not yet found a way to SELECT * FROM sp(args), the Split will work like this:
    - Store the split result in temp table Split
    - then you need to select * from Split
    
*/

drop procedure if exists Split;

create procedure Split(IN inputString TEXT, IN delim TEXT)
BEGIN
    -- INPUTS
    SET @inputString = inputString;
    set @delim = delim;

    CREATE TEMPORARY TABLE IF NOT EXISTS Split (string TEXT);
    TRUNCATE TABLE Split;
    
    WHILE length(@inputString) <> 0 DO
        SET @foundOccurrence = SUBSTRING_INDEX(@inputString, @delim, 1);
        
        INSERT Split
        SELECT @foundOccurrence;
        
         -- cut off @foundOccurrence from header line
        SET @inputString = RIGHT(@inputString, length(@inputString) - length(@foundOccurrence));
        
        -- is there a delimiter after the occurrence? cut it off as well
        IF LOCATE(@delim, @inputString) = 1 THEN 
            -- string that ends with delimiter and nothing? add empty 
            IF @inputString = @delim THEN
                INSERT Split
                SELECT '';
            END IF;
            SET @inputString = RIGHT(@inputString, length(@inputString) - length(@delim));
        END IF;
    END WHILE;
    
--    SELECT * from Split;
END;

CALL Split(',34,ds,2, k , ', ',');
SELECT * from Split;
