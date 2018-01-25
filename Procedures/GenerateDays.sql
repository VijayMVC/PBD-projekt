USE [DB]
GO
/****** Object:  StoredProcedure [dbo].[GenerateDays]    Script Date: 16.01.2018 15:24:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[GenerateDays] 
@ConferenceID int
AS
	DECLARE
	@StD datetime
	DECLARE
	@EnD datetime
	DECLARE
	@i int
	SET @i =1
	SET @StD = (SELECT TOP 1 StartDate
	FROM Conferences
	WHERE Conferences.ConferenceID = @ConferenceID)

	SET @EnD = (SELECT TOP 1 EndDate
	FROM Conferences
	WHERE Conferences.ConferenceID = @ConferenceID)

	WHILE @StD < @EnD
	BEGIN
		INSERT ConferenceDays Values (@i,@ConferenceID,@StD,0)
		SET @i = (@i +1)
		SET @StD = DATEADD(day,1,@StD)
	END
