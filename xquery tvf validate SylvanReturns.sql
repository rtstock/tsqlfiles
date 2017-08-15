USE [SSC519Client]
GO

/****** Object:  UserDefinedFunction [dbo].[_ex_fn_Validate_0040_SylvanReturns]    Script Date: 08/15/2017 15:43:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE FUNCTION [dbo].[_ex_fn_Validate_0040_SylvanReturns] (@AsOfDate varchar(12), @PortcodeFilter varchar(30) = '%',@auv_flavour_name VARCHAR(50) = '%') 
 
RETURNS @ReturnVal table (
	TemplateQuery varchar(50),AsOfDate varchar(12), PortfolioList int,Portcode varchar(30), auv_flavour_name VARCHAR(50), XmlParameters xml,XmlOutput xml,InitDatetime datetime 

)  AS 
 
 
BEGIN 
/*

select * from dbo._ex_fn_Validate_0040_SylvanReturns('2016-09-25',default,'Gross of Fees') ORDER BY Portcode asc, auv_flavour_name asc
select * from dbo._ex_fn_Validate_0040_SylvanReturns('2016-06-30',default,DEFAULT ) ORDER BY Portcode asc, auv_flavour_name asc
select * from dbo._ex_fn_Validate_0040_SylvanReturns('2016-06-30',default,DEFAULT ) ORDER BY Portcode asc, auv_flavour_name asc


select  * from dbo._proctable_ex_sp_000_UnitTest order by InitDatetime desc

*/


-- -------------------------------------------------------------------------------------------------------------
-- Validate_0040_SylvanReturns
-- ------------------------------------------------------------------------------------------------------------- 


DECLARE @usePortcodeFilter varchar(30)
set @usePortcodeFilter = ltrim(rtrim(@PortcodeFilter))
if len(@usePortcodeFilter) = 0
	set @usePortcodeFilter = '%'


-- ----------------------------------------
-- Gets Transactions for all accounts by Portcode and TranDescription
;WITH cteValidate_0040_SylvanReturns_00 (	TemplateQuery,AsOfDate,PortfolioList,Portcode,auv_flavour_name,XmlParameters,XmlOutput,InitDatetime ) As
(
	--if object_id('tempdb..#_IPC_MktValAIX_00') is not null drop table tempdb..#_IPC_MktValAIX_00

	select *
	--into #_IPC_MktValAIX_00
	from
	(
		select A.*
		from
		(
			select *
			from
			(
				select	TemplateQuery
					,	left(XmlOutput.value('(/Output/class_last_invested_date)[1]', 'nvarchar(12)'),10) as AsOfDate
					,	XmlParameters.value('(/Parameters/PortfolioList)[1]', 'int') as PortfolioList
					,   XmlOutput.value('(/Output/class_node_sec_ext)[1]', 'varchar(30)') as Portcode
					,	XmlOutput.value('(/Output/auv_flavour_name)[1]', 'varchar(50)') as auv_flavour_name
		  			,	XmlParameters
		  			,	XmlOutput
		  			,	InitDatetime
	  			from 
	  				_proctable_ex_sp_000_UnitTest A	  		
				where TemplateQuery = 'SylvanReturns'
			) A
			where 1 = 1
			and AsOfDate = @AsOfDate
			--and auv_flavour_name = @auv_flavour_name
		) A
	) A
)

	--if object_id('tempdb..#_IPC_MktValAIX_01') is not null drop table tempdb..#_IPC_MktValAIX_01
	
	insert into @ReturnVal ( TemplateQuery,AsOfDate,PortfolioList,Portcode,auv_flavour_name, XmlParameters,XmlOutput,InitDatetime )
	select *
	from
	(
		select A.TemplateQuery,A.AsOfDate,A.PortfolioList,A.Portcode,A.auv_flavour_name,A.XmlParameters,A.XmlOutput,A.InitDatetime 
		--into #_IPC_MktValAIX_01
		from 
		(
		select TemplateQuery,AsOfDate,PortfolioList
			,  Portcode
			,  auv_flavour_name
			,  case when charindex('-',Portcode) > 0 
				then left(Portcode,charindex('-',Portcode)-1) 
				else Portcode end RootPortcode
			,  XmlParameters,XmlOutput,InitDatetime 
		from
			(
				select 
					TemplateQuery,AsOfDate,PortfolioList
						, Portcode
						, auv_flavour_name
					,XmlParameters,XmlOutput,InitDatetime 
				from cteValidate_0040_SylvanReturns_00
			) A
		) A
		,
		(
			select PortfolioList,AsOfDate,auv_flavour_name,MAX(InitDatetime) InitDatetime
			from cteValidate_0040_SylvanReturns_00
			group by PortfolioList,AsOfDate,auv_flavour_name
		) B
		where A.InitDatetime = B.InitDatetime
		
		--and A.auv_flavour_name like B.auv_flavour_name 
	) A
	where Portcode like @PortcodeFilter
	and auv_flavour_name like @auv_flavour_name 
	RETURN  
 
END











GO


