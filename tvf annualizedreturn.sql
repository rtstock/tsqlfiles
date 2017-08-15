USE [SSC519Client]
GO

/****** Object:  UserDefinedFunction [dbo].[AnnualizedReturnGeneral]    Script Date: 08/15/2017 15:47:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










--drop type KeyValueTable
/*
CREATE TYPE KeyValueTable AS TABLE
 (                     
       [Key] [varchar](1000) NULL,                
       [Value] numeric(20,10) NULL
 )
*/

-- drop function AnnualizedReturn
CREATE FUNCTION [dbo].[AnnualizedReturnGeneral]
(     
      @KeyValueTable KeyValueTable readonly
)
/*
-- -----------
-- ALPHA TEST
-- -----------

if object_id('tempdb..#_201610101307_00') is not null drop table #_201610101307_00
if object_id('tempdb..#_201610101307_01') is not null drop table #_201610101307_01

create table #_201610101307_00
(header varchar(100), ROR numeric(20,10))
insert into #_201610101307_00 values ('2016-01-31',1.12)
insert into #_201610101307_00 values ('2016-02-29',2.22)
insert into #_201610101307_00 values ('2016-03-31',3.02)
insert into #_201610101307_00 values ('2016-04-30',-1.04)
insert into #_201610101307_00 values ('2016-05-31',-1.12)
insert into #_201610101307_00 values ('2016-06-30',2.52)
insert into #_201610101307_00 values ('2016-07-31',3.42)
insert into #_201610101307_00 values ('2016-08-31',6.02)
insert into #_201610101307_00 values ('2016-09-30',-3.42)
insert into #_201610101307_00 values ('2016-10-31',-1.12)
insert into #_201610101307_00 values ('2016-11-30',2.82)
insert into #_201610101307_00 values ('2016-12-31',0.42)
insert into #_201610101307_00 values ('2017-01-31',2.12)
insert into #_201610101307_00 values ('2017-02-28',-2.67)
insert into #_201610101307_00 values ('2017-03-31',2.02)
insert into #_201610101307_00 values ('2017-04-30',-1.04)
insert into #_201610101307_00 values ('2017-05-31',-2.12)
insert into #_201610101307_00 values ('2017-06-30',7.52)
insert into #_201610101307_00 values ('2017-07-31',3.42)
insert into #_201610101307_00 values ('2017-08-31',-4.02)
insert into #_201610101307_00 values ('2017-09-30',-3.42)
insert into #_201610101307_00 values ('2017-10-31',-1.12)
insert into #_201610101307_00 values ('2017-11-30',2.82)
insert into #_201610101307_00 values ('2017-12-31',0.42)

						-- ----------------------------
						--select * from #_201610101307_00
						-- ----------------------------

select [Key], Value/100.0 Value
into #_201610101307_01
from
(
	select header [Key], ROR Value 
	from #_201610101307_00

) A

						-- ----------------------------
						-- select * from #_201610101307_01
						-- ----------------------------


declare @TableX KeyValueTable
INSERT INTO @TableX
select *
from
(
	select * from #_201610101307_01
) A
order by [Key]	

select * from @TableX

SELECT * FROM dbo.AnnualizedReturnGeneral(@TableX)
*/
RETURNS  
--@ResultTable     Table ( [Key] Varchar(1000), Value numeric(20,10) )
@ResultTable    TABLE  (MinDate Datetime, MaxDate Datetime, AnnualizedReturn numeric(20,10),CumulativeReturn numeric(20,10)
	, Notes varchar(200)
	)
BEGIN

declare @KeyValueTableFormatted Table ( [Key] datetime, Value numeric(20,10) )
insert into @KeyValueTableFormatted
select convert(datetime,replace(convert(varchar,convert(datetime,[Key]),111),'/','-')) [Key]
	, Value
from @KeyValueTable
-- select convert(datetime,replace(convert(varchar,convert(datetime,'1/1/2016 11:26AM'),111),'/','-'))

