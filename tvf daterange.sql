USE [SSC519Client]
GO

/****** Object:  UserDefinedFunction [dbo].[DateRange]    Script Date: 08/15/2017 16:42:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[DateRange]
(     
      @Increment              CHAR(1) = 'd',
      @StartDate              DATETIME = '2016-01-01',
      @EndDate                DATETIME = '2016-12-31'
)
RETURNS  
@SelectedRange    TABLE 
(IndividualDate DATETIME)
AS 
/*
Alpha Test
----------
select * from DateRange('m','2016-01-31','2021-12-31')
--select left(convert(varchar(12),convert(date,IndividualDate)),7) YearMonth7 from dbo.DateRange('m','2014-01-01','2015-06-01')
--select left(convert(varchar(12),convert(date,IndividualDate)),11) YearMonth7 from dbo.DateRange('m','2014-01-01','2015-06-01')
*/
BEGIN
--declare @useStartDate datetime
--declare @useEndDate datetime
declare @IsMonthEndStartDate int
set @IsMonthEndStartDate = 0
if MONTH(@StartDate) != MONTH(DATEADD(DAY,1,@StartDate))
	set @IsMonthEndStartDate = 1

--set @useStartDate = '2016-10-10'
--SELECT DATEADD(month, ((YEAR(@useStartDate) - 1900) * 12) + MONTH(@useStartDate), -1)

      ;WITH cteRange (DateRange) AS (
            SELECT @StartDate
            UNION ALL
            SELECT 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, 1, DateRange)
                        WHEN @Increment = 'w' THEN DATEADD(ww, 1, DateRange)
                        WHEN @Increment = 'm' THEN DATEADD(mm, 1, DateRange) 
                        WHEN @Increment = 'y' THEN DATEADD(yy, 1, DateRange) 
                  END
            FROM cteRange
            WHERE DateRange <= 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, -1, @EndDate)
                        WHEN @Increment = 'w' THEN DATEADD(ww, -1, @EndDate)
                        WHEN @Increment = 'm' THEN DATEADD(mm, -1, @EndDate)
                        WHEN @Increment = 'y' THEN DATEADD(yy, -1, @EndDate)
                  END)
          
      INSERT INTO @SelectedRange (IndividualDate)
      --SELECT DATEADD(mm, 1, DATEADD(month, ((YEAR(DateRange) - 1900) * 12) + MONTH(DateRange), -1)) DateRange
      SELECT case when @IsMonthEndStartDate = 1 and not @Increment = 'd'
				then DATEADD(MONTH,1,DateRange)- day(DATEADD(MONTH,1,DateRange))
				else DateRange
				end DateRange
      --select DateRange
      FROM cteRange
      OPTION (MAXRECURSION 3660);
      RETURN
END





GO


