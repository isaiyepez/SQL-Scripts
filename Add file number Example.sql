USE [assMasterDB] 

GO 

/****** Object:  StoredProcedure [dbo].[usp_Main_AnunciosCfe_InsertarMasivamente]    Script Date: 07/06/2017 11:57:27 a. m. ******/ 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

 
 

-- ==================== 

-- Autor:               <IYEPEZ> 

-- Fecha de creación:   <17/04/2017> 

-- Descripción:         <Inserta un registro en la tabla de AnunciosCfe Masivamente> 

-- ==================== 

 
 

/* 

Modificaciones: 

No.    Fecha          Autor                             Descripción 

---    -----          -----                             ----------- 

> 1    17/04/2017  IYEPEZ    Creación 

*/ 

ALTER procedure [dbo].[usp_Main_AILUMINA_InsertarMasivamente] 

  @i INT = 0  

AS 

        SELECT  ROW_NUMBER() OVER ( ORDER BY AnunIlu_Estatus ) Fila , 

                * 

        INTO    #tmpAnunciosIlumina 

        FROM   [dbo].[AnunciosIluminacion] 

BEGIN 

   --DECLARE @i AS INT = 1      

--Creamos el detalle de los recibos mediante un ciclo 

        WHILE @i <= ( SELECT    COUNT(*) 

                      FROM    #tmpAnunciosIlumina 

  

                    ) 

            BEGIN 

UPDATE [dbo].[AnunciosIluminacion] 

SET AnunIlu_Id = @i 

WHERE CLAVE = (select CLAVE FROM #tmpAnunciosIlumina WHERE Fila = @i) 

AND VISTA = (select VISTA FROM #tmpAnunciosIlumina WHERE Fila = @i) 

SET @i = @i + 1;  

PRINT @i;  

END 

            DROP table   #tmpAnunciosIlumina;  

        END 