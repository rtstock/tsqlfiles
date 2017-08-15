--use ssc519sylvan_oper -- pms01
set nocount on
declare @RelCd varchar(30), @PGAsOfDate varchar(12),@SupBM int,@SupDtSec int,@SupLnSp int,@ShowGrossOnly int,@MaskCustNum int,@xmlportlink xml,@xmlportlink1 xml,@xmlportlink2 xml,@xmlportlink3 VARCHAR(500)

set @RelCd = %RelationshipCode%
set @PGAsOfDate = %PGAsOfDate%
set @SupBM = %SuppressBenchmark%
set @SupDtSec = %SuppressDateSection%
set @SupLnSp = %SuppressLineSpace%
set @ShowGrossOnly = %ShowGrossOnly%
set @MaskCustNum = %MaskCustNum%
set @xmlportlink = %xmlportlink%
set @xmlportlink1 = %xmlportlink1%
set @xmlportlink2 = %xmlportlink2%
set @xmlportlink3 = %xmlportlink3%

--set @RelCd = 'NEICM2'
--set @PGAsOfDate = '2017-06-11'
--set @SupBM = 0
--set @SupDtSec = 1
--set @SupLnSp = 1
--set @ShowGrossOnly = 0
--set @MaskCustNum = 1
--set @xmlportlink = '<P1><A2>NEICM2</A2><A4>010000</A4><A6>0</A6></P1><P1><A1>NEICM2</A1><A2>NEIBAL</A2><A3>051027844</A3><A4>010100</A4><A6>0</A6></P1><P1><A1>NEICM2</A1><A2>NEICAI</A2><A3>059040294</A3><A4>010200</A4><A6>0</A6></P1><P1><A1>NEICM2</A1><A2>NEICRA</A2><A3>084593613</A3><A4>010300</A4><A6>0</A6></P1><P1><A1>NEICM2</A1><A2>XNUCLE</A2><A3>013894342</A3><A4>010400</A4><A6>0</A6></P1><P1><A1>XNUCLE</A1><A2>XNUCLECASH</A2><A3>013894342</A3><A4>010401</A4><A6>0</A6></P1><P1><A1>XNUCLE</A1><A2>XNUCLEGIPSMI</A2><A3>013894342</A3><A4>010402</A4><A6>0</A6></P1><P1><A1>XNUCLE</A1><A2>XNUCLEHLLIEA</A2><A3>013894342</A3><A4>010403</A4><A6>0</A6></P1><P1><A1>XNUCLE</A1><A2>XNUCLELCMWE4</A2><A3>013894342</A3><A4>010404</A4><A6>0</A6></P1><P1><A1>XNUCLE</A1><A2>XNUCLELGAMG</A2><A3>013894342</A3><A4>010405</A4><A6>0</A6></P1><P1><A1>XNUCLE</A1><A2>XNUCLESAMRET</A2><A3>013894342</A3><A4>010406</A4><A6>0</A6></P1>'
--set @xmlportlink3 = ''

if object_id('tempdb..#_g1_00') is not null drop table #_g1_00
if object_id('tempdb..#_g1_00a') is not null drop table #_g1_00a
if object_id('tempdb..#_g1_01') is not null drop table #_g1_01
if object_id('tempdb..#_g3_00') is not null drop table #_g3_00
if object_id('tempdb..#_g2_00') is not null drop table #_g2_00
if object_id('tempdb..#_g2_01') is not null drop table #_g2_01
if object_id('tempdb..#_g2_02') is not null drop table #_g2_02

if object_id('tempdb..#_g6_0a') is not null drop table #_g6_0a
if object_id('tempdb..#_g6_01') is not null drop table #_g6_01
if object_id('tempdb..#_g3_00') is not null drop table #_g3_00

if object_id('tempdb..#_g4_00') is not null drop table #_g4_00
if object_id('tempdb..#_g4_01') is not null drop table #_g4_01
if object_id('tempdb..#_g4_02') is not null drop table #_g4_02
if object_id('tempdb..#_g5_00') is not null drop table #_g5_00
if object_id('tempdb..#_g5_01') is not null drop table #_g5_01
if object_id('tempdb..#_g5_02') is not null drop table #_g5_02
if object_id('tempdb..#_g5_03') is not null drop table #_g5_03
if object_id('tempdb..#_g5_gnb00') is not null drop table #_g5_gnb00
if object_id('tempdb..#_g5_gnb01') is not null drop table #_g5_gnb01
if object_id('tempdb..#_g5_gnb02') is not null drop table #_g5_gnb02
if object_id('tempdb..#_g7_00') is not null drop table #_g7_00
if object_id('tempdb..#_e01') is not null drop table #_e01
if object_id('tempdb..#_e01a') is not null drop table #_e01a
if object_id('tempdb..#_e02') is not null drop table #_e02
if object_id('tempdb..#_e03') is not null drop table #_e03
if object_id('tempdb..#_e04') is not null drop table #_e04
if object_id('tempdb..#_e04bench') is not null drop table #_e04bench
if object_id('tempdb..#_e05') is not null drop table #_e05
if object_id('tempdb..##_e06') is not null drop table ##_e06
if object_id('tempdb..##_e16') is not null drop table ##_e16
if object_id('tempdb..#_e07') is not null drop table #_e07
if object_id('tempdb..#_e08') is not null drop table #_e08
if object_id('tempdb..#_e09') is not null drop table #_e09
if object_id('tempdb..#_e10') is not null drop table #_e10
if object_id('tempdb..##_e11') is not null drop table ##_e11
if object_id('tempdb..#_e12') is not null drop table #_e12
if object_id('tempdb..#_f_00') is not null drop table #_f_00
if object_id('tempdb..#_f_01') is not null drop table #_f_01
if object_id('tempdb..#_f_02') is not null drop table #_f_02

