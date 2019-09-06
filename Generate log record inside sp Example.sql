USE [Echo_Archway_Freight] 

GO 

/****** Object:  StoredProcedure [UPS].[spWriteEventLog]    Script Date: 9/10/2018 6:58:40 PM ******/ 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

/* 

    if exists (select 1 from sys.procedures where object_id = object_id('[UPS].spWriteEventLog')) drop procedure [UPS].spWriteEventLog 

go 

*/ 

  

ALTER procedure [UPS].[spWriteEventLog] 

    @Process varchar(50), 

    @ServiceExecutionID int = null, 

    @MessageType varchar(50), 

    @Message nvarchar(500), 

    @DaysToLive int = 28 

as      

    /* 

    ================================================= 

    Name: [UPS].spWriteEventLog 

    Description: writes a record to the EventLog table. fast and simple. (the store dbo.spWriteEventLog was taken as a base) 

    Author: acortez  

    Date: 2018.09.10 

    ================================================= 

    Changeset 

    Date Person Reason 

    -------------------------------------------------------------------------------------------------- 

    ================================================= 

    */ 

     

    set nocount on 

    set transaction isolation level read uncommitted 

  

    -- =================================================================================================== 

    -- Testing Start 

  

    /* 

    SET STATISTICS IO ON  

    SET STATISTICS IO OFF 

  

    SET STATISTICS TIME ON 

    SET STATISTICS TIME OFF     

    */ 

     

    --declare     @Process varchar(50) = 'TESTPROCESS', 

    --            @ServiceExecutionID int = null, 

    --            @MessageType varchar(50) = 'INFO', 

    --            @Message nvarchar(500) = 'Test Message', 

    --            @DaysToLive int = 3 

  

    --Testing End 

    --=================================================================================================== 

  

    --=================================================================================================== 

    --Execution 

    --    begin transaction 

    --    execute [UPS].spWriteEventLog 'testprocess', null, 'info', 'testmessage', 3 

    --    select * from [UPS].eventlog where Process = 'testprocess' 

    --    rollback transaction 

    --=================================================================================================== 

     

    if (isnull(@ServiceExecutionID, -1) != -1) 

        if not exists (select 1 from [UPS].ServiceExecution SE with (nolock) where SE.ServiceExecutionID = @ServiceExecutionID) 

            set @ServiceExecutionID = null 

  

    insert into [UPS].EventLog (EventDatetime, Process, ServiceExecutionID, MessageType, [Message], ExpirationDatetime) 

    values (getutcdate(), @Process, @ServiceExecutionID, @MessageType, @Message, dateadd(d, @DaysToLive, getutcdate())) 

 

  

/* 

    if exists (select 1 from sys.procedures where object_id = object_id('[UPS].spGetServiceExecution')) drop procedure [UPS].spGetServiceExecution 

go 

*/ 

  

ALTER PROCEDURE [UPS].[spGetServiceExecution] 

    @ServiceExecutionID int = null 

AS 

BEGIN TRY 

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

    SET NOCOUNT ON 

    /* 

    ================================================= 

    Name: [UPS].spGetServiceExecution 

    Description: Returns the single record of the specific ServiceExecutionID requested (the store [dbo].spGetServiceExecution was taken as a base) 

    Author: IYepez 

    Date: 2018.09.10 

    ================================================= 

    Changeset 

    Date         Person         Reason 

    2018.09.10  IYepez      Added LogForStoreProcedure. 

    -------------------------------------------------------------------------------------------------- 

    ================================================= 

    */ 

    -- =================================================================================================== 

    -- Testing Start 

  

    /* 

    SET STATISTICS IO ON  

    SET STATISTICS IO OFF 

  

    SET STATISTICS TIME ON 

    SET STATISTICS TIME OFF     

    */ 

     

    --Testing End 

    --=================================================================================================== 

  

    --=================================================================================================== 

    --Execution 

    --    execute [UPS].spGetServiceExecution 1 

    --=================================================================================================== 

    EXECUTE [UPS].spWriteEventLog 'Billing-Invoice', NULL, 'INFO', 'spGetServiceExecution: Returns the single record of the specific ServiceExecutionID requested' 

     

    select top 1 SE.ServiceExecutionID,  

        SE.InitiatedBy,  

        SE.RequestMessage,  

        SE.StartDatetime,  

        SE.StatusDatetime,  

        SE.ServiceExecutionStatusID,  

        SE.Errors,  

        SE.Warnings,  

        SE.Successes,  

        SE.ItemsExpected,  

        SE.ItemsProcessed 

        from [UPS].ServiceExecution SE with (nolock) 

        where isnull(@ServiceExecutionID, SE.ServiceExecutionID) = SE.ServiceExecutionID 

        order by SE.StartDatetime desc 

END TRY 

