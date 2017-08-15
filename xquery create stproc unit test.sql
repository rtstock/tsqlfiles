USE [SSC519Client]
GO

/****** Object:  StoredProcedure [dbo].[_ex_sp_000_UnitTest]    Script Date: 08/15/2017 17:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
***************************************************************
This is the main Stored Procedure used for Exceptions reporting
***************************************************************
*/






CREATE PROC [dbo].[_ex_sp_000_UnitTest] 
 
( 
 
	@TemplateQuery varchar(100) = '', --= 'IPC_TransBucket',  
 
	@XmlParameters XML = null, --'<Parameters><Portcode>`XMEDIC`</Portcode><PGAsOfDate>`2014-09-30`</PGAsOfDate><ClassSchemeID>34</ClassSchemeID></Parameters>', 
 
	@Hijack varchar(max) = '', 
 
	@InitDatetime DATETIME = NULL, 
 
	@ShowResults int = 1 
 
	 
 
) 
 
as 
 
/* 
 
--  
 
 -- Alpha Test 
 
DECLARE @XmlParameters xml 
 
set @XmlParameters = CAST('<Parameters><Portcode>`XMEDIC`</Portcode><PGAsOfDate>`2015-02-09`</PGAsOfDate><ClassSchemeID>34</ClassSchemeID></Parameters>' As XML) 
 
exec _ex_sp_000_UnitTest 
 
	'IPC_MktValAI', --@TemplateQuery varchar(100)  
 
	@XmlParameters , 
 
	'SELECT sum(isnull(marketvaluecurrent,0)) as marketvaluecurrent, SUM(isnull(AccInt,0)) as Accint=SELECT sum(isnull(marketvaluecurrent,0)) marketvaluecurrent, SUM(isnull(AccInt,0)) as Accint into #uttemp ', -- Hijack SQL 
 
	NULL, --@InitDatetime DATETIME  
 
	1 -- @ShowResults int  
 
	 
 
*/ 
 
 
 
set nocount on 
 
-- Help 
 
if ISNULL(@TemplateQuery,'') = '' or ltrim(rtrim(LOWER(@TemplateQuery))) = 'help' 
 