declare @dPGA datetime
set @dPGA = convert(datetime,@PGAsOfDate)

declare @usPGA datetime
if ISDATE(@PGAsOfDate) = 1
	set @usPGA = CONVERT(datetime,@PGAsOfDate)
else
	set @usPGA = convert(datetime,convert(varchar,DATEADD(D,-1,GETDATE()),111) + ' 12:00AM')

declare @PrDt varchar(30)
set @PrDt = replace(replace(replace(convert(varchar,@usPGA,109),' 12:00:00:000AM',''),'  ',' '),' 20',', 20')

Create table #_g1_00 (
	Parent varchar(100)
	, PortfolioCode varchar(100)
	, CustodianAccountNumber varchar(100)
	, PortLevel varchar(100)
	, AccountDescription varchar(100)
	, NetOfFees varchar(10)
)

insert into #_g1_00
SELECT
	tbl.ports.value('A1[1]', 'varchar(100)') AS Parent,
    tbl.ports.value('A2[1]', 'varchar(100)') AS PortfolioCode,
    tbl.ports.value('A3[1]', 'varchar(100)') AS CustodianAccountNumber,
    tbl.ports.value('A4[1]', 'varchar(100)') AS PortLevel,
    tbl.ports.value('A5[1]', 'varchar(150)') AS AccountDescription,
    tbl.ports.value('A6[1]', 'varchar(10)') AS NetOfFees
FROM @xmlportlink.nodes('/P1') AS tbl(ports)
-- select * from #_g1_00
if @MaskCustNum = 1
	update #_g1_00
	set CustodianAccountNumber = '****'+right(CustodianAccountNumber,4)
	where len(CustodianAccountNumber) > 4

update #_g1_00
set CustodianAccountNumber = CustodianAccountNumber + '  ' + LEFT(PortfolioCode,6)

update #_g1_00
set CustodianAccountNumber = '********  ' + LEFT(PortfolioCode,6)
where CustodianAccountNumber is null

select *
into #_g1_00a
from
(
	select (
			SELECT COALESCE(
				(
					select top 1 portfolio_id 
					from portfolio where portfolio_ext=PortfolioCode+'-MC'
					order by modified_date desc
				)
				,
				(	select top 1 portfolio_id 
				from portfolio where portfolio_ext=PortfolioCode
				order by modified_date desc
				)
				)
			) portfolio_id
		, A.*
	from 
	(
		SELECT * FROM #_g1_00
	) A
) A
						-- -------------------
						--SELECT * FROM #_g1_00a
						-- -------------------
						
DECLARE @CodeNameString varchar(8000)
SELECT 
   @CodeNameString = STUFF( (SELECT ',' + cast( portfolio_id as varchar(30) )
							 FROM 
							 (
								SELECT distinct portfolio_id FROM #_g1_00a
							) a 
							 ORDER BY portfolio_id
							 FOR XML PATH('')), 
							1, 1, '')

PRINT @CodeNameString

declare @AsOfDate date
declare @PortfolioList varchar(2000)

declare @Currency varchar(32)
declare @depth int
declare @ClassScheme int

set @AsOfDate = @usPGA
set @PortfolioList = @CodeNameString
set @Currency = 'BAS'
set @depth = 1
set @ClassScheme = 0