BEGIN CATCH 

    --An error has been occurred during the execution, check LogForStoreProcedure for more detail 

    DECLARE @ErrorMessage nvarchar(4000)=ERROR_MESSAGE(), 

            @ErrorSeverity int=ERROR_SEVERITY(), 

            @ErrorState    int=ERROR_STATE() 

             

  

    INSERT INTO UPS.LogForStoreProcedure ([StoreProcedure],[Line],[Message],[Number],[Severity],[State],[ErrorDate],[XmlParameters]) 

    VALUES (ERROR_PROCEDURE(),ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),GETDATE(),NULL) 

  

    RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) 

  

END CATCH 

 

---------------------------------- 

USE [Echo_Archway_Freight] 

GO 

  

/****** Object:  Table [UPS].[LogForStoreProcedure]    Script Date: 9/10/2018 9:19:26 PM ******/ 

SET ANSI_NULLS ON 

GO 

  

SET QUOTED_IDENTIFIER ON 

GO 

  

CREATE TABLE [UPS].[LogForStoreProcedure]( 

    [LogForStoreProcedureId] [bigint] IDENTITY(1,1) NOT NULL, 

    [StoreProcedure] [nvarchar](max) NULL, 

    [Line] [int] NULL, 

    [Message] [nvarchar](max) NULL, 

    [Number] [int] NULL, 

    [Severity] [int] NULL, 

    [State] [int] NULL, 

    [ErrorDate] [datetime] NULL, 

    [XmlParameters] [xml] NULL, 

CONSTRAINT [PK_LogForStoreProcedure] PRIMARY KEY CLUSTERED  

( 

    [LogForStoreProcedureId] ASC 

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY] 

  

GO 

  

  

--------------------------------------------------- 

USE [Echo_Archway_Freight] 

GO 

  

/****** Object:  Table [UPS].[EventLog]    Script Date: 9/10/2018 9:20:04 PM ******/ 

SET ANSI_NULLS ON 

GO 

  

SET QUOTED_IDENTIFIER ON 

GO 

  

SET ANSI_PADDING ON 

GO 

  

CREATE TABLE [UPS].[EventLog]( 

    [EventLogID] [int] IDENTITY(1,1) NOT NULL, 

    [EventDatetime] [datetime] NOT NULL CONSTRAINT [UPS_DF_EventLog_EventDatetime]  DEFAULT (getutcdate()), 

    [Process] [varchar](50) NOT NULL, 

    [ServiceExecutionID] [int] NULL CONSTRAINT [UPS_DF_EventLog_ServiceExecutionID]  DEFAULT (NULL), 

    [MessageType] [varchar](50) NOT NULL, 

    [Message] [nvarchar](500) NULL CONSTRAINT [UPS_DF_EventLog_Message]  DEFAULT (''), 

    [ExpirationDatetime] [datetime] NOT NULL, 

CONSTRAINT [PK_UPS_EventLog] PRIMARY KEY CLUSTERED  

( 

    [EventLogID] ASC 

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 

) ON [PRIMARY] 

  

GO 

  

SET ANSI_PADDING OFF 

GO 

  

ALTER TABLE [UPS].[EventLog]  WITH CHECK ADD  CONSTRAINT [FK_UPS_EventLog_ServiceExecution] FOREIGN KEY([ServiceExecutionID]) 

REFERENCES [UPS].[ServiceExecution] ([ServiceExecutionID]) 

GO 

  

ALTER TABLE [UPS].[EventLog] CHECK CONSTRAINT [FK_UPS_EventLog_ServiceExecution] 

GO 

  

 /////////////////////////////////////----------------------------------------------- 

END TRY 

BEGIN CATCH 

    --An error has been occurred during the execution, check LogForStoreProcedure for more detail 

    DECLARE @ErrorMessage nvarchar(4000)=ERROR_MESSAGE(), 

     @ErrorSeverity int=ERROR_SEVERITY(), 

            @ErrorState int=ERROR_STATE(), 

            @XmlParameters xml =( 

            SELECT ISNULL(CONVERT(varchar(max),@EchoID),'') as EchoID, 

            ISNULL(CONVERT(varchar(max),@BillingRuleID),'') as BillingRuleID, 

ISNULL(CONVERT(varchar(max),@ClientID),'') as ClientID, 

ISNULL(CONVERT(varchar(max),@ClientName),'') as ClientName, 

ISNULL(CONVERT(varchar(max),@Date),'') as Date 

     FOR XML PATH('RootXml'),TYPE) 

 
 

    INSERT INTO UPS.LogForStoreProcedure ([StoreProcedure],[Line],[Message],[Number],[Severity],[State],[ErrorDate],[XmlParameters]) 

    VALUES (ERROR_PROCEDURE(),ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),GETDATE(),@XmlParameters) 

 
 

    RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState) 

 
 

END CATCH 

 

 