begin 
 
 
 
	select 1 id,'Procedure Name','exec _ex_sp_000_UnitTest' Usage 
 
	union 
 
	select 2 id,'Pages Template Query','''IPC_MktValAI'', --@TemplateQuery varchar(100) ' 
 
	union 
 
	select 3 id,'Parameters','''<Parameters><Portcode>`XMEDIC`</Portcode><PGAsOfDate>`2014-09-30`</PGAsOfDate><ClassSchemeID>34></ClassSchemeID></Parameters>'', --@XmlParameters varchar(max) ' 
 
	union 
 
	select 4 id,'Hijack SQL', '''SELECT sum(isnull(marketvaluecurrent,0)) as marketvaluecurrent, SUM(isnull(AccInt,0)) as Accint=SELECT sum(isnull(marketvaluecurrent,0)) marketvaluecurrent, SUM(isnull(AccInt,0)) as Accint into #temp '', -- Hijack SQL' 
 
	union 
 
	select 5 id,'InitDatetime','NULL, --@InitDatetime DATETIME ' 
 
	union 
 
	select 6 id,'ShowResults','1 -- @ShowResults int Yes = 1 No = 0' 
 
	 
 
	goto exit_procedure 
 
end 
 
 
if @ShowResults = 1
begin
	print 'Procedure executed: _ex_sp_000_UnitTest' 
	print 'Template Query: ' + @TemplateQuery 
end
 
 
declare @metasql varchar(max) 
 
set @metasql = '' 
 
 
 
declare @TemplateQueryDatabase varchar(100) 
 
set @TemplateQueryDatabase = (select TheDatabase from SSC519DEVPages1..Datasources where DataSourceID = (select DataSourceID from SSC519DEVPages1..Query where Name = @TemplateQuery)) 
-- select TheDatabase from SSC519DEVPages1..Datasources where DataSourceID = (select DataSourceID from SSC519DEVPages1..Query where Name = 'SylvanReturns')
if @ShowResults = 1
begin
	print @TemplateQueryDatabase 
end
 
set @metasql = ''  
 
declare @useInitDatetime datetime 
 
set @useInitDatetime = @InitDatetime 
 
if ISNULL(@useInitDatetime,'1/1/1980') < '2/2/1980' 
 
	set @useInitDatetime = GETDATE() 
 
 
 
declare @HeaderForSQL varchar(600) 
 
set @HeaderForSQL = 'USE ' + @TemplateQueryDatabase + ' set nocount on  ' + 
 
						'if object_id(''tempdb..#tempPort'') is not null drop table #tempPort  ' + 
 
						'if object_id(''tempdb..#totval'') is not null drop table #totval  '  
 
 
 
declare @LengthOfQueryText int 
 
set @LengthOfQueryText = (select len(Query) from SSC519DEVPages1..Query WHERE Name = @TemplateQuery) 

if @ShowResults = 1
begin
	print 'Character count of Template Query: ' + convert(varchar,@LengthOfQueryText) 
end
 
-- select * from SSC519DEVPages1..Query order by Name
-- VARIABLES: @PagesQuery_1, @PagesQuery_2, @PagesQuery_3 
 
declare @PagesQuery_1 varchar(max) 
 
set @PagesQuery_1 =  
 
	( 
 
		SELECT left(Query,5000) 
 
		FROM SSC519DEVPages1..Query  
 
		WHERE Name = @TemplateQuery 
 
	)  

print '------ 1111a ---------------------------------'
print @PagesQuery_1
 
declare @PagesQuery_2 varchar(max) 
 
set @PagesQuery_2 =  
 
	( 
 
		SELECT left(right(Query,len(Query) - len(@PagesQuery_1)),5000)  
 
		FROM SSC519DEVPages1..Query  
 
		WHERE Name = @TemplateQuery 
 
	)  
 
declare @PagesQuery_3 varchar(max) 
 
set @PagesQuery_3 =  
 
	( 
 
		SELECT left(right(Query,len(Query) - (len(@PagesQuery_1) + len(@PagesQuery_2))),5000) 
 
		FROM SSC519DEVPages1..Query  
 
		WHERE Name = @TemplateQuery 
 
	)  
 
 
 
declare @PagesQuery_4 varchar(max) 
 
set @PagesQuery_4 =  
 
	( 
 
		SELECT left(right(Query,len(Query) - (len(@PagesQuery_1) + len(@PagesQuery_2) + len(@PagesQuery_3))),5000) 
 
		FROM SSC519DEVPages1..Query  
 
		WHERE Name = @TemplateQuery 
 
	)  
 
 
 
declare @PagesQuery_5 varchar(max) 
 
set @PagesQuery_5 =  
 
	( 
 
		SELECT left(right(Query,len(Query) - (len(@PagesQuery_1) + len(@PagesQuery_2) + len(@PagesQuery_3) + len(@PagesQuery_4))),5000) 
 
		FROM SSC519DEVPages1..Query  
 
		WHERE Name = @TemplateQuery 
 
	)  
 
 
 
	 
 
-- If Parameters is empty, print out PagesQuery 
 
declare @sep char(1) 
 
set @sep = CHAR(13) 
 
IF @XmlParameters is null 
begin 
	 
 
	SELECT * FROM  dbo._ex_fn_SplitToTable(@PagesQuery_1, @sep) 
 
	union 
 
	SELECT * FROM  dbo._ex_fn_SplitToTable(@PagesQuery_2, @sep) 
 
	union 
 
	SELECT * FROM  dbo._ex_fn_SplitToTable(@PagesQuery_3, @sep) 
 
	union 
 
	SELECT * FROM  dbo._ex_fn_SplitToTable(@PagesQuery_4, @sep) 
 
	union 
 
	SELECT * FROM  dbo._ex_fn_SplitToTable(@PagesQuery_5, @sep) 
 
 
 
	goto exit_procedure 
 
end 
 
 
 
-- PARSE: Template Query using @XmlParameters 
 
SELECT  
 
    ParameterName = C.value('local-name(.)', 'varchar(50)'), 
 
    ParameterValue = C.value('(.)[1]', 'varchar(50)')  
 
    into #_ex_sp_000_UnitTest_Parameters 
 
FROM @XmlParameters.nodes('Parameters/*') AS T(C) 
 
 
 
declare @i_parse_parameters int 
 
declare @ParameterFull varchar(max) 
 
DECLARE @ParameterName varchar(50) 
 
DECLARE @ParameterValue varchar(500) 
 
 
 
DECLARE @getParameters CURSOR 
 
SET @getParameters = CURSOR FOR 
 
	select ParameterName,ParameterValue from #_ex_sp_000_UnitTest_Parameters 
 
OPEN @getParameters 
 
FETCH NEXT 
 
FROM @getParameters INTO @ParameterName,@ParameterValue 
 
WHILE @@FETCH_STATUS = 0 
 
BEGIN 
 
  -- CURSOR processing here 
 
   
 
  	SET @ParameterValue = REPLACE(@ParameterValue,'`','''') 
 
	set @ParameterValue = REPLACE(@ParameterValue,'(bar)','|')	 
 
	set @PagesQuery_1 = REPLACE(@PagesQuery_1,'%' + @ParameterName + '%',@ParameterValue) 
 
	set @PagesQuery_2 = REPLACE(@PagesQuery_2,'%' + @ParameterName + '%',@ParameterValue) 
 
	set @PagesQuery_3 = REPLACE(@PagesQuery_3,'%' + @ParameterName + '%',@ParameterValue)	 
 
	set @PagesQuery_4 = REPLACE(@PagesQuery_4,'%' + @ParameterName + '%',@ParameterValue)	 
 
	set @PagesQuery_5 = REPLACE(@PagesQuery_5,'%' + @ParameterName + '%',@ParameterValue)	 
 
			 
 
  -- CURSOR processing end 
 
