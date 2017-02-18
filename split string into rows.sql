

drop procedure if exists Split;

create procedure Split(inputString TEXT, delim TEXT)
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
    
    SELECT * from Split;
END;

CALL Split(',', ',');
