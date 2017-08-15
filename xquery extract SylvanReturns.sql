-- ---------------------------
-- SylvanReturns
-- ---------------------------

DECLARE @Portcode varchar(30)
DECLARE @PGAsOfDate varchar(12)
DECLARE @AUV varchar(1)

set @Portcode = %Portcode%
set @PGAsOfDate = %PGAsOfDate%
set @AUV = %AUV%

--set @Portcode = 'FRARET'
--set @PGAsOfDate = '2016-09-30'
--set @AUV = '1'
-- ********************************************************************************************************
declare @XmlString XML
declare @Portlist varchar(500)
declare @XmlParameters XML
declare @Hijack varchar(max)
declare @idt datetime

-- ---------------
	-- -------------
	-- CURSOR: Start
	PRINT @Portcode
	---------------------------------------------------------------
	-- EXECUTE UNIT TEST PROCEDURE: To Retrieve Sylvan Portfolio ID
	set @idt = GETDATE()
	declare @portfolio_id int
	set @XmlParameters = CAST('<Parameters><Portcode>`' + @Portcode + '`</Portcode></Parameters>' as XML)
	exec _ex_sp_000_UnitTest 
			'SylvanTranslatePortcode',
			@XmlParameters,
			'select top 1 portfolio_id=select top 1 portfolio_id into #uttemp|select 0•select 0 portfolio_id INTO #uttemp',				
			@idt,
			0
			
	----------------------------------------
	-- MAKE XML: For the Sylvan Portfolio ID
	set @XmlString = (
		select XmlOutput
		from _proctable_ex_sp_000_UnitTest 
		where InitDatetime = @idt
	)

	delete from dbo._proctable_ex_sp_000_UnitTest where TemplateQuery =  'SylvanTranslatePortcode'

	----------------------------------------
	-- SET VARIABLE: @portfolio_id
	set @portfolio_id = (
		SELECT  node.value('.', 'int')
		FROM    @XmlString.nodes('/Output/portfolio_id') t(node)
	)
	----------------------------------------
	print '----------------------------------------------------------- @portfolio_id'
	print '@portfolio_id=' + convert(varchar,@portfolio_id)
	print '----------------------------------------------------------- @portfolio_id'
	
	declare @ClassSchemeID varchar(5)
	set @ClassSchemeID = '5'
	select @ClassSchemeID = case when isnull(AccountSubTypeCode,'') = '' then '5' else '0' end
	from FMCEnterpriseReportSSC519..fmc_pv_Portfolio
	where PortfolioCode = @Portcode
	print '******************************************* ClassSchemeID ******'
	print 'ClassSchemeID = ' + @ClassSchemeID 
	
	-- ----------------------------------------------------------------------------------------------------------
	-- -- EXECUTE UNIT TEST PROCEDURE:  SylvanReturns (PortfolioList=portindex;ClassScheme;depth;PGAsOfDate;Currency;AUV=AUVGross)
	set @idt = GETDATE()
	set @XmlParameters = CAST('<Parameters><Portcode>`' + @Portcode + '`</Portcode><PortfolioList>' + convert(varchar,@portfolio_id) + '</PortfolioList><AUV>'+@AUV+'</AUV><ClassScheme>'+@ClassSchemeID+'</ClassScheme><PGAsOfDate>`' + @PGAsOfDate + '`</PGAsOfDate><Currency>`BAS`</Currency><depth>1</depth></Parameters>'  as XML )
	set @Hijack =  ' from #syl_pad_port_bench_asof=into #uttemp from #syl_pad_port_bench_asof'
	exec _ex_sp_000_UnitTest 
			'SylvanReturns'
			, @XmlParameters
			, @Hijack
			, @idt
			, 0
			
	set @XmlString = (
		select XmlOutput
		from _proctable_ex_sp_000_UnitTest 
		where InitDatetime = @idt
	)

select *
from _proctable_ex_sp_000_UnitTest 
where TemplateQuery = 'SylvanReturns'
and InitDatetime = @idt

exit_procedure:
-- jm 4/9/2015