create sequence std_misc_id_seq;
-- Create table
create table std_users
(
  id                number,
  first_name        varchar2(50),
  last_name         varchar2(50),
  personal_number   varchar2(50),
  phone             varchar2(50),
  email             varchar2(50),
  status            varchar2(1),
  registration_date date
)
;
-- Create/Recreate primary, unique and foreign key constraints 
alter table std_users
  add constraint std_users_pk primary key (ID);
alter table std_users
  add constraint std_users_uk1 unique (PERSONAL_NUMBER);
-------------------------------------------------------------------------
-- Create table
create table std_products
(
  id             number,
  product_model     varchar2(100),
  product_info      varchar2(500),
  price          number,
  status         varchar2(1),
  product_quantity number
)
;
-- Create/Recreate primary, unique and foreign key constraints 
alter table std_products
  add constraint std_products_pk primary key (ID);
alter table std_products
  add constraint std_products_uk1 unique (PRODUCT_MODEL);
------------------------------------------------------------------------
-- Create table
create table std_user_orders
(
  id           number,
  user_id      number,
  product_id   number,
  order_status varchar2(20),
  order_date   date
)
;
-- Add comments to the columns 
comment on column std_user_orders.order_status
  is 'PENDING, APPROWED, REJECTED, CANCELD';
-- Create/Recreate primary, unique and foreign key constraints 
alter table std_user_orders
  add constraint std_user_orders_pk primary key (ID);
alter table std_user_orders
  add constraint std_user_orders_fk1 foreign key (USER_ID)
  references std_users (ID);
alter table std_user_orders
  add constraint std_user_orders_fk2 foreign key (PRODUCT_ID)
  references std_products (ID);
--
insert into std_users
  (id,first_name,last_name,personal_number,
   phone,email,status,registration_date)
values
  (std_misc_id_seq.nextval,'Jack','Sparrow','12345678910',
   '995555123456','jack.spawwow@pearl.ge','A',sysdate);
--
insert into std_products
  (id,product_model,product_info,
   price,status,product_quantity)
values
  (std_misc_id_seq.nextval,'G980FD','Samsung Galaxy S20',
   2450, 'A', 17);
--
select * from std_users t;
select * from std_products t;
select * from std_user_orders t;
--
commit;
