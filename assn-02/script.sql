create or replace package online_shopping_system is
   function register_new_client(
                                p_first_name std_users.first_name%type, 
                                p_last_name std_users.last_name%type, 
                                p_personal_number std_users.personal_number%type,
                                p_phone std_users.phone%type, 
                                p_email std_users.email%type, 
                                p_status std_users.status%type 
                                ) 
   return std_users.id%type;
   procedure register_new_product( 
                                  p_product_model std_products.product_model%type, 
                                  p_product_info std_products.product_info%type, 
                                  p_price std_products.price%type,
                                  p_status std_products.status%type, 
                                  p_product_quantity std_products.product_quantity%type
                                  );
   function get_product_quantity(
                                p_product_info std_products.product_info%type, 
                                p_product_model std_products.product_model%type 
                                ) 
   return std_products.product_quantity%type;
   procedure buy_new_item(
                          p_user_personal_number std_users.personal_number%type,
                          p_product_model std_products.product_model%type,
                          p_result_code out varchar2
                          );
end online_shopping_system;

create or replace package body online_shopping_system is
    function register_new_client(
                                 p_first_name std_users.first_name%type,
                                 p_last_name std_users.last_name%type, 
                                 p_personal_number std_users.personal_number%type,
                                 p_phone std_users.phone%type, 
                                 p_email std_users.email%type, 
                                 p_status std_users.status%type)
     return std_users.id%type is
     v_id std_users.id%type;
     v_rowcount number;
     e_found_customer exception;
     begin
       v_id := std_misc_id_seq.nextval;
       select count(id) into v_rowcount
       from std_users
       where std_users.personal_number = p_personal_number;
       if v_rowcount = 0 then
          insert into std_users(id,
                                first_name,
                                last_name,
                                personal_number,
                                phone,
                                email,
                                status,
                                registration_date)
                         values(v_id,
                                p_first_name,
                                p_last_name,
                                p_personal_number,
                                p_phone,
                                p_email,
                                p_status,
                                sysdate);
          return v_id;
       else
         raise e_found_customer;         
       end if;
       
       exception
         when e_found_customer then
           dbms_output.put_line('Customer is already registered!');
           return -1;
     end;
    procedure register_new_product(
                                   p_product_model std_products.product_model%type, 
                                   p_product_info std_products.product_info%type, 
                                   p_price std_products.price%type,
                                   p_status std_products.status%type, 
                                   p_product_quantity std_products.product_quantity%type
                                   ) is
    v_rowcount number;
    v_id std_products.id%type;
    begin
      select count(id) into v_rowcount from std_products where std_products.product_model = p_product_model;
      v_id := std_misc_id_seq.nextval;
      if v_rowcount = 0 then
        insert into std_products(id,
                                 product_model,
                                 product_info,
                                 price,
                                 status,
                                 product_quantity)
                     values(
                            v_id,
                            p_product_model,
                            p_product_info,
                            p_price,
                            p_status,
                            p_product_quantity
                            );
      else
        update std_products
        set std_products.product_quantity = std_products.product_quantity + p_product_quantity
        where std_products.product_model = p_product_model;
      end if;                                    
    end;

    function get_product_quantity(
                                p_product_info std_products.product_info%type, 
                                p_product_model std_products.product_model%type 
                                ) 
    return std_products.product_quantity%type is
    v_product_quantity std_products.product_quantity%type;
    begin
      select std_products.product_quantity into v_product_quantity
      from std_products
      where std_products.product_model = p_product_model;
     
      return v_product_quantity;
      
      exception
        when NO_DATA_FOUND then
          return 0;    
    end;

    procedure buy_new_item(
                          p_user_personal_number std_users.personal_number%type,
                          p_product_model std_products.product_model%type,
                          p_result_code out varchar2
                          ) is
    cursor c_product is
           select * 
                  from std_products
                  where std_products.product_model = p_product_model;
    cursor c_user is
           select *
                  from std_users
                  where std_users.personal_number = p_user_personal_number;
    v_id std_users.id%type;
    e_product_not_found exception;
    e_zero_product exception;
    e_user_not_found exception;
    v_user_row std_users%rowtype;
    v_product_row std_products%rowtype;
    begin
      open c_product;
      fetch c_product into v_product_row;
      close c_product;
      if v_product_row.product_model is null then
        raise e_product_not_found;
      elsif v_product_row.product_quantity = 0 then
        raise e_zero_product;
      end if;
      open c_user;
      fetch c_user into v_user_row;
      if v_user_row.personal_number is null then
        raise e_user_not_found;
      end if;
      
      v_id := std_misc_id_seq.nextval;
      insert into std_user_orders(id,
                                  user_id,
                                  product_id,
                                  order_status,
                                  order_date)
                           values(v_id,
                                  v_user_row.id,
                                  v_product_row.id,
                                  'APPROWED',
                                  sysdate);
      p_result_code := 'SUCCESS';
      update std_products
      set std_products.product_quantity = std_products.product_quantity - 1
      where std_products.product_model = p_product_model;                            
      
      exception
        when e_user_not_found then
          dbms_output.put_line('User not found!');
          p_result_code := 'FAILED';
        when e_product_not_found then
          dbms_output.put_line('Product not found!');
          p_result_code := 'FAILED';
        when e_zero_product then
          dbms_output.put_line('Out of stock!');
          p_result_code := 'FAILED';                 
    end;
end online_shopping_system;                  
