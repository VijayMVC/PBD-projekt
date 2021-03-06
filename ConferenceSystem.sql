CREATE TABLE CompanyClients (ClientID int NOT NULL UNIQUE, CompanyID int NOT NULL);
CREATE TABLE ConferenceDiscounts (DiscountID int IDENTITY NOT NULL, ConferenceID int NOT NULL, UntilDate datetime NOT NULL, Discount int DEFAULT 0 NOT NULL CHECK(Discount < 100), PRIMARY KEY (DiscountID));
CREATE TABLE Payments (PaymentID int NOT NULL, OrderID int NOT NULL, PaymentDate datetime NOT NULL, PaymentValue decimal(10, 2) NOT NULL, BankAccount varchar(255) NOT NULL, PRIMARY KEY (PaymentID, OrderID));
CREATE TABLE CompanyList (CompanyID int IDENTITY NOT NULL, CompanyName varchar(50) NOT NULL, PRIMARY KEY (CompanyID));
CREATE TABLE Students (PersonID int NOT NULL UNIQUE);
CREATE TABLE People (PersonID int IDENTITY NOT NULL, CompanyID int NULL, LastName varchar(30) NOT NULL CHECK(LastName like '[A-Z]%'), FirstName varchar(30) NOT NULL CHECK(FirstName not like '% %' and FirstName like '[A-Z]%'), PRIMARY KEY (PersonID));
CREATE TABLE Conferences (
  ConferenceID int IDENTITY NOT NULL, 
  StartDate datetime NOT NULL, 
  EndDate datetime NOT NULL, 
  Seats int NOT NULL, 
  BasePrice decimal(10, 2) NOT NULL, 
  StudentDiscount int DEFAULT 0 NOT NULL CHECK(StudentDiscount <= 100), 
  Cancelled bit DEFAULT 0 NOT NULL, PRIMARY KEY (ConferenceID)
  );
CREATE TABLE Tickets (TicketID int IDENTITY NOT NULL, OrderID int NULL, PersonID int NULL, ConferenceID int NOT NULL, ConferenceDayID int NOT NULL, PRIMARY KEY (TicketID));
CREATE TABLE ConferenceDays (ConferenceDayID int NOT NULL, ConferenceID int NOT NULL, Day datetime NOT NULL, Cancelled bit DEFAULT 0 NOT NULL, PRIMARY KEY (ConferenceDayID, ConferenceID));
CREATE TABLE Orders (OrderID int IDENTITY NOT NULL, ClientID int NOT NULL, OrderDate datetime NOT NULL, PRIMARY KEY (OrderID));
CREATE TABLE Clients (ClientID int IDENTITY NOT NULL, Email varchar(255) NOT NULL CHECK(Email like '%_@__%.__%'), Phone varchar(50) NOT NULL, PRIMARY KEY (ClientID));
CREATE TABLE WorkshopReservations (WorkshopReservationID int IDENTITY NOT NULL, WorkshopID int NOT NULL, TicketID int NOT NULL, PRIMARY KEY (WorkshopReservationID));
CREATE TABLE Workshops (WorkshopID int IDENTITY NOT NULL, ConferenceDayID int NOT NULL, ConferenceID int NOT NULL, [Start] datetime NOT NULL, Duration datetime NOT NULL, Seats int NOT NULL, BasePrice decimal(10, 2) NOT NULL, Cancelled bit DEFAULT 0 NOT NULL, PRIMARY KEY (WorkshopID));

ALTER TABLE WorkshopReservations 
ADD CONSTRAINT FKWorkshopRe860502 FOREIGN KEY (WorkshopID) REFERENCES Workshops (WorkshopID);
ALTER TABLE Tickets 
ADD CONSTRAINT FKTickets142398 FOREIGN KEY (OrderID) REFERENCES Orders (OrderID);
ALTER TABLE Payments 
ADD CONSTRAINT FKPayments509529 FOREIGN KEY (OrderID) REFERENCES Orders (OrderID);
ALTER TABLE ConferenceDiscounts 
ADD CONSTRAINT FKConference401637 FOREIGN KEY (ConferenceID) REFERENCES Conferences (ConferenceID);
ALTER TABLE CompanyClients 
ADD CONSTRAINT FKCompanyCli366084 FOREIGN KEY (CompanyID) REFERENCES CompanyList (CompanyID);
ALTER TABLE People 
ADD CONSTRAINT FKPeople592171 FOREIGN KEY (CompanyID) REFERENCES CompanyList (CompanyID);
ALTER TABLE Students ADD CONSTRAINT FKStudents337183 
  FOREIGN KEY (PersonID) REFERENCES People (PersonID);
ALTER TABLE CompanyClients ADD CONSTRAINT 
  FKCompanyCli791047 FOREIGN KEY (ClientID) REFERENCES Clients (ClientID);
ALTER TABLE Orders ADD CONSTRAINT FKOrders526427 
  FOREIGN KEY (ClientID) REFERENCES Clients (ClientID);
ALTER TABLE Workshops ADD CONSTRAINT FKWorkshops298018 
  FOREIGN KEY (ConferenceDayID, ConferenceID) REFERENCES ConferenceDays (ConferenceDayID, ConferenceID);
ALTER TABLE Workshops ADD CONSTRAINT CHK_lengthWorkshops
  CHECK (DATEDIFF(hour, Workshops.Start, Duration) < 10;
ALTER TABLE Workshops ADD CONSTRAINT CHK_lengthWorkshops2
  CHECK (DATEDIFF(day, Workshops.Start, Duration) < 1;
ALTER TABLE Workshops ADD CONSTRAINT CHK_dateWorkshops
  CHECK (Workshops.Start < Duration);
ALTER TABLE WorkshopReservations 
ADD CONSTRAINT FKWorkshopRe87875 FOREIGN KEY (TicketID) REFERENCES Tickets (TicketID);
ALTER TABLE ConferenceDays 
ADD CONSTRAINT FKConference689988 FOREIGN KEY (ConferenceID) REFERENCES Conferences (ConferenceID);
ALTER TABLE Tickets 
ADD CONSTRAINT FKTickets334897 FOREIGN KEY (ConferenceDayID, ConferenceID) REFERENCES ConferenceDays (ConferenceDayID, ConferenceID);
ALTER TABLE Tickets 
ADD CONSTRAINT FKTickets651408 FOREIGN KEY (PersonID) REFERENCES People (PersonID);
ALTER TABLE Conferences ADD CONSTRAINT CHK_date 
  CHECK (StartDate < EndDate);
ALTER TABLE Conferences ADD CONSTRAINT CHK_length 
  CHECK (DATEDIFF(day, StartDate, EndDate)) <= 4;