Create table #_f_00
		(
				portfolio_id			int,
				portfolio_ext			varchar(30) COLLATE database_default,
				portfolio_name			varchar(60) COLLATE database_default,
				class_scheme_id			int,
				class_scheme_ext		varchar(30) COLLATE database_default,
				class_scheme_name		varchar(60) COLLATE database_default,
				auv_flavour_ext			varchar(30) COLLATE database_default,
				auv_flavour_name		varchar(60) COLLATE database_default,
				class_node_sec_id		int,
				class_node_sec_ext		varchar(30) COLLATE database_default,
				class_node_sec_name		varchar(60) COLLATE database_default,
				depth				int,
				sequence			varchar(255) COLLATE database_default,
				xml_seq				varchar(255) COLLATE database_default,
				port_mv		 float,
				market_index_id			int,
				market_index_ext		varchar(30) COLLATE database_default,
				market_index_name		varchar(60) COLLATE database_default,
				market_component_id		int,
				market_node_sec_id		int,
				market_node_sec_ext		varchar(30) COLLATE database_default,
				market_node_sec_name		varchar(60) COLLATE database_default,
				class_inception_date		datetime,
				class_last_invested_date	datetime,
				market_node_inception_date	datetime,
				market_node_last_invested_date	datetime,
				port_end_weight	 float,
				benchmark_end_weight float,
				ondate_port	 float,
				OnDate_benchmark float,
				ondate_diff	 float,
				WTD_port float,
				WTD_benchmark float,
				WTD_diff float,
				MTD_port float,
				MTD_benchmark float,
				MTD_diff float,
				QTD_port float,
				QTD_benchmark float,
				QTD_diff float,
				YTD_port float,
				YTD_benchmark float,
				YTD_diff float,
				M1_port float,
				M1_benchmark float,
				M1_diff float,
				M2_port float,
				M2_benchmark float,
				M2_diff float,
				M3_port float,
				M3_benchmark float,
				M3_diff float,
				M4_port float,
				M4_benchmark float,
				M4_diff float,
				M5_port float,
				M5_benchmark float,
				M5_diff float,
				M6_port float,
				M6_benchmark float,
				M6_diff float,
				M7_port float,
				M7_benchmark float,
				M7_diff float,
				M8_port float,
				M8_benchmark float,
				M8_diff float,
				M9_port float,
				M9_benchmark float,
				M9_diff float,
				M10_port float,
				M10_benchmark float,
				M10_diff float,
				M11_port float,
				M11_benchmark float,
				M11_diff float,
				Y1_port float,
				Y1_benchmark float,
				Y1_diff float,
				Y2_port float,
				Y2_benchmark float,
				Y2_diff float,
				Y3_port float,
				Y3_benchmark float,
				Y3_diff float,
				Y4_port float,
				Y4_benchmark float,
				Y4_diff float,
				Y5_port float,
				Y5_benchmark float,
				Y5_diff float,
				Y6_port float,
				Y6_benchmark float,
				Y6_diff float,
				Y7_port float,
				Y7_benchmark float,
				Y7_diff float,
				Y8_port float,
				Y8_benchmark float,
				Y8_diff float,
				Y9_port float,
				Y9_benchmark float,
				Y9_diff float,
				Y10_port float,
				Y10_benchmark float,
				Y10_diff float,
				Y15_port float,
				Y15_benchmark float,
				Y15_diff float,
				SI_port float,
				SI_benchmark float,
				SI_diff 	 float
		)


create table #_f_01 (
	IX_id	int,
	IX_ext	varchar(30),
	IX_name varchar(60)
	)
	
insert into #_f_01 (IX_id,IX_ext,IX_name)
SELECT  mi.market_index_id, mi.market_index_ext, mi.name
FROM	market_index   mi
Where	mi.start_date <= @AsOfDate
AND		mi.end_date   > @AsOfDate

insert into #_f_00
exec syl_pad_port_bench_asof
	@l_portfolios = @PortfolioList,
	@portfolios_type = N'i',
	@class_scheme_id = @ClassScheme,
	@auv_flavour_key = 1,
	@l_market_indices = 0,
	@market_indices_type = N'A',
	@s_on_date = @AsOfDate,
	@report_attrib = N'ROR',
	@depth = @depth,
	@currency_ext = @Currency,
	@annualize = 1,
	@include_securities = 0,
	@UsePrimaryIndex=1,
	@display_format = 0,
	@sort_order = 0

insert into #_f_00
exec syl_pad_port_bench_asof
	@l_portfolios = @PortfolioList,
	@portfolios_type = N'i',
	@class_scheme_id = @ClassScheme,
	@auv_flavour_key = 2,
	@l_market_indices = 0,
	@market_indices_type = N'A',
	@s_on_date = @AsOfDate,
	@report_attrib = N'ROR',
	@depth = @depth,
	@currency_ext = @Currency,
	@annualize = 1,
	@include_securities = 0,
	@UsePrimaryIndex=1,
	@display_format = 0,
	@sort_order = 0

select * 
into #_f_02
from #_f_00
where class_node_sec_name not like 'Cash%'

update #_f_02
set market_index_ext = case when isnull(IX_ext,'XXXXX')='XXXXX' or depth>1 then market_index_ext else IX_ext	end	
from #_f_02
left join #_f_01 on #_f_02.market_node_sec_ext = #_f_01.IX_ext

update #_f_02
set market_index_name = case when isnull(IX_name,'XXXXX')='XXXXX' or depth>1 then market_index_name else IX_name	end	
from #_f_02
left join #_f_01 on #_f_02.market_node_sec_ext = #_f_01.IX_ext

update #_f_02
set market_node_sec_ext = case when isnull(IX_ext,'XXXXX')='XXXXX' or depth>1 then market_node_sec_ext else IX_ext	end	
from #_f_02
left join #_f_01 on #_f_02.market_node_sec_ext = #_f_01.IX_ext

update #_f_02
set market_node_sec_name = case when isnull(IX_name,'XXXXX')='XXXXX' or depth>1 then market_node_sec_name else IX_name	end	
from #_f_02
left join #_f_01 on #_f_02.market_node_sec_ext = #_f_01.IX_ext  
select A.PortfolioCode,A.CustodianAccountNumber, A.PortLevel,B.*
into #_e01
from
(
	select * from #_g1_00
) A
left outer join
(
	select * from #_f_02
) B
on replace(A.PortfolioCode,'-MC','') = replace(B.portfolio_ext,'-MC','')
order by A.PortLevel asc

select *
into #_g5_gnb00
from
(
	SELECT B.*, A.*
	from
	(
		select PortLevel gnb_PortLevel, PortfolioCode gnb_Portcode 
		from #_g1_00
	) A
	,
	(
		select 'Gross' gnb, 1 gnb_order
		union
		select 'Net' gnb, 2 gnb_order
		union
		select 'Benchmark' gnb, 3 gnb_order
		union
		select 'BLANK' gnb, 4 gnb_order
	) B
) A
order by gnb_PortLevel,gnb_order
update #_e01
set portfolio_ext = REPLACE(portfolio_ext,'-MC','')

					-- ----------------------
					--SELECT  * FROM #_g5_gnb00
					-- ----------------------

