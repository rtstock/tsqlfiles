USE [SSC519Client]
GO

/****** Object:  UserDefinedFunction [dbo].[_ex_fn_SPLIT]    Script Date: 08/15/2017 16:58:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[_ex_fn_SPLIT]  
 
( 
 
@nstring VARCHAR(MAX), 
 
@deliminator nvarchar(10), 
 
@index int 
 
) 
 
 
 
RETURNS VARCHAR(MAX) 
 
as 
 
begin 
 
DECLARE @position int 
 
DECLARE @ustr VARCHAR(MAX) 
 
DECLARE @pcnt int 
 
SET @position = 1 
 
SET @pcnt = 1 
 
SELECT @ustr = '' 
 
WHILE @position <= DATALENGTH(@nstring) and @pcnt <= @index 
 
BEGIN 
 
IF SUBSTRING(@nstring, @position, 1) <> @deliminator BEGIN 
 
IF @pcnt = @index BEGIN 
 
SET @ustr = @ustr + CAST(SUBSTRING(@nstring, @position, 1) AS nvarchar)  
 
END 
 
SET @position = @position + 1 
 
END 
 
ELSE BEGIN 
 
SET @position = @position + 1 
 
SET @pcnt = @pcnt + 1 
 
END 
 
END 
 
RETURN  @ustr 
 
end
GO