declare @useKeyValueTable Table ( [Key] datetime, Value numeric(20,10),ReturnRecorded int )
--declare @dayaddon varchar(3)
--set @dayaddon = (select case when len([Key]) = 7 then '-01' else '' end)

/*
insert into @useKeyValueTable 
select * 
from @KeyValueTable
*/

declare @MinDate datetime
set @MinDate = (
	select MIN(KeyDate) 
	from 
	(
		select convert(datetime,[Key]) KeyDate
		from @KeyValueTableFormatted
	) A
) 

declare @MaxDate datetime
set @MaxDate = (
	select MAX(KeyDate) 
	from 
	(
		select convert(datetime,[Key]) KeyDate
		from @KeyValueTableFormatted
	) A
) 

declare @DaysBetweenMinMax int
set @DaysBetweenMinMax = DATEDIFF(DAY,@MinDate,@MaxDate) + 1

insert into @useKeyValueTable
select *
from
(
	select IndividualDate [Key]
		, convert(numeric(20,10), 0) Value
		, 0 ReturnRecorded
	from dbo.DateRange('d',@MinDate,@MaxDate)
	
) A

update @useKeyValueTable
set Value = B.Value, ReturnRecorded = 1
from @useKeyValueTable A, @KeyValueTableFormatted B
where A.[Key] = B.[Key]

declare @CountReturnRecorded int
set @CountReturnRecorded = ( select COUNT(*) from @useKeyValueTable where ReturnRecorded = 1 )

declare @NumberOfLeapYearsDays int
set @NumberOfLeapYearsDays = ( select COUNT(*) from @useKeyValueTable where Month([Key]) = 2 and DAY([Key])=29 )

declare @CountOfPeriods numeric(20,10)
set @CountOfPeriods = (select COUNT(*) from @useKeyValueTable)

;WITH userData ([Key], CumulativeReturn) AS
(
	select [Key],CumulativeReturn
	From
	(
		SELECT a.[Key]
			,Value
			,CumulativeReturn=
				CASE 
				WHEN ROW_NUMBER() OVER (ORDER BY a.[Key]) < (cast(@CountOfPeriods as int)) THEN NULL 
				ELSE 
					case when @CountOfPeriods = 1.0 then a.Value
					else
						(1.0+a.Value) * 
						 (
							SELECT Value=EXP(sum(log(1.0+Value)))
							FROM
							(
								select *
								from
								(
									SELECT b.[Key], b.Value
									FROM @useKeyValueTable b
									WHERE b.[Key] < a.[Key]	
								) A
							) b
						) - 1
					end
				END
		FROM @useKeyValueTable a
	) A
	
)


--set @datediff = (select DATEDIFF(MONTH,(select MIN([Key]) from userdata), (select MAX([Key]) from userdata)))
-- convert(numeric(5,1),@DaysBetweenMinMax)
	insert into @ResultTable
	select --[Key]
		--, (select convert(datetime, MAX([Key] + '01')) from userdata)
		--, 
		(select MIN([Key]) from userdata)
		, (select MAX([Key]) from userdata)
		, POWER(1.0 + CumulativeReturn, (365.0+convert(numeric(5,1),@NumberOfLeapYearsDays)) / @CountOfPeriods ) - 1.0
		, POWER(1.0 + CumulativeReturn, 1.0) - 1.0
		, 'DaysBetweenMinMax=' + CONVERT(varchar,@DaysBetweenMinMax) +'|CountOfPeriods='+convert(varchar,@CountOfPeriods) +'|CountReturnRecorded='+convert(varchar,@CountReturnRecorded)+'|NumberOfLeapYearsDays='+convert(varchar,@NumberOfLeapYearsDays)
	from 
	(
		select * 
		from userdata
	) A
	where [Key] = (select MAX([Key]) from userdata)
	RETURN
END








GO


