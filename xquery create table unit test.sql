USE [SSC519Client]
GO

/****** Object:  Table [dbo].[_proctable_ex_sp_000_UnitTest]    Script Date: 08/15/2017 15:39:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[_proctable_ex_sp_000_UnitTest](
	[TemplateQuery] [varchar](100) NULL,
	[XmlParameters] [xml] NULL,
	[XmlOutput] [xml] NULL,
	[ExecutionTimeInSeconds] [float] NULL,
	[InitDatetime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


