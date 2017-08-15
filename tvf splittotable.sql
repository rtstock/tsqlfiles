USE [SSC519Client]
GO

/****** Object:  UserDefinedFunction [dbo].[_ex_fn_SplitToTable]    Script Date: 08/15/2017 15:46:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[_ex_fn_SplitToTable] (@str varchar(5000), @sep char(1) = null) 
 
RETURNS @ReturnVal table (n int, s varchar(5000)) 
 
AS 
 
 
 
BEGIN 
 
    WITH Pieces(n, start, stop) AS ( 
 
      SELECT 1, 1, CHARINDEX(@sep, @str) 
 
      UNION ALL 
 
      SELECT n + 1, stop + 1, CHARINDEX(@sep, @str, stop + 1) 
 
      FROM Pieces 
 
      WHERE stop > 0 
 
       
 
    ) 
 
    insert into @ReturnVal(n,s) 
 
 
 
    SELECT n, 
 
      SUBSTRING(@str, start, CASE WHEN stop > 0 THEN stop-start ELSE 5000 END) AS s 
 
    FROM Pieces option (maxrecursion 32767) 
 
 
 
 
 
 
 
	RETURN  
 
END
GO


