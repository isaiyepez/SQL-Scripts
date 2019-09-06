USE [dbSOA]
GO

/****** Object:  StoredProcedure [dbo].[stp_Persona_Paged]    Script Date: 05-Sep-19 10:37:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_Persona_Paged]
	-- Add the parameters for the stored procedure here

	@PageNumber int,
	@PageSize int,
	@Criterio nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT [EntityID]
      ,[CURP]
      ,[RFC]
      ,[ApellidoPaterno]
      ,[ApellidoMaterno]
      ,[Nombre]
	  , ApellidoPAterno + ' ' +
	  ISNULL(ApellidoMaterno, '') + ' ' +
	  Nombre As NombreCompleto
      ,[FechaNacimiento]
	  ,[dbo].[fnc_Entity_GetAños]([FechaNacimiento]) as Edad
      ,[Genero]
      ,[LugarNacimiento]
  FROM [dbo].[Persona]
	WHERE ApellidoPAterno + ' ' +
	  ISNULL(ApellidoMaterno, '') + ' ' +
	  Nombre LIKE '%' + @Criterio + '%'
	ORDER BY ApellidoPAterno + ' ' +
	  ISNULL(ApellidoMaterno, '') + ' ' +
	  Nombre
	OFFSET @PageSize * (@PageNumber -1) ROWS FETCH NEXT @PageSize ROWS ONLY
	--A PARTIR DEL PRIMER RENGLON, EL PAGE SIZE JALA LA CANTIDAD DE RENGLONES, 
	--NO FUNCIONA EN EL 2008

	SELECT COUNT(EntityID)
	 FROM [dbo].[Persona]
	WHERE ApellidoPAterno + ' ' +
	  ISNULL(ApellidoMaterno, '') + ' ' +
	  Nombre LIKE '%' + @Criterio + '%'

	SELECT COUNT(EntityID)
	FROM [dbo].[Persona]
END
GO


