USE [SSC519Client]
GO

/****** Object:  UserDefinedFunction [dbo].[LastDayOfMonth]    Script Date: 08/15/2017 16:58:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create Function [dbo].[LastDayOfMonth](@MyDate datetime)
returns datetime
as
Begin
declare @myreturn datetime
set @myreturn = ( SELECT DATEADD(month, ((YEAR(@MyDate) - 1900) * 12) + MONTH(@MyDate), -1) )
return @myreturn

end



GO