SELECT 
	CONVERT(varchar(50),null) Model_ext
	, CONVERT(varchar(250),null) Model_mod
	,A.*, B.*
into #_g5_gnb01
from
(
	select * from #_g5_gnb00
) A
left outer join
(
	SELECT PortfolioCode 
		, CONVERT(VARCHAR(200),portfolio_name) portfolio_name
		,  auv_flavour_ext
		,  port_mv MV
		,  MTD_port MTD
		,  QTD_port QTD
		,  YTD_port YTD
		,  Y1_port Y1
		,  Y2_port Y2
		,  Y3_port Y3
		,  Y5_port Y5
		,  Y7_port Y7
		,  Y10_port Y10
		,  Y15_port Y15
		,  SI_port SI
		,  class_inception_date INCEPT
		,  class_last_invested_date LASTINVESTED
	 FROM 
	 (
		SELECT * FROM #_e01
	 ) A
) B
on A.gnb = B.auv_flavour_ext
and a.gnb_PortCode = B.PortfolioCode

UPDATE #_g5_gnb01
SET PortfolioCode = B.PortfolioCode 
	, portfolio_name = 'Vs:  ' + isnull(B.market_node_sec_name,'Not Available')
	, auv_flavour_ext = 'Benchmark'
	, MTD = B.MTD_benchmark
	, QTD = B.QTD_benchmark
	, YTD = B.YTD_benchmark
	, Y1 = B.Y1_benchmark 
	, Y2 = B.Y2_benchmark 
	, Y3 = B.Y3_benchmark 
	, Y5 = B.Y5_benchmark 
	, Y7 = B.Y7_benchmark 
	, Y10 = B.Y10_benchmark 
	, Y15 = B.Y15_benchmark 
	, SI = B.SI_benchmark 
	, INCEPT = B.market_node_inception_date
	, LASTINVESTED = B.market_node_last_invested_date
