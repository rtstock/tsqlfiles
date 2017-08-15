USE [DataAgg]
GO

/****** Object:  UserDefinedFunction [dbo].[Covariance]    Script Date: 08/15/2017 16:55:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE Function [dbo].[Covariance](@XmlTwoValueSeries xml)
returns float
as
Begin
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
SELECT * FROM #_201603021642
FOR
XML PATH('Output')
)

DECLARE @XmlOneValueSeriesA xml	
SET @XmlOneValueSeriesA = (
SELECT col0,col0 col1 FROM #_201603021642
FOR
XML PATH('Output')
)

DECLARE @XmlOneValueSeriesB xml	
SET @XmlOneValueSeriesB = (
SELECT col1 col0,col1 FROM #_201603021642
FOR
XML PATH('Output')
)

--SELECT
--'A' GroupID, 
--e.c.value('(col0/text())[1]', 'float' ) X,
--e.c.value('(col1/text())[1]', 'float' ) Y
--FROM @XmlOneValueSeriesA .nodes('Output') e(c)

select 
	(SELECT dbo.Covariance(@XmlOneValueSeriesA)) VarianceA
	, (SELECT dbo.Covariance(@XmlTwoValueSeries)) Covariance
	, (SELECT dbo.Covariance(@XmlOneValueSeriesB)) VarianceB

*/
declare @returnvalue numeric(20,10)

set @returnvalue = 
(
	SELECT  SUM((x - xAvg) *(y - yAvg)) / MAX(n) AS [COVAR(x,y)]
	from 
	(
		SELECT  1E * x x,
				AVG(1E * x) OVER (PARTITION BY (SELECT NULL)) xAvg,
				1E * y y,
				AVG(1E * y) OVER (PARTITION BY (SELECT NULL)) yAvg,
				COUNT(*) OVER (PARTITION BY (SELECT NULL)) n
		FROM    
		(
			SELECT 
				e.c.value('(col0/text())[1]', 'float' ) x,
				e.c.value('(col1/text())[1]', 'FLOAT' ) y
			FROM @XmlTwoValueSeries.nodes('Output') e(c)			
		) A
	) A
)
return @returnvalue
end




GO


