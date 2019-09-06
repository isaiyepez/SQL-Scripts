USE [dbSOA]
GO

/****** Object:  StoredProcedure [dbo].[stp_Empleado_Add2]    Script Date: 05-Sep-19 10:38:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_Empleado_Add2]
	-- Add the parameters for the stored procedure here
	@EntityID			uniqueidentifier OUTPUT,

	@CURP				nvarchar(18),
    @RFC				nvarchar(13),
    @ApellidoPaterno	nvarchar(50),
    @ApellidoMaterno	nvarchar(50),
    @Nombre				nvarchar(50),
    @FechaNacimiento	date,
    @Genero				nvarchar(10),
    @LugarNacimiento	nvarchar(50),
	--sinonimo /unique /out          
    @NumeroEmpleado		int,
    @NumeroSeguroSocial	nvarchar(50),
    @FechaIngreso	date,
    @Departamento	nvarchar(50),
    @Puesto			nvarchar(50),
    @SalarioMensual	money
   
AS
BEGIN

BEGIN TRANSACTION
	EXECUTE stp_Persona_Add

	@EntityID output,
	@CURP,
    @RFC,
    @ApellidoPaterno,
    @ApellidoMaterno,
    @Nombre,
    @FechaNacimiento,
    @Genero,
    @LugarNacimiento
	--sinonimo /unique /out          
    --@NumeroEmpleado,
    --@NumeroSeguroSocial,
    --@FechaIngreso,
    --@Departamento,
    --@Puesto,
    --@SalarioMensual	

	SET @EntityID = NEWID()
INSERT INTO [dbo].[Empleado]
           ([EntityID]
           ,[NumeroEmpleado]
           ,[NumeroSeguroSocial]
           ,[FechaIngreso]
           ,[Departamento]
           ,[Puesto]
           ,[SalarioMensual])
     VALUES
           (@EntityID
           ,@NumeroEmpleado
           ,@NumeroSeguroSocial
           ,@FechaIngreso
           ,@Departamento
           ,@Puesto 
           ,@SalarioMensual)

		   IF @@ERROR <> 0
			   BEGIN
				ROLLBACK
				RETURN
			   END
		   COMMIT
END
GO