FETCH NEXT 
 
FROM @getParameters INTO @ParameterName,@ParameterValue 
 
END 
 
 CLOSE @getParameters 
 
DEALLOCATE @getParameters 
 
 
 
 
 
-- 4444 PRINTOUT: If @Hijack is empty, print out PagesQuery and Run  
print '------ 4444---------------------------------'
print @HeaderForSQL+@PagesQuery_1+@PagesQuery_2+@PagesQuery_3+@PagesQuery_4+@PagesQuery_5

if LEN(@Hijack) < 1 
 
	begin 
 
		execute(@HeaderForSQL+@PagesQuery_1+@PagesQuery_2+@PagesQuery_3+@PagesQuery_4+@PagesQuery_5)  
 
		goto exit_procedure 
 
	end 
 
 
 
 
 
-- VARIABLES: @datestring, @temptableroot, @temptablefull 
 
declare @datestring varchar(25) 
 
set @datestring = convert(varchar,@useInitDatetime,25) -- @useInitDatetime 
 
set @datestring = REPLACE(@datestring,'-','') 
 
set @datestring = REPLACE(@datestring,':','') 
 
set @datestring = REPLACE(@datestring,'.','') 
 
set @datestring = REPLACE(@datestring,' ','') 
 
declare @temptableroot varchar(200) 
 
set @temptableroot = '_proctable_ex_sp_000_UnitTest_' + @datestring  
 
declare @temptablefull varchar(400) 
 
set @temptablefull = DB_NAME() + '.dbo.[' + @temptableroot + ']' 
 
-- TEST: PRINT @temptablefull 
 
 
 
-- PARSE: Template Query using @Hijack 
 
declare @i_parse_hijack int 
 
declare @HijackFull varchar(max) 
 
declare @HijackName varchar(1000) 
 
declare @HijackValue varchar(2000) 
 
set @i_parse_hijack = 0 
 
