INSERT INTO product (id, name, price, picture_url)
VALUES
  (1, 'Сливочная', 320.00, 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/6.jpg'),
  (2, 'Особая', 179.00, 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/5.jpg'),
  (3, 'Молочная', 225.00, 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/4.jpg'),
  (4, 'Нюренбергская', 315.00, 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/3.jpg'),
  (5, 'Мюнхенская', 330.00, 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/2.jpg'),
  (6, 'Русская', 189.00, 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/1.jpg');

INSERT INTO orders (id, status, date_created) SELECT i, (array['pending', 'shipped', 'cancelled'])[floor(random() * 3 + 1)::INT], CURRENT_DATE - (random() * 90)::INT FROM generate_series(1, 100000) s(i);

INSERT INTO order_product (quantity, order_id, product_id) SELECT floor(1+random()*50)::INT, i, 1 + floor(random()*6)::INT % 6 FROM generate_series(1, 100000) s(i);