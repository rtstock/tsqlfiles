USE [DataAgg]
GO

/****** Object:  UserDefinedFunction [dbo].[CorrelationFromXmlTwoValueSeries]    Script Date: 08/15/2017 16:47:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







alter FUNCTION [dbo].[CorrelationFromXmlTwoValueSeries]
(     
      @XmlTwoValueSeries xml
)
RETURNS  
@CorrelationTable    TABLE 
(CorrelationValue numeric(20,10))
AS 
/*
-- -----------
-- ALPHA TEST
-- -----------

IF object_id('tempdb..#_201603021642') is not null DROP TABLE #_201603021642
create table #_201603021642
(Period varchar(20), col0 numeric(20,10), col1 numeric(20,10))

insert into #_201603021642 values ('1990-01',1.4700000000,-3.0700000000)
insert into #_201603021642 values ('1990-02',2.7600000000,0.7400000000)
insert into #_201603021642 values ('1990-03',3.9300000000,1.1400000000)
insert into #_201603021642 values ('1990-04',-2.3000000000,-1.2100000000)
insert into #_201603021642 values ('1990-05',6.1000000000,5.2200000000)
insert into #_201603021642 values ('1990-06',1.4500000000,0.5300000000)
insert into #_201603021642 values ('1990-07',2.9900000000,0.7100000000)
insert into #_201603021642 values ('1990-08',-7.7600000000,-3.8600000000)
insert into #_201603021642 values ('1990-09',-8.2300000000,-1.4800000000)
insert into #_201603021642 values ('1990-10',5.3500000000,0.5300000000)
insert into #_201603021642 values ('1990-11',0.6300000000,3.5000000000)
insert into #_201603021642 values ('1990-12',2.4100000000,1.9400000000)
insert into #_201603021642 values ('1991-01',2.9500000000,2.3500000000)

select * from #_201603021642 order by Period

DECLARE @XmlTwoValueSeries xml	
SET @XmlTwoValueSeries = (
SELECT col0, col1 FROM #_201603021642
FOR
XML PATH('Output')
)

/*
SELECT 
	e.c.value('(col0/text())[1]', 'float' ) X,
	e.c.value('(col1/text())[1]', 'float' ) Y
FROM @XmlTwoValueSeries.nodes('Output') e(c)
*/
			
SELECT * FROM dbo.CorrelationFromXmlTwoValueSeries(@XmlTwoValueSeries)

*/
BEGIN
;WITH DataAvgStd
     AS 
     (
		SELECT GroupID,
			AVG(X)   AS XAvg,
			AVG(Y)   AS YAvg,
			STDEV(X) AS XStdev,
			STDEV(Y) AS YSTDev,
			COUNT(*) AS SampleSize
        FROM   
        (
     		SELECT
     		'A' GroupID, 
			e.c.value('(col0/text())[1]', 'float' ) X,
			e.c.value('(col1/text())[1]', 'FLOAT' ) Y
			FROM @XmlTwoValueSeries.nodes('Output') e(c)			
        ) A
        where not isnull(X,-9999) = -9999
        or not isnull(Y,-9999) = -9999
        GROUP  BY GroupID
     ),
     ExpectedVal
     AS (
			SELECT s.GroupID, SUM(( X - XAvg ) * ( Y - YAvg )) AS ExpectedValue
			FROM   
			(
     			SELECT 
     			'A' GroupID,
				e.c.value('(col0/text())[1]', 'float' ) x,
				e.c.value('(col1/text())[1]', 'FLOAT' ) y
				FROM @XmlTwoValueSeries.nodes('Output') e(c)			
			) s
			,	DataAvgStd das
			where s.GroupID = das.GroupID
			and
			( not isnull(X,-9999) = -9999
			or not isnull(Y,-9999) = -9999
			)
			GROUP  BY s.GroupID
		)
          
		INSERT INTO @CorrelationTable (CorrelationValue)
		SELECT ev.ExpectedValue / ( das.SampleSize - 1) / ( das.XStdev * das.YSTDev ) AS Correlation
		FROM   DataAvgStd das
		JOIN ExpectedVal ev
        ON das.GroupID = ev.GroupID
		OPTION (MAXRECURSION 3660);
		RETURN
END







GO


