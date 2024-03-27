create table Airline_Company
       (Airline_Id Number(6)
        constraint air_airline_id primary key
        , Airline_Name varchar2(25));
create table Customers
       (Customer_Id Number(6)
       constraint custs_cust_id primary key
       , First_Name varchar2(20)
       , Last_Name varchar2(30)
       constraint cust_last_name_nn not null);
create table Cities
       (City_Id Number(6)
       constraint ct_city_id primary key
       , City_Name varchar2(20)
       constraint ct_city_name_nn not null);
create table Flights
       (Flight_Id Number(6)
       constraint fl_flight_id primary key
       , City_From Number(6),
         constraint fl_city_from_fk foreign key (City_From) references
           Cities (City_Id)
       , City_To Number(6),
         constraint fl_city_to_fk foreign key (City_To) references
           Cities (City_Id)
       , Flight_Time Number(6)
         constraint fl_flight_time_nn not null
       , Flight_Date Date
         constraint fl_flight_date_nn not null
       , AirLine_Id Number(6),
         constraint fl_air_id_fk foreign key (Airline_Id) references
            Airline_Company (Airline_Id));
create table Tickets
       (Ticket_Id Number(6)
         constraint tick_ticket_id primary key
        ,Ticket_Price Number(6)
          constraint tick_ticket_price_nn not null
          constraint tick_ticket_price_ck check(Ticket_Price > 0)
        , Customer_Id Number(6),
              constraint tick_cust_id_fk foreign key (Customer_Id) references
                  Customers (Customer_Id)
        , Airline_Id Number(6),
              constraint tick_air_id_fk foreign key (Airline_Id) references
                  Airline_Company (Airline_Id)
        , Flight_Id Number(6),
               constraint tick_flight_id_fk foreign key (Flight_Id) references
                   Flights (Flight_Id));                                            
