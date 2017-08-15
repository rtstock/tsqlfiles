USE [SSC519Client]
GO

/****** Object:  UserDefinedFunction [dbo].[_ex_fn_Multiple_0040_SylvanReturns]    Script Date: 08/15/2017 15:44:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE FUNCTION [dbo].[_ex_fn_Multiple_0040_SylvanReturns] (@AsOfDate varchar(12), @Portcode varchar(30) = '%', @GrossOrNetOfFees VARCHAR(50) = '%') 

/*
-- -------------------------------------------------------------------------------------------------------------
-- Validate_0040_SylvanReturns
-- ------------------------------------------------------------------------------------------------------------- 

SELECT * FROM dbo._ex_fn_Multiple_0040_SylvanReturns('2016-09-25',DEFAULT,'Gross of Fees')
SELECT * FROM dbo._ex_fn_Multiple_0040_SylvanReturns('2016-09-25','CAHILL',DEFAULT)

*/

 
RETURNS @ReturnVal table (
  TemplateQuery		varchar(50)
,   AsOfDate		varchar(12)
,   PortfolioList		varchar(30)
,   Portcode		varchar(30)
,   auv_flavour_ext		varchar(100)
,   auv_flavour_name		varchar(100)
,   benchmark_end_weight		varchar(50)
,   class_inception_date		varchar(50)
,   class_last_invested_date		varchar(50)
,   class_node_sec_ext		varchar(50)
,   class_node_sec_id		varchar(50)
,   class_node_sec_name		varchar(100)
,   class_scheme_ext		varchar(100)
,   class_scheme_id		varchar(50)
,   class_scheme_name		varchar(100)
,   ondate_port		varchar(50)
,   port_end_weight		varchar(50)
,   port_mv		varchar(50)
,   portfolio_ext		varchar(50)
,   portfolio_id		varchar(50)
,   portfolio_name		varchar(100)
,   market_index_id		varchar(50)
,   market_index_ext		varchar(50)
,   market_index_name		varchar(100)
,   market_component_id		varchar(50)
,   market_node_sec_id		varchar(50)
,   market_node_sec_ext		varchar(100)
,   market_node_sec_name		varchar(100)
,   market_node_inception_date		varchar(50)
,   market_node_last_invested_date		varchar(50)
,   depth		varchar(50)
,   M1_benchmark		varchar(50)
,   M1_diff		varchar(50)
,   M1_port		varchar(50)
,   M2_benchmark		varchar(50)
,   M2_diff		varchar(50)
,   M2_port		varchar(50)
,   M3_benchmark		varchar(50)
,   M3_diff		varchar(50)
,   M3_port		varchar(50)
,   M4_benchmark		varchar(50)
,   M4_diff		varchar(50)
,   M4_port		varchar(50)
,   M5_benchmark		varchar(50)
,   M5_diff		varchar(50)
,   M5_port		varchar(50)
,   M6_benchmark		varchar(50)
,   M6_diff		varchar(50)
,   M6_port		varchar(50)
,   M7_benchmark		varchar(50)
,   M7_diff		varchar(50)
,   M7_port		varchar(50)
,   M8_benchmark		varchar(50)
,   M8_diff		varchar(50)
,   M8_port		varchar(50)
,   M9_benchmark		varchar(50)
,   M9_diff		varchar(50)
,   M9_port		varchar(50)
,   M10_benchmark		varchar(50)
,   M10_diff		varchar(50)
,   M10_port		varchar(50)
,   M11_benchmark		varchar(50)
,   M11_diff		varchar(50)
,   M11_port		varchar(50)
,   MTD_benchmark		varchar(50)
,   MTD_diff		varchar(50)
,   MTD_port		varchar(50)
,   QTD_benchmark		varchar(50)
,   QTD_diff		varchar(50)
,   QTD_port		varchar(50)
,   sequence		varchar(50)
,   SI_benchmark		varchar(50)
,   SI_diff		varchar(50)
,   SI_port		varchar(50)
,   WTD_port		varchar(50)
,   xml_seq		varchar(50)
,   Y1_benchmark		varchar(50)
,   Y1_diff		varchar(50)
,   Y1_port		varchar(50)
,   Y2_benchmark		varchar(50)
,   Y2_diff		varchar(50)
,   Y2_port		varchar(50)
,   Y3_benchmark		varchar(50)
,   Y3_diff		varchar(50)
,   Y3_port		varchar(50)
,   Y4_benchmark		varchar(50)
,   Y4_diff		varchar(50)
,   Y4_port		varchar(50)
,   Y5_benchmark		varchar(50)
,   Y5_diff		varchar(50)
,   Y5_port		varchar(50)
,   Y6_benchmark		varchar(50)
,   Y6_diff		varchar(50)
,   Y6_port		varchar(50)
,   Y7_benchmark		varchar(50)
,   Y7_diff		varchar(50)
,   Y7_port		varchar(50)

,   Y8_benchmark		varchar(50)
,   Y8_diff		varchar(50)
,   Y8_port		varchar(50)

,   Y9_benchmark		varchar(50)
,   Y9_diff		varchar(50)
,   Y9_port		varchar(50)

,   Y10_benchmark		varchar(50)
,   Y10_diff		varchar(50)
,   Y10_port		varchar(50)

,   Y15_benchmark		varchar(50)
,   Y15_diff		varchar(50)
,   Y15_port		varchar(50)


,   YTD_benchmark		varchar(50)
,   YTD_diff		varchar(50)
,   YTD_port		varchar(50)
,   XmlParameters		xml
,   XmlOutput		xml
,   InitDatetime		datetime

)  AS 
 
 
BEGIN 

