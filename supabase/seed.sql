insert into categories (name, slug) values
  ('Tumbler', 'tumbler'),
  ('Tempat Makan', 'tempat-makan')
on conflict (name) do nothing;

insert into products (name, category_id, description, price, cost_price, sizes, colors, can_custom, custom_fee, image_url)
select v.name, c.id, v.description, v.price, v.cost_price, v.sizes, v.colors, true, 15000, v.image_url
from (values
  ('Aurora Tumbler 750ml','Desain elegan, nyaman dibawa setiap hari.',150000,95000,array['500ml','750ml','1000ml'],array['Rose','Blush Pink','Putih'],'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&q=80','tumbler'),
  ('Selara Tumbler Classic 500ml','Desain elegan, nyaman dibawa setiap hari.',125000,80000,array['350ml','500ml'],array['Rose','Cream','Hitam'],'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80','tumbler'),
  ('Rose Tumbler Pro 750ml','Desain elegan, nyaman dibawa setiap hari.',175000,112000,array['500ml','750ml'],array['Rose','Sage','Hitam'],'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=800&q=80','tumbler'),
  ('Blush Tumbler Mini 350ml','Desain elegan, nyaman dibawa setiap hari.',95000,62000,array['350ml'],array['Blush Pink','Putih','Cream'],'https://images.unsplash.com/photo-1595231712320-1e9d4e8d0e8f?w=800&q=80','tumbler'),
  ('Tumbler Handle Gradient 1000ml','Desain elegan, nyaman dibawa setiap hari.',195000,125000,array['750ml','1000ml'],array['Rose','Sage'],'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&q=80','tumbler'),
  ('Tumbler Straw Pink 600ml','Desain elegan, nyaman dibawa setiap hari.',135000,87000,array['500ml','750ml'],array['Blush Pink','Rose','Putih'],'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80','tumbler'),
  ('Tumbler Gold Lid 500ml','Desain elegan, nyaman dibawa setiap hari.',145000,93000,array['500ml'],array['Cream','Hitam','Rose'],'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=800&q=80','tumbler'),
  ('Tumbler Sage Office 750ml','Desain elegan, nyaman dibawa setiap hari.',155000,100000,array['500ml','750ml'],array['Sage','Cream','Putih'],'https://images.unsplash.com/photo-1595231712320-1e9d4e8d0e8f?w=800&q=80','tumbler'),
  ('Tumbler Hitam Elegan 750ml','Desain elegan, nyaman dibawa setiap hari.',140000,90000,array['500ml','750ml'],array['Hitam','Cream'],'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&q=80','tumbler'),
  ('Tumbler Duo Tone 500ml','Desain elegan, nyaman dibawa setiap hari.',165000,106000,array['500ml'],array['Rose','Blush Pink','Sage'],'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80','tumbler'),
  ('Bento Box Sage 1000ml','Desain praktis untuk menemani aktivitas sehari-hari.',120000,77000,array['800ml','1000ml'],array['Sage','Cream','Blush Pink'],'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=800&q=80','tempat-makan'),
  ('Bento Box Blush 800ml','Desain praktis untuk menemani aktivitas sehari-hari.',110000,70000,array['800ml'],array['Blush Pink','Putih','Rose'],'https://images.unsplash.com/photo-1595231712320-1e9d4e8d0e8f?w=800&q=80','tempat-makan'),
  ('Lunch Box Duo 1200ml','Desain praktis untuk menemani aktivitas sehari-hari.',145000,93000,array['1000ml','1200ml'],array['Sage','Cream'],'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&q=80','tempat-makan'),
  ('Tempat Makan Classic 1000ml','Desain praktis untuk menemani aktivitas sehari-hari.',115000,74000,array['1000ml'],array['Putih','Sage','Hitam'],'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80','tempat-makan'),
  ('Bento Box Rose 1000ml','Desain praktis untuk menemani aktivitas sehari-hari.',125000,80000,array['1000ml'],array['Rose','Blush Pink'],'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=800&q=80','tempat-makan'),
  ('Lunch Box Mini 800ml','Desain praktis untuk menemani aktivitas sehari-hari.',85000,55000,array['800ml'],array['Cream','Blush Pink','Putih'],'https://images.unsplash.com/photo-1595231712320-1e9d4e8d0e8f?w=800&q=80','tempat-makan'),
  ('Tumbler Travel 1000ml','Desain elegan, nyaman dibawa setiap hari.',185000,118000,array['1000ml'],array['Hitam','Sage','Rose'],'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&q=80','tumbler'),
  ('Tumbler Kids Pink 350ml','Desain elegan, nyaman dibawa setiap hari.',90000,58000,array['350ml'],array['Blush Pink','Rose'],'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80','tumbler'),
  ('Tempat Makan Duo Sekat 1200ml','Desain praktis untuk menemani aktivitas sehari-hari.',155000,100000,array['1200ml'],array['Sage','Putih'],'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=800&q=80','tempat-makan'),
  ('Selara Set Tumbler + Bento','Pilihan praktis untuk menemani aktivitas sehari-hari.',245000,160000,array['500ml','750ml'],array['Rose','Sage','Cream'],'https://images.unsplash.com/photo-1595231712320-1e9d4e8d0e8f?w=800&q=80','tumbler')
) as v(name, description, price, cost_price, sizes, colors, image_url, category_slug)
join categories c on c.slug = v.category_slug
where not exists (select 1 from products p where p.name = v.name);