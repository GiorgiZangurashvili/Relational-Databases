create view v_flights
as
select a.airline_name,
       f.flight_id as flight_number,
       f.city_from,
       f.city_to,
       f.flight_time as flight_time,
       ticket_info.num_tickets as num_sold_tickets,
       ticket_info.income as total_income,
       ((select count(*)
           from flights fl
          where fl.city_from = f.city_from
            and fl.city_to = f.city_to
            and to_char(fl.flight_date, 'dd') = to_char(f.flight_date, 'dd')) - 1) as other_flights_num
  from flights f
  join airline_company a
    on f.airline_id = a.airline_id
  join (select t.flight_id,
               count(*) num_tickets,
               count(t.ticket_price) income
          from tickets t
         group by t.flight_id) ticket_info
    on ticket_info.flight_id = f.flight_id