-- ----------------------------------------
-- Gets Transactions for all accounts by Portcode and TranDescription
;WITH cte_Multiple_0040_SylvanReturns (	
			  TemplateQuery
			,   AsOfDate
			,   PortfolioList
			,   Portcode
			,   auv_flavour_ext
			,   auv_flavour_name
			,   benchmark_end_weight
			,   class_inception_date
			,   class_last_invested_date
			,   class_node_sec_ext
			,   class_node_sec_id
			,   class_node_sec_name
			,   class_scheme_ext
			,   class_scheme_id
			,   class_scheme_name
			,   ondate_port
			,   port_end_weight
			,   port_mv
			,   portfolio_ext
			,   portfolio_id
			,   portfolio_name
			,   market_index_id
			,   market_index_ext
			,   market_index_name
			,   market_component_id
			,   market_node_sec_id
			,   market_node_sec_ext
			,   market_node_sec_name
			,   market_node_inception_date
			,   market_node_last_invested_date
			,   depth
			,	M1_benchmark
			,   M1_diff
			,   M1_port
			,   M2_benchmark
			,   M2_diff
			,   M2_port
			,   M3_benchmark
			,   M3_diff
			,   M3_port
			,   M4_benchmark
			,   M4_diff
			,   M4_port
			,   M5_benchmark
			,   M5_diff
			,   M5_port
			,   M6_benchmark
			,   M6_diff
			,   M6_port
			,   M7_benchmark
			,   M7_diff
			,   M7_port
			,   M8_benchmark
			,   M8_diff
			,   M8_port
			,   M9_benchmark
			,   M9_diff
			,   M9_port
			,   M10_benchmark
			,   M10_diff
			,   M10_port
			,   M11_benchmark
			,   M11_diff
			,   M11_port
			,   MTD_benchmark
			,   MTD_diff
			,   MTD_port
			,   QTD_benchmark
			,   QTD_diff
			,   QTD_port
			,   sequence
			,   SI_benchmark
			,   SI_diff
			,   SI_port
			,   WTD_port
			,   xml_seq
			,   Y1_benchmark
			,   Y1_diff
			,   Y1_port
			,   Y2_benchmark
			,   Y2_diff
			,   Y2_port
			,   Y3_benchmark
			,   Y3_diff
			,   Y3_port
			,   Y4_benchmark
			,   Y4_diff
			,   Y4_port
			,   Y5_benchmark
			,   Y5_diff
			,   Y5_port
			,   Y6_benchmark
			,   Y6_diff
			,   Y6_port
			,   Y7_benchmark
			,   Y7_diff
			,   Y7_port

			,   Y8_benchmark
			,   Y8_diff
			,   Y8_port

			,   Y9_benchmark
			,   Y9_diff
			,   Y9_port

			,   Y10_benchmark
			,   Y10_diff
			,   Y10_port

			,   Y15_benchmark
			,   Y15_diff
			,   Y15_port

			,   YTD_benchmark
			,   YTD_diff
			,   YTD_port
			,   XmlParameters
			,   XmlOutput
			,   InitDatetime

) As
(


			select 
				*
			from
			(
				  select 
					TemplateQuery
					,  AsOfDate
					,  PortfolioList
					,  Portcode
					,  ( SELECT  node.value('.', 'varchar(100)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/auv_flavour_ext') t(node) ) as auv_flavour_ext_01
					,  ( SELECT  node.value('.', 'varchar(100)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/auv_flavour_name') t(node) ) as auv_flavour_name_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/benchmark_end_weight') t(node) ) as benchmark_end_weight_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/class_inception_date') t(node) ) as class_inception_date_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/class_last_invested_date') t(node) ) as class_last_invested_date_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/class_node_sec_ext') t(node) ) as class_node_sec_ext_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/class_node_sec_id') t(node) ) as class_node_sec_id_01
					,  ( SELECT  node.value('.', 'varchar(100)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/class_node_sec_name') t(node) ) as class_node_sec_name_01
					,  ( SELECT  node.value('.', 'varchar(100)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/class_scheme_ext') t(node) ) as class_scheme_ext_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/class_scheme_id') t(node) ) as class_scheme_id_01
					,  ( SELECT  node.value('.', 'varchar(100)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/class_scheme_name') t(node) ) as class_scheme_name_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/ondate_port') t(node) ) as ondate_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/port_end_weight') t(node) ) as port_end_weight_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/port_mv') t(node) ) as port_mv_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/portfolio_ext') t(node) ) as portfolio_ext_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/portfolio_id') t(node) ) as portfolio_id_01
					,  ( SELECT  node.value('.', 'varchar(100)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/portfolio_name') t(node) ) as portfolio_name_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/market_index_id') t(node) ) as market_index_id_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/market_index_ext') t(node) ) as market_index_ext_01
					,  ( SELECT  node.value('.', 'varchar(100)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/market_index_name') t(node) ) as market_index_name_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/market_component_id') t(node) ) as market_component_id_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/market_node_sec_id') t(node) ) as market_node_sec_id_01
					,  ( SELECT  node.value('.', 'varchar(100)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/market_node_sec_ext') t(node) ) as market_node_sec_ext_01
					,  ( SELECT  node.value('.', 'varchar(100)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/market_node_sec_name') t(node) ) as market_node_sec_name_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/market_node_inception_date') t(node) ) as market_node_inception_date_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/market_node_last_invested_date') t(node) ) as market_node_last_invested_date_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/depth') t(node) ) as depth_01
					
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M1_benchmark') t(node) ) as M1_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M1_diff') t(node) ) as M1_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M1_port') t(node) ) as M1_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M2_benchmark') t(node) ) as M2_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M2_diff') t(node) ) as M2_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M2_port') t(node) ) as M2_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M3_benchmark') t(node) ) as M3_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M3_diff') t(node) ) as M3_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M3_port') t(node) ) as M3_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M4_benchmark') t(node) ) as M4_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M4_diff') t(node) ) as M4_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M4_port') t(node) ) as M4_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M5_benchmark') t(node) ) as M5_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M5_diff') t(node) ) as M5_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M5_port') t(node) ) as M5_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M6_benchmark') t(node) ) as M6_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M6_diff') t(node) ) as M6_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M6_port') t(node) ) as M6_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M7_benchmark') t(node) ) as M7_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M7_diff') t(node) ) as M7_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M7_port') t(node) ) as M7_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M8_benchmark') t(node) ) as M8_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M8_diff') t(node) ) as M8_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M8_port') t(node) ) as M8_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M9_benchmark') t(node) ) as M9_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M9_diff') t(node) ) as M9_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M9_port') t(node) ) as M9_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M10_benchmark') t(node) ) as M10_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M10_diff') t(node) ) as M10_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M10_port') t(node) ) as M10_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M11_benchmark') t(node) ) as M11_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M11_diff') t(node) ) as M11_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/M11_port') t(node) ) as M11_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/MTD_benchmark') t(node) ) as MTD_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/MTD_diff') t(node) ) as MTD_diff_01

					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/MTD_port') t(node) ) as MTD_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/QTD_benchmark') t(node) ) as QTD_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/QTD_diff') t(node) ) as QTD_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/QTD_port') t(node) ) as QTD_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/sequence') t(node) ) as sequence_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/SI_benchmark') t(node) ) as SI_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/SI_diff') t(node) ) as SI_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/SI_port') t(node) ) as SI_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/WTD_port') t(node) ) as WTD_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/xml_seq') t(node) ) as xml_seq_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y1_benchmark') t(node) ) as Y1_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y1_diff') t(node) ) as Y1_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y1_port') t(node) ) as Y1_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y2_benchmark') t(node) ) as Y2_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y2_diff') t(node) ) as Y2_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y2_port') t(node) ) as Y2_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y3_benchmark') t(node) ) as Y3_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y3_diff') t(node) ) as Y3_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y3_port') t(node) ) as Y3_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y4_benchmark') t(node) ) as Y4_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y4_diff') t(node) ) as Y4_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y4_port') t(node) ) as Y4_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y5_benchmark') t(node) ) as Y5_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y5_diff') t(node) ) as Y5_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y5_port') t(node) ) as Y5_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y6_benchmark') t(node) ) as Y6_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y6_diff') t(node) ) as Y6_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y6_port') t(node) ) as Y6_port_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y7_benchmark') t(node) ) as Y7_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y7_diff') t(node) ) as Y7_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y7_port') t(node) ) as Y7_port_01

					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y8_benchmark') t(node) ) as Y8_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y8_diff') t(node) ) as Y8_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y8_port') t(node) ) as Y8_port_01

					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y9_benchmark') t(node) ) as Y9_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y9_diff') t(node) ) as Y9_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y9_port') t(node) ) as Y9_port_01

					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y10_benchmark') t(node) ) as Y10_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y10_diff') t(node) ) as Y10_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y10_port') t(node) ) as Y10_port_01

					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y15_benchmark') t(node) ) as Y15_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y15_diff') t(node) ) as Y15_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/Y15_port') t(node) ) as Y15_port_01


					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/YTD_benchmark') t(node) ) as YTD_benchmark_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/YTD_diff') t(node) ) as YTD_diff_01
					,  ( SELECT  node.value('.', 'varchar(50)') FROM    XmlOutput.nodes('/Output[depth/node()="1"]/YTD_port') t(node) ) as YTD_port_01
					,  XmlParameters
					,  XmlOutput
					,  InitDatetime
			
				from
				(
					-- select * from dbo._ex_fn_Validate_0040_SylvanReturns('2016-09-25',default,default)
					select * from dbo._ex_fn_Validate_0040_SylvanReturns(@AsOfDate,@Portcode, @GrossOrNetOfFees )
				) A
			) A


)

	insert into @ReturnVal ( 	
					  TemplateQuery
					,   AsOfDate
					,   PortfolioList
					,   Portcode
					,   auv_flavour_ext
					,   auv_flavour_name
					,   benchmark_end_weight
					,   class_inception_date
					,   class_last_invested_date
					,   class_node_sec_ext
					,   class_node_sec_id
					,   class_node_sec_name
					,   class_scheme_ext
					,   class_scheme_id
					,   class_scheme_name
					,   ondate_port
					,   port_end_weight
					,   port_mv
					,   portfolio_ext
					,   portfolio_id
					,   portfolio_name
					,   market_index_id
					,   market_index_ext
					,   market_index_name
					,   market_component_id
					,   market_node_sec_id
					,   market_node_sec_ext
					,   market_node_sec_name
					,   market_node_inception_date
					,   market_node_last_invested_date
					,   depth
					,   M1_benchmark
					,   M1_diff
					,   M1_port
					,   M2_benchmark
					,   M2_diff
					,   M2_port
					,   M3_benchmark
					,   M3_diff
					,   M3_port
					,   M4_benchmark
					,   M4_diff
					,   M4_port
					,   M5_benchmark
					,   M5_diff
					,   M5_port
					,   M6_benchmark
					,   M6_diff
					,   M6_port
					,   M7_benchmark
					,   M7_diff
					,   M7_port
					,   M8_benchmark
					,   M8_diff
					,   M8_port
					,   M9_benchmark
					,   M9_diff
					,   M9_port
					,   M10_benchmark
					,   M10_diff
					,   M10_port
					,   M11_benchmark
					,   M11_diff
					,   M11_port
					,   MTD_benchmark
					,   MTD_diff
					,   MTD_port
					,   QTD_benchmark
					,   QTD_diff
					,   QTD_port
					,   sequence
					,   SI_benchmark
					,   SI_diff
					,   SI_port
					,   WTD_port
					,   xml_seq
					,   Y1_benchmark
					,   Y1_diff
					,   Y1_port
					,   Y2_benchmark
					,   Y2_diff
					,   Y2_port
					,   Y3_benchmark
					,   Y3_diff
					,   Y3_port
					,   Y4_benchmark
					,   Y4_diff
					,   Y4_port
					,   Y5_benchmark
					,   Y5_diff
					,   Y5_port
					,   Y6_benchmark
					,   Y6_diff
					,   Y6_port
					,   Y7_benchmark
					,   Y7_diff
					,   Y7_port

					,   Y8_benchmark
					,   Y8_diff
					,   Y8_port

					,   Y9_benchmark
					,   Y9_diff
					,   Y9_port

					,   Y10_benchmark
					,   Y10_diff
					,   Y10_port

					,   Y15_benchmark
					,   Y15_diff
					,   Y15_port

					,   YTD_benchmark
					,   YTD_diff
					,   YTD_port
					,   XmlParameters
					,   XmlOutput
					,   InitDatetime

							)					
	select * from cte_Multiple_0040_SylvanReturns
	
	RETURN  
 
END




















GO