FROM
	#_g5_gnb01 A
	,
	( select * from #_e01 WHERE auv_flavour_ext = 'Gross' ) B
WHERE A.gnb_Portcode = B.portfolio_ext
and A.gnb = 'Benchmark'

update #_g5_gnb01
set portfolio_name = 'Net of Fees'
where gnb_order = 2

select *
into #_g4_00
from
(
	select portfolio_ext
		,element_ext
		,element_name
		,case when property_name = 'Manager' then 0 else 1 end as Level3ID
	from 
	(
		select * from v_portfolio_element
	) v
	where property_name in ('Manager','Investment Objective')
) A

select *
into #_g4_01
from
(
	Select 
		Main.portfolio_ext
		   , case when right(Main.[ManagerStrategy],1) = ',' then Left(Main.[ManagerStrategy],Len(Main.[ManagerStrategy])-1) else Main.[ManagerStrategy] end As [ManagerStrategy]
	From
		(
			Select distinct ST2.portfolio_ext, 
				(
					Select ST1.element_name + ' ' AS [text()]
					From #_g4_00 ST1
					Where ST1.portfolio_ext = ST2.portfolio_ext
					ORDER BY ST1.portfolio_ext,ST1.Level3ID
					For XML PATH ('')
				) [ManagerStrategy]
			From #_g4_00 ST2
		) [Main]
) A

select *
into #_g4_02
from
(
	Select 
		Main.portfolio_ext
		   , case when right(Main.[ManagerStrategy],1) = ',' then Left(Main.[ManagerStrategy],Len(Main.[ManagerStrategy])-1) else Main.[ManagerStrategy] end As [ManagerExtension]
	From
		(
			Select distinct ST2.portfolio_ext,
				(
					Select ST1.element_ext + ' ' AS [text()]
					From #_g4_00 ST1
					Where ST1.portfolio_ext = ST2.portfolio_ext
					ORDER BY ST1.portfolio_ext,ST1.Level3ID
					For XML PATH ('')
				) [ManagerStrategy]
			From #_g4_00 ST2
		) [Main]
) A

update #_g4_01
set ManagerStrategy = ltrim(rtrim(replace(ManagerStrategy,'Multi Manager Strategy Portfolio','')))

update #_g4_01
set ManagerStrategy = ltrim(rtrim(replace(ManagerStrategy,'&amp;','&')))


-- ================================================================================================================================================================ 
-- select * from #_g5_gnb01

insert into #_g5_gnb01
select 
	CONVERT(varchar(50),null) Model_ext
	, CONVERT(varchar(250),null) Model_mod
	, '' gnb,0 gnb_order,gnb_PortLevel,gnb_Portcode
	, PortfolioCode
	, convert(varchar(30), '') portfolio_name
	,null auv_flavour_ext
	,null MV
	,null MTD
	,null QTD
	,null YTD
	,null Y1
	,null Y2
	,null Y3
	,null Y5
	,null Y7
	,null Y10
	,null Y15
	,null SI
	,null INCEPT
	,null LASTINVESTED
from #_g5_gnb01
where gnb_order = 1

update #_g5_gnb01
set portfolio_name = B.CustodianAccountNumber
from #_g5_gnb01 A, #_g1_00 B
where A.gnb_PortLevel= B.PortLevel
and A.gnb_order=0

update #_g5_gnb01
set Model_mod = B.ManagerStrategy, Model_ext = B.ManagerExtension
from #_g5_gnb01 A
, 
(
	select A.portfolio_ext,A.ManagerStrategy,B.ManagerExtension from #_g4_01 A, #_g4_02 B where A.portfolio_ext = B.portfolio_ext 
) B
where A.gnb_Portcode = B.portfolio_ext

update #_g5_gnb01
set Model_mod = B.ManagerStrategy, Model_ext = B.ManagerExtension
from #_g5_gnb01 A
, 
(
	select A.portfolio_ext,A.ManagerStrategy,B.ManagerExtension from #_g4_01 A, #_g4_02 B where A.portfolio_ext = B.portfolio_ext 
) B
where A.gnb_Portcode+'-MC' = B.portfolio_ext


update #_g5_gnb01
set portfolio_name = Model_mod
where gnb_order = 2

update #_g5_gnb01
set portfolio_name = '********'
where portfolio_name is null

--select * from #_g5_gnb01 order by gnb_PortLevel, gnb_order

-- ================================================================================================================================================================ qqqq
-- drop table #_e01a
select * 
into #_e02
from #_g5_gnb01
order by gnb_PortLevel, gnb_order

declare @SuppressClosedAccounts int = 1
if @SuppressClosedAccounts = 1
	delete from #_e02
	where RIGHT(RTRIM(Model_ext),len('CLOSED')) = 'CLOSED'

select *
into #_e03
from
(
	select *
	from
	(
		select 'xxx' Dummy 
			--, case when Level1 > 0 then '--' else '' end +
			--	case when Level2 > 0 then '-----' else '' end +
			--	case when Level3 > 0 then '-----' else '' end +
			, case when Level1 > 0 then REPLICATE(CHAR(160),2) else '' end +
				case when Level2 > 0 then REPLICATE(CHAR(160),5) else '' end +
				case when Level3 > 0 then REPLICATE(CHAR(160),5) else '' end +
			portfolio_name as IndentedName
			, *
		from
		(
			select convert(int,substring(convert(varchar(25),gnb_PortLevel),1,2)) Level1
				, convert(int,substring(convert(varchar(25),gnb_PortLevel),3,2)) Level2 
				, convert(int,substring(convert(varchar(25),gnb_PortLevel),5,2)) Level3
					, *
			from
			( 
				select * from #_e02 
			) A
		) A
	) A
) A
order by gnb_PortLevel, gnb_order

-- select * from #_e03
-----------------------------------------------------------------------------------------
-- delete this


-- ttttt
SELECT *
into #_e04
FROM
(
	select convert(varchar(30),gnb_Portcode) Portcode,gnb_PortLevel PortLevel, gnb, gnb_order Level3ID, IndentedName, MV, MTD, QTD, YTD, Y1,Y2,Y3,Y5,Y7,Y10,Y15,SI,INCEPT,LASTINVESTED, CONVERT(varchar(10),null) NetOfFees
	from 
	(
		select * from #_e03
	) A
	union
	select *
	from
	(
		select convert(varchar(30),NULL) Portcode, '00000'	PortLevel	  , convert(varchar(30), null) gnb, 1			Level3ID, 'As Of ' + '@PrDt' IndentedName, NULL MV, NULL MTD, NULL QTD, NULL YTD, NULL Y1,NULL Y2,NULL Y3,NULL Y5,NULL Y7,NULL Y10,NULL Y15,NULL SI,NULL INCEPT,NULL LASTINVESTED, null NetOfFees
		union
		select convert(varchar(30),NULL) Portcode, '00000'	PortLevel	  , convert(varchar(30), null) gnb, 2			Level3ID, null IndentedName,		 NULL MV,NULL MTD, NULL QTD, NULL YTD, NULL Y1,NULL Y2,NULL Y3,NULL Y5,NULL Y7,NULL Y10,NULL Y15,NULL SI,NULL INCEPT,NULL LASTINVESTED, null NetOfFees
		union
		select convert(varchar(30),NULL) Portcode, '00000'	PortLevel	  , convert(varchar(30), null) gnb, 3			Level3ID, null IndentedName,		 NULL MV,NULL MTD, NULL QTD, NULL YTD, NULL Y1,NULL Y2,NULL Y3,NULL Y5,NULL Y7,NULL Y10,NULL Y15,NULL SI,NULL INCEPT,NULL LASTINVESTED, null NetOfFees
		union
		select convert(varchar(30),NULL) Portcode, '00000'	PortLevel	  , convert(varchar(30), null) gnb, 4			Level3ID, null IndentedName,		 NULL MV,NULL MTD, NULL QTD, NULL YTD, NULL Y1,NULL Y2,NULL Y3,NULL Y5,NULL Y7,NULL Y10,NULL Y15,NULL SI,NULL INCEPT,NULL LASTINVESTED, null NetOfFees
	) A
) A
ORDER BY PortLevel, Level3ID
---------------------------- wwwwwww
-- select * from #_e04
update #_e04
set MV = null, INCEPT = null, LASTINVESTED = null
where Level3ID in (2,3)

update #_e04 set IndentedName = Replace(IndentedName,CHAR(0),'') 
update #_e04 set IndentedName = Replace(IndentedName,CHAR(9),'')
update #_e04 set IndentedName = Replace(IndentedName,CHAR(10),'')
update #_e04 set IndentedName = Replace(IndentedName,CHAR(11),'')
update #_e04 set IndentedName = Replace(IndentedName,CHAR(12),'')
update #_e04 set IndentedName = Replace(IndentedName,CHAR(13),'')
update #_e04 set IndentedName = Replace(IndentedName,CHAR(14),'')
--update #_e04 set IndentedName = Replace(IndentedName,CHAR(160),'')

if @ShowGrossOnly = 1
	update #_g1_00 set NetOfFees = 0

update #_e04
set NetOfFees = B.NetOfFees
from #_e04 A
, 
(
	select A.*
	from
	(	
		select * from #_g1_00
	) A
	,
	(
		select distinct PortfolioCode
		from
		(
			select left(PortfolioCode,6) PortfolioCode from #_g1_00
		) A
	) B
	where A.PortfolioCode = B.PortfolioCode
) B
where left(A.Portcode,6) = B.PortfolioCode

-- select * from #_e04
update #_e04
set	gnb = '', MTD = NULL,QTD = NULL,YTD = NULL,Y1=NULL,Y2=NULL,Y3=NULL,Y5=NULL,Y7=NULL,Y10=NULL,Y15=NULL,SI=NULL
WHERE Level3ID = 2
AND NetOfFees = 0

--pppppp
if object_id('tempdb..##_e06') is not null drop table ##_e06
select *
into ##_e06
from
(
	select --convert(varchar(max),rtrim(IndentedName)+'|'+Portcode) IndentedName
		convert(varchar(max),rtrim(IndentedName)) IndentedName
		, gnb, MV, MTD/1.0 MTD, QTD/1.0 QTD, YTD/1.0 YTD, Y1/1.0 Y1, Y2/1.0 Y2, Y3/1.0 Y3, Y5/1.0 Y5, Y7/1.0 Y7, Y10/1.0 Y10, Y15/1.0 Y15, SI/1.0 SI
		, INCEPT
		, LASTINVESTED
		, Level3ID
		, PortLevel
	from #_e04
) A
order by PortLevel, Level3ID

DECLARE @sql VARCHAR(MAX)
SET @sql = (
SELECT '
	if object_id(''tempdb..##_e16'') is not null drop table ##_e16
	select *
	into ##_e16
	from (
		select IndentedName
		, gnb
		, MV' +
		  CASE WHEN ISNULL(MTD,-99.9) = -99.1 THEN ',NULL MTD' ELSE ',MTD * 1.0 MTD' END 
		+ CASE WHEN ISNULL(QTD,-99.9) = -99.1 THEN '' ELSE ',QTD * 1.0 QTD' END 
		+ CASE WHEN ISNULL(YTD,-99.9) = -99.1 THEN '' ELSE ',YTD * 1.0 YTD' END 
		+ CASE WHEN ISNULL(Y1,-99.9) = -99.1 THEN '' ELSE ',Y1 * 1.0 Y1' END
		+ CASE WHEN ISNULL(Y2,-99.9) = -99.1 THEN '' ELSE ',Y2 * 1.0 Y2' END
		+ CASE WHEN ISNULL(Y3,-99.9) = -99.1 THEN '' ELSE ',Y3 * 1.0 Y3' END
		+ CASE WHEN ISNULL(Y5,-99.9) = -99.1 THEN '' ELSE ',Y5 * 1.0 Y5' END
		+ CASE WHEN ISNULL(Y7,-99.9) = -99.1 THEN '' ELSE ',Y7 * 1.0 Y7' END
		+ CASE WHEN ISNULL(Y10,-99.9) = -99.1 THEN '' ELSE ',Y10 * 1.0 Y10' END
		+ CASE WHEN ISNULL(Y15,-99.9) = -99.1 THEN '' ELSE ',Y15 * 1.0 Y15' END
		+ CASE WHEN ISNULL(SI,-99.9) = -99.1 THEN '' ELSE ',SI * 1.0 SI' END
		+ ', INCEPT, LASTINVESTED
		  , Level3ID
		  , PortLevel
		from ##_e06 
		where 1 = 1
	) A'
FROM
(
	select SUM(MTD) MTD, SUM(QTD) QTD , SUM(YTD) YTD, SUM(Y1) Y1, SUM(Y2) Y2, SUM(Y3) Y3, Sum(Y5) Y5, Sum(Y7) Y7, Sum(Y10) Y10, Sum(Y15) Y15, Sum(SI) SI
	FROM ##_e06
) A
)
print @sql
execute(@sql)

if object_id('tempdb..##_e06') is not null drop table ##_e06

select * 
into #_e07
from ##_e16
if object_id('tempdb..##_e16') is not null drop table ##_e16
-- select * from #_e07

update #_e07
set gnb = ''
where gnb = 'BLANK'

update #_e07
set gnb = 'Bench'
where gnb = 'Benchmark'

select distinct *
into #_e08
from 
(
	SELECT * FROM #_e07
) A
order by PortLevel,Level3ID

declare @tmv float
set @tmv = (
	select sum(MV) from #_e08
	where right(PortLevel,4) LIKE '0000' and Level3ID = 1
	)
--kkkkkkk
if object_id('tempdb..#_e09') is not null drop table #_e09
select PortLevel,Level3ID , MV/@tmv PercentMV
INTO #_e09
FROM #_e08


select *
into #_e10
from
(
	select A.*, B.PercentMV
	from
	(
		select * from #_e08
	) A
	left outer join
	(
		select * from #_e09
	) B
	on A.PortLevel = B.PortLevel
	and A.Level3ID = B.Level3ID
) A

delete from #_e10
where PortLevel in (
	select PortLevel
	from
	(
		select PortLevel, sum(MV) MV, SUM(MTD) MTD, SUM(QTD) QTD, SUM(YTD) YTD, SUM(Y1) Y1, SUM(Y3) Y3, SUM(SI) SI
		from #_e10
		where Level3ID = 1
		and not PortLevel = '0'
		group by PortLevel
	) A
	where isnull(MV,0) = 0 and isnull(MTD,-999) = -999 and isnull(QTD,-999) = -999 and isnull(YTD,-999) = -999 and isnull(Y1,-999) = -999 and isnull(Y3,-999) = -999 and isnull(SI,-999) = -999
) 

-- select * from #_e10
-- select * from #_e11
--update #_e10
--set IndentedName = ''
--where IndentedName like '%Net of Fees%'

DECLARE @FTCs varchar(8000)

SELECT 
   @FTCs = STUFF( (SELECT ',' + cast( name as varchar(50) )
							 FROM 
							 (
								select * from tempdb.sys.columns where object_id = object_id('tempdb..#_e10') and not name = 'Level3ID' and not name = 'PortLevel' and not name = 'gnb'
							) a 
							 ORDER BY column_id
							 FOR XML PATH('')), 
							1, 1, '')

if object_id('tempdb..##_e11') is not null drop table ##_e11
select * into ##_e11 from #_e10 
-- select * from ##_e11
if @SupBM = 1
begin
	SET @FTCs = 'SET ' + replace(@FTCs + ',', ',', ' = NULL, ')
	SET @FTCs = LEFT(@FTCs, LEN(@FTCs) - 1)
	PRINT @FTCs 

	set @sql = '
		update ##_e11 ' +
		@FTCs +
		' where gnb = ''Bench''
	'
	execute(@sql)
end

--declare @SuppressNetOfFees int = 1
--if @SuppressNetOfFees = 1
--begin
--	SET @FTCs = 'SET ' + replace(@FTCs + ',', ',', ' = NULL, ')
--	SET @FTCs = LEFT(@FTCs, LEN(@FTCs) - 1)
--	PRINT @FTCs 

--	set @sql = '
--		update ##_e11 ' +
--		@FTCs +
--		' where gnb = ''Net*''
--	'
--	execute(@sql)
--end

print @FTCs
--drop table #_e12
select * into #_e12 from ##_e11 
if object_id('tempdb..##_e11') is not null drop table ##_e11

-- select * from #_e12 --vvvvv

select *, convert(varchar(20), @RelCd) Level1, convert(varchar(20), null) Level2, null Level2ID
into #_g2_01
from #_e12
order by PortLevel,Level3ID

select *
into #_g2_02
from
(
	select *, 
		abs(floor((floor(abs(PrepID)))/abs(PrepID)) - 1) FormatID
	from
	(
		select A.*
			, (convert(int,(A.RowNumber / 5.0) - 0.01) + 2) / 2.0 PrepID
		from
		(
			select *, ROW_NUMBER() OVER(ORDER BY PortLevel asc, Level3ID asc) AS RowNumber
			from #_g2_01
		) A
	) A
) A

if @SupLnSp = 1
	delete from #_g2_02 where Level3ID = 4
if @SupDtSec = 1
	delete from #_g2_02 where PortLevel = 0

UPDATE #_g2_02
SET IndentedName = REPLACE(IndentedName,'Vs:  Not Available','')


if object_id('tempdb..##_e14') is not null drop table ##_e14
select *
INTO ##_e14
from #_g2_02
order by PortLevel asc, Level3ID asc

if object_id('tempdb..##_e15') is not null drop table ##_e15
create table ##_e15 ( x varchar(10) )
if object_id('tempdb..##_e15') is not null drop table ##_e15
--SELECT CONVERT(varchar, CAST(987654321 AS money), 1)
DECLARE @sql2 varchar(max)
SET @sql2 = (
SELECT '
	if object_id(''tempdb..##_e15'') is not null drop table ##_e15
	select *
	into ##_e15
	from (
		select IndentedName
		, gnb'
		+ CASE WHEN ISNULL(PercentMV,-99.9) = -99.9 THEN '' ELSE ',round(PercentMV,6) PercentMV ' END
		+ CASE WHEN ISNULL(MV,-99.9) = -99.9 THEN ', CONVERT(varchar, CAST(null AS money), 1) MV' ELSE ', CONVERT(varchar, CAST(MV AS money), 1) MV' END
		+ CASE WHEN ISNULL(MTD,-99.9) = -99.9 THEN ',NULL MTD' ELSE ',case when MTD >=0.0 then ''+'' else ''-'' end + Str(round(abs(MTD) * 1.0,2),5,2) + ''%'' MTD' END
		+ CASE WHEN ISNULL(QTD,-99.9) = -99.9 THEN '' ELSE ',case when QTD >=0.0 then ''+'' else ''-'' end + Str(round(abs(QTD) * 1.0,2),5,2) + ''%'' QTD' END
		+ CASE WHEN ISNULL(YTD,-99.9) = -99.9 THEN '' ELSE ',case when YTD >=0.0 then ''+'' else ''-'' end + Str(round(abs(YTD) * 1.0,2),5,2) + ''%'' YTD' END
		+ CASE WHEN ISNULL(Y1,-99.9) = -99.9 THEN '' ELSE ',case when Y1 >=0.0 then ''+'' else ''-'' end + Str(round(abs(Y1) * 1.0,2),5,2) + ''%'' Y1' END
		--+ CASE WHEN ISNULL(Y2,-99.9) = -99.9 THEN '' ELSE ',case when Y2 >=0.0 then ''+'' else ''-'' end + Str(round(abs(Y2) * 1.0,2),5,2) + ''%'' Y2' END
		+ CASE WHEN ISNULL(Y3,-99.9) = -99.9 THEN '' ELSE ',case when Y3 >=0.0 then ''+'' else ''-'' end + Str(round(abs(Y3) * 1.0,2),5,2) + ''%'' Y3' END
		+ CASE WHEN ISNULL(Y5,-99.9) = -99.9 THEN '' ELSE ',case when Y5 >=0.0 then ''+'' else ''-'' end + Str(round(abs(Y5) * 1.0,2),5,2) + ''%'' Y5' END
		+ CASE WHEN ISNULL(Y7,-99.9) = -99.9 THEN '' ELSE ',case when Y7 >=0.0 then ''+'' else ''-'' end + Str(round(abs(Y7) * 1.0,2),5,2) + ''%'' Y7' END
		+ CASE WHEN ISNULL(Y10,-99.9) = -99.9 THEN '' ELSE ',case when Y10 >=0.0 then ''+'' else ''-'' end + Str(round(abs(Y10) * 1.0,2),5,2) + ''%'' Y10' END
		--+ CASE WHEN ISNULL(Y15,-99.9) = -99.9 THEN '' ELSE ',case when Y15 >=0.0 then ''+'' else ''-'' end + Str(round(abs(Y15) * 1.0,2),5,2) + ''%'' Y15' END
		+ CASE WHEN ISNULL(SI,-99.9) = -99.9 THEN '' ELSE ',case when SI >=0.0 then ''+'' else ''-'' end + Str(round(abs(SI) * 1.0,2),5,2) + ''%'' SI' END
		+ ', INCEPT '+ 
		+ CASE WHEN LASTINVESTED = @PGAsOfDate THEN '' ELSE ',LASTINVESTED ' END + '
		  , convert(varchar(200), null) Level2ID
		  , Level3ID
		  , PortLevel
		  , RowNumber
		  , PrepID
		  , FormatID 
		  , CASE WHEN isnull(MTD,0) >= 0 THEN ''1'' else ''0'' end MTD_Format 
		  , CASE WHEN isnull(QTD,0) >= 0 THEN ''1'' else ''0'' end QTD_Format 
		  , CASE WHEN isnull(YTD,0) >= 0 THEN ''1'' else ''0'' end YTD_Format 
		  , CASE WHEN isnull(Y1,0) >= 0 THEN ''1'' else ''0'' end Y1_Format 
		  , CASE WHEN isnull(Y2,0) >= 0 THEN ''1'' else ''0'' end Y2_Format 
		  , CASE WHEN isnull(Y3,0) >= 0 THEN ''1'' else ''0'' end Y3_Format 
		  , CASE WHEN isnull(Y5,0) >= 0 THEN ''1'' else ''0'' end Y5_Format 
		  , CASE WHEN isnull(Y7,0) >= 0 THEN ''1'' else ''0'' end Y7_Format 
		  , CASE WHEN isnull(Y10,0) >= 0 THEN ''1'' else ''0'' end Y10_Format 
		  , CASE WHEN isnull(Y15,0) >= 0 THEN ''1'' else ''0'' end Y15_Format 
		  , CASE WHEN isnull(SI,0) >= 0 THEN ''1'' else ''0'' end SI_Format 
		from ##_e14 
		where 1 = 1
	) A
	if object_id(''tempdb..##_e14'') is not null drop table ##_e14'
FROM
(
	select sum(PercentMV) PercentMV, sum(MV) MV, SUM(MTD) MTD, SUM(QTD) QTD , SUM(YTD) YTD, SUM(Y1) Y1, SUM(Y2) Y2, SUM(Y3) Y3, Sum(Y5) Y5, Sum(Y7) Y7, Sum(Y10) Y10, Sum(Y10) Y15, Sum(SI) SI
		, Min(isnull(LASTINVESTED,@usPGA)) LASTINVESTED
	FROM ##_e14
) A
)
execute(@sql2)

if object_id('tempdb..#_e16') is not null drop table #_e16
select * 
into #_e16
from ##_e15

update #_e16 set MV = '$ ' + left(MV,len(MV) -3)

IF isnull(ltrim(rtrim(@xmlportlink3)),'') = ''
	set @xmlportlink3 = ( select top 1 name from portfolio where portfolio_ext like @RelCd + '%')
	
update #_e16 set Level2ID = @xmlportlink3 + ' - Performance As Of ' + @PrDt

if object_id('tempdb..##_e15') is not null drop table ##_e15
select *
from #_e16
order by Level2ID asc, PortLevel asc, Level3ID asc

---- jm 06/13/2017 revision