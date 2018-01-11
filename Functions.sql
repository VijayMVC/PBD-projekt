CREATE FUNCTION dbo.FUNC_ConferenceDiscount(@ConferenceID int, @OrderDate datetime) 
  RETURNS decimal(10,2) AS
BEGIN
  RETURN
    (
         SELECT TOP 1 Discount
         FROM ConferenceDiscounts
         WHERE ConferenceID = @ConferenceID AND @OrderDate <= UntilDate
         ORDER BY UntilDate
    )
END

CREATE FUNCTION dbo.FUNC_IsStudent(@PersonID int) 
  RETURNS bit AS
BEGIN
  RETURN( CASE
            WHEN EXISTS(SELECT 1 FROM Students WHERE PersonID = @PersonID) 
            THEN 1
            ELSE 0
          END
      )
END

ALTER FUNCTION dbo.FUNC_TicketPrice(@TicketID int) 
  RETURNS decimal(10,2) AS
BEGIN
  RETURN
    (
      SELECT c.BasePrice * dbo.FUNC_ConferenceDiscount(t.ConferenceID, o.OrderDate) / 100 *
        dbo.FUNC_IsStudent(t.PersonID) * (1 - StudentDiscount) / 100
      FROM Tickets AS t
      JOIN Orders AS o
           ON o.OrderID = t.OrderID
      JOIN Conferences AS c
           ON c.ConferenceID = t.ConferenceID
      WHERE t.TicketID = @TicketID
    )
END

CREATE FUNCTION dbo.FUNC_WorkshopsPrice(@TicketID) 
  RETURNS decimal(10,2) AS
BEGIN
  RETURN
    (
      SELECT SUM(w.BasePrice)
      FROM WorkshopReservations AS wr
      JOIN Workshops AS w
           ON wr.WorkshopID = w.WorkshopID
      WHERE wr.TicketID = @TicketID
    ) + FUNC_TicketPrice(@TicketID);
END