parse_hijack_on_templatequery_start: 
 
	set @i_parse_hijack = @i_parse_hijack + 1 
 
	set @HijackFull = (select dbo._ex_fn_SPLIT(@Hijack,'|',@i_parse_hijack)) 
 
	if LEN(@HijackFull) = 0 
 
		goto parse_hijack_on_templatequery_exit 
 
	set @HijackFull = LTRIM(rtrim(@HijackFull)) 
 
	SET @HijackFull = REPLACE(@HijackFull,'`','''') 
 
	-- select charindex(char(149), 'abc•def') 
 
	-- select charindex(char(149), 'abcdef') 
 
	if charindex(char(149), @HijackFull) > 0 
 
		set @HijackName = LEFT(@HijackFull,charindex(CHAR(149),@HijackFull)-1) 
 
	else 
 
		set @HijackName = LEFT(@HijackFull,charindex('=',@HijackFull)-1) 
 
	 
 
	set @HijackValue = RIGHT(@HijackFull,LEN(@HijackFull) - len(@HijackName) - 1) 
 
	SET @HijackValue = REPLACE(@HijackValue,'`','''') 
 
	set @HijackValue = REPLACE(@HijackValue,'(bar)','|') 
 
	set @HijackValue = REPLACE(@HijackValue,'#uttemp',@temptablefull) 
 
 
 
	set @PagesQuery_1 = REPLACE(@PagesQuery_1,@HijackName,@HijackValue) 
 
	set @PagesQuery_2 = REPLACE(@PagesQuery_2,@HijackName,@HijackValue) 
 
	set @PagesQuery_3 = REPLACE(@PagesQuery_3,@HijackName,@HijackValue)	 
 
	set @PagesQuery_4 = REPLACE(@PagesQuery_4,@HijackName,@HijackValue)	 
 
	set @PagesQuery_5 = REPLACE(@PagesQuery_5,@HijackName,@HijackValue)	 
 
			 
 
	goto parse_hijack_on_templatequery_start 
 
parse_hijack_on_templatequery_exit: 

if @ShowResults = 1
begin
	print @PagesQuery_1
	print @PagesQuery_2
	print @PagesQuery_3
	print @PagesQuery_4
	print @PagesQuery_5
	 
	 
	-- ECHO: Hijacked SQL (Fully parsed) 
	 
	print '------------' 
	 
	print '-- Hijacked SQL Template Query:  ' + @TemplateQuery 
	 
	print '------------' 
	 
	print @HeaderForSQL 
	print @PagesQuery_1 
	print @PagesQuery_2 
	print @PagesQuery_3 
	print @PagesQuery_4 
	print @PagesQuery_5 
	 
	print '------------' 
	 
	print '------------' 
end	 
 
 
----------------------------------------------------------------------------------------------- 
 
-- EXECUTE: PagesQuery, put results into ## table 
 
execute(@HeaderForSQL+@PagesQuery_1+@PagesQuery_2+@PagesQuery_3+@PagesQuery_4+@PagesQuery_5) 
 
--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 

if @ShowResults = 1
begin
	print 'Executed PagesQuery' 
end
 
 
-- ------------------------------ 
 
-- XML: Update Field XmlOutput 
 
declare @xmlsql varchar(max) 
 
set @xmlsql = 'SELECT  
 
	   * 
 
	FROM 
 
	( 
 
		SELECT * 
 
		FROM ' + @temptablefull + ' 
 
	) A 
 
	FOR XML PATH(''' + 'Output' + ''')' 
 
 
 
set @metasql = 'select (' + @xmlsql + ') XmlOutput into ##' + @temptableroot  
if @ShowResults = 1 
begin
	print @metasql 
end

execute(@metasql) 
  
set @metasql = 'drop table ' + @temptablefull 
 
execute(@metasql) 
 
IF OBJECT_ID('_proctable_ex_sp_000_UnitTest', 'U') IS NULL 
 
	create table _proctable_ex_sp_000_UnitTest 
 
		( 
 
		TemplateQuery varchar(100),  
 
		[XmlParameters] XML,  
 
		[XmlOutput] XML, 
 
		ExecutionTimeInSeconds float, 
 
		InitDatetime datetime null 
 
		) 
 
 
 
-- SQL: INSERT INTO _proctable_ex_sp_000_UnitTest 
 
-- select * from _proctable_ex_sp_000_UnitTest 
 
set @metasql = 'select ' + '''' + convert(varchar,@useInitDatetime,113) + '''' + ', XmlOutput From ##' + @temptableroot  
 
declare @metasql_execute varchar(max) 
 
set @metasql_execute =  'insert into _proctable_ex_sp_000_UnitTest (InitDatetime,XmlOutput) ' + @metasql 
  
execute(@metasql_execute) 

-- --------------------- 
 
-- CHECK: Execution Time 
 
declare @ExecutionTimeInSeconds float 
 
set @ExecutionTimeInSeconds = ( select datediff(ms, @useInitDatetime,getdate()) / 1000.0 ) 
 
 
 
-- ----------------------------------------- 
 
-- SQL: UPDATE _proctable_ex_sp_000_UnitTest 
 
update _proctable_ex_sp_000_UnitTest  
 
	set TemplateQuery = @TemplateQuery ,  
 
		XmlParameters = @XmlParameters ,  
 
		ExecutionTimeInSeconds = @ExecutionTimeInSeconds  
 
WHERE InitDatetime = @useInitDatetime 
 
 
 
-- OPTION: ShowResults 
 
if @ShowResults = 1 
 
	select * from _proctable_ex_sp_000_UnitTest where InitDatetime = @useInitDatetime 
 
 
 
exit_drop_globaltemp: 
 
	set @metasql = 'drop table ##' + @temptableroot 
 
	execute(@metasql) 
 
 
 
	 
 
exit_procedure:








GO


